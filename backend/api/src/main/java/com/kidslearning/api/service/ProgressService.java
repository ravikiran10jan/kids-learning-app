package com.kidslearning.api.service;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.datatype.jsr310.JavaTimeModule;
import com.kidslearning.api.dto.TroubleSpot;
import com.kidslearning.api.model.*;
import com.kidslearning.api.repository.FirebaseRepository;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.util.*;
import java.util.stream.Collectors;

@Service
public class ProgressService {

    private final FirebaseRepository repository;
    private final MasteryService masteryService;
    private final ObjectMapper objectMapper;

    public ProgressService(FirebaseRepository repository, MasteryService masteryService) {
        this.repository = repository;
        this.masteryService = masteryService;
        this.objectMapper = new ObjectMapper();
        this.objectMapper.registerModule(new JavaTimeModule());
    }

    public ChildProfile getProfile(String profileId) {
        return repository.getOrCreateProfile(profileId);
    }

    public void addCoins(String profileId, int amount) {
        ChildProfile profile = repository.getOrCreateProfile(profileId);
        profile.setCoins(profile.getCoins() + amount);
        repository.saveProfile(profile);
    }

    public List<TroubleSpot> getTroubleSpots(String profileId, int limit) {
        List<ItemProgress> allProgress = repository.getAllItemProgress(profileId);
        return allProgress.stream()
                .filter(p -> p.getSeen() > 0)
                .map(p -> {
                    int misses = p.getSeen() - p.getFirstTryCorrect();
                    Item item = repository.getItem(p.getItemId());
                    String prompt = item != null && item.getPrompt() != null ? item.getPrompt().getText() : "Unknown";
                    String skillId = item != null ? item.getSkillId() : "unknown";
                    return TroubleSpot.builder()
                            .itemId(p.getItemId())
                            .skillId(skillId)
                            .prompt(prompt)
                            .missCount(misses)
                            .build();
                })
                .sorted((a, b) -> Integer.compare(b.getMissCount(), a.getMissCount()))
                .limit(limit)
                .collect(Collectors.toList());
    }

    public Map<String, Object> getDashboardData(String profileId) {
        Map<String, Object> dashboard = new HashMap<>();
        dashboard.put("profile", getProfile(profileId));
        dashboard.put("skillMastery", masteryService.getAllSkillMastery(profileId));
        dashboard.put("troubleSpots", getTroubleSpots(profileId, 10));

        // Calculate first-try accuracy
        List<ItemProgress> allProgress = repository.getAllItemProgress(profileId);
        int totalSeen = allProgress.stream().mapToInt(ItemProgress::getSeen).sum();
        int totalFirstTry = allProgress.stream().mapToInt(ItemProgress::getFirstTryCorrect).sum();
        double accuracy = totalSeen > 0 ? (double) totalFirstTry / totalSeen * 100 : 0;
        dashboard.put("firstTryAccuracy", accuracy);

        return dashboard;
    }

    public void resetSkill(String profileId, String skillId) {
        Skill skill = repository.getSkill(skillId);
        if (skill != null && skill.getItemIds() != null) {
            for (String itemId : skill.getItemIds()) {
                repository.deleteItemProgress(profileId, itemId);
            }
        }
    }

    public void enableDisableUnit(String profileId, String unitCode, boolean enabled) {
        ChildProfile profile = repository.getOrCreateProfile(profileId);
        List<String> disabled = new ArrayList<>(profile.getDisabledUnits());
        if (!enabled && !disabled.contains(unitCode)) {
            disabled.add(unitCode);
        } else if (enabled) {
            disabled.remove(unitCode);
        }
        profile.setDisabledUnits(disabled);
        repository.saveProfile(profile);
    }

    public String exportProgress(String profileId) {
        try {
            ChildProfile profile = getProfile(profileId);
            List<ItemProgress> progress = repository.getAllItemProgress(profileId);
            Map<String, Object> exportData = new HashMap<>();
            exportData.put("profile", profile);
            exportData.put("progress", progress);
            exportData.put("exportDate", java.time.LocalDateTime.now().toString());
            return objectMapper.writerWithDefaultPrettyPrinter().writeValueAsString(exportData);
        } catch (Exception e) {
            return "{\"error\": \"" + e.getMessage() + "\"}";
        }
    }

    public void wipeAllData(String profileId) {
        repository.deleteAllProgress(profileId);
        // Reset profile to fresh state
        ChildProfile fresh = ChildProfile.builder()
                .id(profileId)
                .weekStartDate(LocalDate.now().with(java.time.DayOfWeek.MONDAY))
                .build();
        repository.saveProfile(fresh);
    }

    public void updateSettings(String profileId, Map<String, Object> settings) {
        ChildProfile profile = repository.getOrCreateProfile(profileId);
        Map<String, Object> current = new HashMap<>(profile.getSettings());
        current.putAll(settings);
        profile.setSettings(current);

        // Apply known settings
        if (settings.containsKey("dailyGoalLessons")) {
            profile.setDailyGoalLessons((Integer) settings.get("dailyGoalLessons"));
        }
        if (settings.containsKey("weeklyGoalDays")) {
            profile.setWeeklyGoalDays((Integer) settings.get("weeklyGoalDays"));
        }
        repository.saveProfile(profile);
    }
}
