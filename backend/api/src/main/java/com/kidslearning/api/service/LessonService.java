package com.kidslearning.api.service;

import com.kidslearning.api.dto.Lesson;
import com.kidslearning.api.model.*;
import com.kidslearning.api.repository.FirebaseRepository;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.util.*;
import java.util.stream.Collectors;

@Service
public class LessonService {

    private static final int MIN_EXERCISES = 8;
    private static final int MAX_EXERCISES = 12;
    private static final double NEW_RATIO = 0.50;
    private static final double REVIEW_RATIO = 0.30;
    private static final double MISTAKE_RATIO = 0.20;

    private final FirebaseRepository repository;
    private final LeitnerService leitnerService;
    private final MasteryService masteryService;

    public LessonService(FirebaseRepository repository, LeitnerService leitnerService, MasteryService masteryService) {
        this.repository = repository;
        this.leitnerService = leitnerService;
        this.masteryService = masteryService;
    }

    /**
     * Compose a lesson for the given skill, following 50/30/20 ratio.
     */
    public Lesson composeLesson(String profileId, String skillId) {
        ChildProfile profile = repository.getOrCreateProfile(profileId);
        Skill skill = repository.getSkill(skillId);
        if (skill == null) throw new IllegalArgumentException("Skill not found: " + skillId);

        int totalExercises = MIN_EXERCISES;
        int newCount = (int) Math.round(totalExercises * NEW_RATIO);
        int reviewCount = (int) Math.round(totalExercises * REVIEW_RATIO);
        int mistakeCount = totalExercises - newCount - reviewCount;

        // Gather items for each category
        List<Item> newItems = getNewAndInProgressItems(profileId, skillId);
        List<Item> reviewItems = getDueReviewItems(profileId, skillId);
        List<Item> mistakeItems = getMistakeQueueItems(profile);

        // Build exercise list
        List<Item> exercises = new ArrayList<>();
        exercises.addAll(take(newItems, newCount));
        exercises.addAll(take(reviewItems, reviewCount));
        exercises.addAll(take(mistakeItems, mistakeCount));

        // If not enough items in some category, fill from others
        while (exercises.size() < MIN_EXERCISES) {
            List<Item> remaining = new ArrayList<>();
            Set<String> exerciseIds = exercises.stream().map(Item::getId).collect(Collectors.toSet());
            newItems.stream().filter(i -> !exerciseIds.contains(i.getId())).forEach(remaining::add);
            reviewItems.stream().filter(i -> !exerciseIds.contains(i.getId())).forEach(remaining::add);
            mistakeItems.stream().filter(i -> !exerciseIds.contains(i.getId())).forEach(remaining::add);
            if (remaining.isEmpty()) break;
            exercises.add(remaining.getFirst());
        }

        // Cap at MAX_EXERCISES
        if (exercises.size() > MAX_EXERCISES) {
            exercises = exercises.subList(0, MAX_EXERCISES);
        }

        // Shuffle to interleave
        Collections.shuffle(exercises);

        return Lesson.builder()
                .id(UUID.randomUUID().toString())
                .skillId(skillId)
                .exercises(exercises)
                .newCount(Math.min(newCount, newItems.size()))
                .reviewCount(Math.min(reviewCount, reviewItems.size()))
                .mistakeCount(Math.min(mistakeCount, mistakeItems.size()))
                .build();
    }

    /**
     * Submit lesson results: update Leitner boxes, coins, mistake queue, weekly goals.
     */
    public LessonResult submitLesson(String profileId, LessonResult result) {
        ChildProfile profile = repository.getOrCreateProfile(profileId);

        int coinsEarned = 0;
        List<String> newMistakes = new ArrayList<>(profile.getMistakeQueue());

        for (ExerciseResult er : result.getExerciseResults()) {
            // Get or create progress
            ItemProgress progress = repository.getItemProgress(profileId, er.getItemId());
            if (progress == null) {
                progress = leitnerService.createInitialProgress(er.getItemId());
            }

            // Update progress
            progress = leitnerService.updateProgress(progress, er.isFirstTry());
            repository.saveItemProgress(profileId, progress);

            // Coins: 1 per first-try correct
            if (er.isFirstTry() && er.isCorrect()) {
                coinsEarned++;
            }

            // Mistake queue management
            if (!er.isFirstTry()) {
                if (!newMistakes.contains(er.getItemId())) {
                    newMistakes.add(er.getItemId());
                }
            } else if (er.isFirstTry() && er.isCorrect()) {
                // Remove from mistake queue if answered correctly on first try
                newMistakes.remove(er.getItemId());
            }
        }

        // Lesson completion bonus: 5 coins
        coinsEarned += 5;
        result.setCoinsEarned(coinsEarned);

        // Update profile
        profile.setCoins(profile.getCoins() + coinsEarned);
        profile.setMistakeQueue(newMistakes);
        profile.setDailyLessonsCompleted(profile.getDailyLessonsCompleted() + 1);

        // Update weekly goal
        LocalDate today = LocalDate.now();
        if (profile.getWeekStartDate() == null || today.isAfter(profile.getWeekStartDate().plusDays(6))) {
            profile.setWeekStartDate(today.with(java.time.DayOfWeek.MONDAY));
            profile.setWeeklyDaysPracticed(0);
        }
        if (profile.getLastPracticeDate() == null || !profile.getLastPracticeDate().equals(today)) {
            profile.setWeeklyDaysPracticed(profile.getWeeklyDaysPracticed() + 1);
        }
        profile.setLastPracticeDate(today);
        Skill lessonSkill = repository.getSkill(result.getSkillId());
        if (lessonSkill != null) {
            profile.setLastSubject(lessonSkill.getSubject());
        }

        repository.saveProfile(profile);

        return result;
    }

    /**
     * Check if the next lesson should suggest the alternate subject (interleaving).
     */
    public boolean shouldSuggestAlternateSubject(String profileId) {
        ChildProfile profile = repository.getOrCreateProfile(profileId);
        return profile.getLastSubject() != null;
    }

    // --- Helper methods ---

    private List<Item> getNewAndInProgressItems(String profileId, String skillId) {
        Skill skill = repository.getSkill(skillId);
        if (skill == null) return List.of();
        return skill.getItemIds().stream()
                .map(itemId -> {
                    ItemProgress p = repository.getItemProgress(profileId, itemId);
                    return (p == null || p.getBox() < 3) ? repository.getItem(itemId) : null;
                })
                .filter(Objects::nonNull)
                .collect(Collectors.toList());
    }

    private List<Item> getDueReviewItems(String profileId, String excludeSkillId) {
        LocalDate today = LocalDate.now();
        List<ItemProgress> allProgress = repository.getAllItemProgress(profileId);
        return allProgress.stream()
                .filter(p -> p.getBox() >= 3 && p.getDueOn() != null && !p.getDueOn().isAfter(today))
                .map(p -> {
                    Item item = repository.getItem(p.getItemId());
                    return (item != null && !item.getSkillId().equals(excludeSkillId)) ? item : null;
                })
                .filter(Objects::nonNull)
                .collect(Collectors.toList());
    }

    private List<Item> getMistakeQueueItems(ChildProfile profile) {
        if (profile.getMistakeQueue() == null) return List.of();
        return profile.getMistakeQueue().stream()
                .map(repository::getItem)
                .filter(Objects::nonNull)
                .collect(Collectors.toList());
    }

    private <T> List<T> take(List<T> source, int count) {
        if (source.size() <= count) return new ArrayList<>(source);
        List<T> shuffled = new ArrayList<>(source);
        Collections.shuffle(shuffled);
        return shuffled.subList(0, count);
    }
}
