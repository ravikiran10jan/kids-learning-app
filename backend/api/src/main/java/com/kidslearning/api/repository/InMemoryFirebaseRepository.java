package com.kidslearning.api.repository;

import com.kidslearning.api.model.*;
import jakarta.annotation.PostConstruct;
import org.springframework.stereotype.Repository;

import java.time.LocalDate;
import java.util.*;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.atomic.AtomicInteger;
import java.util.stream.Collectors;

@Repository
public class InMemoryFirebaseRepository implements FirebaseRepository {

    private final Map<String, ChildProfile> profiles = new ConcurrentHashMap<>();
    private final Map<String, Unit> units = new ConcurrentHashMap<>();
    private final Map<String, Skill> skills = new ConcurrentHashMap<>();
    private final Map<String, Item> items = new ConcurrentHashMap<>();
    private final Map<String, Map<String, ItemProgress>> progress = new ConcurrentHashMap<>();
    private final AtomicInteger contentVersion = new AtomicInteger(1);

    @PostConstruct
    public void initSampleData() {
        // ===== ENGLISH UNITS =====
        // E1: Letters & Sounds
        Unit e1 = Unit.builder().id("eng.e1").subject(Subject.ENGLISH).code("E1")
                .title("Letters & Sounds").skillIds(List.of("eng.letters.names", "eng.letters.sounds")).build();
        units.put(e1.getId(), e1);

        Skill engLetterNames = Skill.builder().id("eng.letters.names").subject(Subject.ENGLISH)
                .unitCode("E1").title("Letter Names").icon("abc").prerequisites(new ArrayList<>())
                .itemIds(new ArrayList<>(List.of("eng.letters.names.001", "eng.letters.names.002", "eng.letters.names.003",
                        "eng.letters.names.004", "eng.letters.names.005"))).build();
        skills.put(engLetterNames.getId(), engLetterNames);

        Skill engLetterSounds = Skill.builder().id("eng.letters.sounds").subject(Subject.ENGLISH)
                .unitCode("E1").title("Letter Sounds").icon("sound").prerequisites(new ArrayList<>(List.of("eng.letters.names")))
                .itemIds(new ArrayList<>(List.of("eng.letters.sounds.001", "eng.letters.sounds.002", "eng.letters.sounds.003",
                        "eng.letters.sounds.004", "eng.letters.sounds.005"))).build();
        skills.put(engLetterSounds.getId(), engLetterSounds);

        // E1 items - pick_text exercises
        for (int i = 0; i < 5; i++) {
            String letter = String.valueOf((char) ('A' + i));
            String[] others = new String[3];
            for (int j = 0; j < 3; j++) others[j] = String.valueOf((char) ('A' + i + j + 1 > 'Z' ? 'A' + (i + j + 1) % 26 : 'A' + i + j + 1));
            items.put("eng.letters.names.00" + (i + 1), Item.builder()
                    .id("eng.letters.names.00" + (i + 1)).skillId("eng.letters.names")
                    .exerciseType(ExerciseType.pick_text)
                    .prompt(Item.Prompt.builder().text("Which letter is " + letter + "?").audio("audio/eng_letters_" + (i + 1) + ".mp3").build())
                    .answer(List.of(letter)).distractors(List.of(others))
                    .hint(Item.Hint.builder().audio("audio/hint_eng_letters_" + (i + 1) + ".mp3").removeDistractors(2).build())
                    .assets(List.of()).difficulty(1).build());
        }

        // E1 items - pick_image exercises for letter sounds
        for (int i = 0; i < 5; i++) {
            String[] words = {"apple", "ball", "cat", "dog", "egg"};
            String[] wrongWords = {"fish", "hat", "ice", "jug", "kite"};
            items.put("eng.letters.sounds.00" + (i + 1), Item.builder()
                    .id("eng.letters.sounds.00" + (i + 1)).skillId("eng.letters.sounds")
                    .exerciseType(ExerciseType.pick_image)
                    .prompt(Item.Prompt.builder().text("Which starts with " + words[i].charAt(0) + "?").audio("audio/eng_sounds_" + (i + 1) + ".mp3").build())
                    .answer(List.of(words[i])).distractors(List.of(wrongWords[i], wrongWords[(i + 1) % 5], wrongWords[(i + 2) % 5]))
                    .hint(Item.Hint.builder().audio("audio/hint_eng_sounds_" + (i + 1) + ".mp3").removeDistractors(2).build())
                    .assets(List.of("img/" + words[i] + ".png")).difficulty(1).build());
        }

        // E2: Short Vowels
        Unit e2 = Unit.builder().id("eng.e2").subject(Subject.ENGLISH).code("E2")
                .title("Short Vowels").skillIds(List.of("eng.shortvowel.a", "eng.shortvowel.e")).build();
        units.put(e2.getId(), e2);

        Skill shortA = Skill.builder().id("eng.shortvowel.a").subject(Subject.ENGLISH)
                .unitCode("E2").title("Short a words").icon("apple").prerequisites(List.of("eng.letters.sounds"))
                .itemIds(List.of("eng.shortvowel.a.001", "eng.shortvowel.a.002", "eng.shortvowel.a.003",
                        "eng.shortvowel.a.004", "eng.shortvowel.a.005")).build();
        skills.put(shortA.getId(), shortA);

        Skill shortE = Skill.builder().id("eng.shortvowel.e").subject(Subject.ENGLISH)
                .unitCode("E2").title("Short e words").icon("egg").prerequisites(List.of("eng.shortvowel.a"))
                .itemIds(List.of("eng.shortvowel.e.001", "eng.shortvowel.e.002", "eng.shortvowel.e.003")).build();
        skills.put(shortE.getId(), shortE);

        // E2 items - spell_tiles
        String[][] spellWords = {{"cat", "c", "a", "t"}, {"hat", "h", "a", "t"}, {"bat", "b", "a", "t"}, {"map", "m", "a", "p"}, {"fan", "f", "a", "n"}};
        for (int i = 0; i < 5; i++) {
            items.put("eng.shortvowel.a.00" + (i + 1), Item.builder()
                    .id("eng.shortvowel.a.00" + (i + 1)).skillId("eng.shortvowel.a")
                    .exerciseType(ExerciseType.spell_tiles)
                    .prompt(Item.Prompt.builder().text("Spell " + spellWords[i][0]).audio("audio/spell_" + spellWords[i][0] + ".mp3").build())
                    .answer(List.of(spellWords[i][1], spellWords[i][2], spellWords[i][3]))
                    .distractors(List.of("o", "s", "r"))
                    .hint(Item.Hint.builder().audio("audio/hint_" + spellWords[i][0] + ".mp3").removeDistractors(2).build())
                    .assets(List.of("img/" + spellWords[i][0] + ".png")).difficulty(1).build());
        }

        // E2 short e items - build_sentence
        items.put("eng.shortvowel.e.001", Item.builder().id("eng.shortvowel.e.001").skillId("eng.shortvowel.e")
                .exerciseType(ExerciseType.build_sentence)
                .prompt(Item.Prompt.builder().text("Put the words in order").audio("audio/eng_e_001.mp3").build())
                .answer(List.of("The", "hen", "is", "red")).distractors(List.of())
                .hint(Item.Hint.builder().audio("audio/hint_eng_e_001.mp3").removeDistractors(0).build())
                .assets(List.of()).difficulty(2).build());
        items.put("eng.shortvowel.e.002", Item.builder().id("eng.shortvowel.e.002").skillId("eng.shortvowel.e")
                .exerciseType(ExerciseType.build_sentence)
                .prompt(Item.Prompt.builder().text("Put the words in order").audio("audio/eng_e_002.mp3").build())
                .answer(List.of("I", "see", "a", "bed")).distractors(List.of())
                .hint(Item.Hint.builder().audio("audio/hint_eng_e_002.mp3").removeDistractors(0).build())
                .assets(List.of()).difficulty(2).build());
        items.put("eng.shortvowel.e.003", Item.builder().id("eng.shortvowel.e.003").skillId("eng.shortvowel.e")
                .exerciseType(ExerciseType.pick_text)
                .prompt(Item.Prompt.builder().text("Which word has the short e sound?").audio("audio/eng_e_003.mp3").build())
                .answer(List.of("bed")).distractors(List.of("bike", "bee", "bake"))
                .hint(Item.Hint.builder().audio("audio/hint_eng_e_003.mp3").removeDistractors(2).build())
                .assets(List.of()).difficulty(1).build());

        // ===== MATH UNITS =====
        // M1: Counting
        Unit m1 = Unit.builder().id("math.m1").subject(Subject.MATH).code("M1")
                .title("Counting").skillIds(List.of("math.count.to20", "math.count.objects")).build();
        units.put(m1.getId(), m1);

        Skill countTo20 = Skill.builder().id("math.count.to20").subject(Subject.MATH)
                .unitCode("M1").title("Count to 20").icon("numbers").prerequisites(List.of())
                .itemIds(List.of("math.count.to20.001", "math.count.to20.002", "math.count.to20.003",
                        "math.count.to20.004", "math.count.to20.005")).build();
        skills.put(countTo20.getId(), countTo20);

        Skill countObjects = Skill.builder().id("math.count.objects").subject(Subject.MATH)
                .unitCode("M1").title("Count Objects").icon("objects").prerequisites(List.of("math.count.to20"))
                .itemIds(List.of("math.count.objects.001", "math.count.objects.002", "math.count.objects.003",
                        "math.count.objects.004", "math.count.objects.005")).build();
        skills.put(countObjects.getId(), countObjects);

        // M1 items - pick_number
        for (int i = 0; i < 5; i++) {
            int num = i + 1;
            int next = num + 1;
            int prev = Math.max(0, num - 1);
            int far = num + 5;
            items.put("math.count.to20.00" + (i + 1), Item.builder()
                    .id("math.count.to20.00" + (i + 1)).skillId("math.count.to20")
                    .exerciseType(ExerciseType.pick_number)
                    .prompt(Item.Prompt.builder().text("What comes after " + num + "?").audio("audio/math_count_" + (i + 1) + ".mp3").build())
                    .answer(List.of(String.valueOf(next))).distractors(List.of(String.valueOf(prev), String.valueOf(far), String.valueOf(num)))
                    .hint(Item.Hint.builder().audio("audio/hint_math_count_" + (i + 1) + ".mp3").removeDistractors(2).build())
                    .assets(List.of()).difficulty(1).build());
        }

        // M1 items - count_tap
        for (int i = 0; i < 5; i++) {
            int count = i + 3;
            items.put("math.count.objects.00" + (i + 1), Item.builder()
                    .id("math.count.objects.00" + (i + 1)).skillId("math.count.objects")
                    .exerciseType(ExerciseType.count_tap)
                    .prompt(Item.Prompt.builder().text("Count the stars").audio("audio/math_countobj_" + (i + 1) + ".mp3").build())
                    .answer(List.of(String.valueOf(count))).distractors(List.of(String.valueOf(count - 1), String.valueOf(count + 1), String.valueOf(count + 2)))
                    .hint(Item.Hint.builder().audio("audio/hint_math_countobj_" + (i + 1) + ".mp3").removeDistractors(2).build())
                    .assets(List.of("img/stars_" + count + ".png")).difficulty(1).build());
        }

        // M2: Compare
        Unit m2 = Unit.builder().id("math.m2").subject(Subject.MATH).code("M2")
                .title("Compare").skillIds(List.of("math.compare.moreless", "math.compare.ordering")).build();
        units.put(m2.getId(), m2);

        Skill moreLess = Skill.builder().id("math.compare.moreless").subject(Subject.MATH)
                .unitCode("M2").title("More and Less").icon("balance").prerequisites(List.of("math.count.to20"))
                .itemIds(List.of("math.compare.moreless.001", "math.compare.moreless.002", "math.compare.moreless.003")).build();
        skills.put(moreLess.getId(), moreLess);

        Skill ordering = Skill.builder().id("math.compare.ordering").subject(Subject.MATH)
                .unitCode("M2").title("Ordering Numbers").icon("sort").prerequisites(List.of("math.compare.moreless"))
                .itemIds(List.of("math.compare.ordering.001", "math.compare.ordering.002")).build();
        skills.put(ordering.getId(), ordering);

        // M2 items - true_false
        items.put("math.compare.moreless.001", Item.builder().id("math.compare.moreless.001").skillId("math.compare.moreless")
                .exerciseType(ExerciseType.true_false)
                .prompt(Item.Prompt.builder().text("Is 7 more than 5?").audio("audio/math_compare_1.mp3").build())
                .answer(List.of("true")).distractors(List.of())
                .hint(Item.Hint.builder().audio("audio/hint_math_compare_1.mp3").removeDistractors(0).build())
                .assets(List.of()).difficulty(1).build());
        items.put("math.compare.moreless.002", Item.builder().id("math.compare.moreless.002").skillId("math.compare.moreless")
                .exerciseType(ExerciseType.true_false)
                .prompt(Item.Prompt.builder().text("Is 3 more than 8?").audio("audio/math_compare_2.mp3").build())
                .answer(List.of("false")).distractors(List.of())
                .hint(Item.Hint.builder().audio("audio/hint_math_compare_2.mp3").removeDistractors(0).build())
                .assets(List.of()).difficulty(1).build());
        items.put("math.compare.moreless.003", Item.builder().id("math.compare.moreless.003").skillId("math.compare.moreless")
                .exerciseType(ExerciseType.true_false)
                .prompt(Item.Prompt.builder().text("Is 10 equal to 10?").audio("audio/math_compare_3.mp3").build())
                .answer(List.of("true")).distractors(List.of())
                .hint(Item.Hint.builder().audio("audio/hint_math_compare_3.mp3").removeDistractors(0).build())
                .assets(List.of()).difficulty(1).build());

        // M2 items - sort_bins and number_line
        items.put("math.compare.ordering.001", Item.builder().id("math.compare.ordering.001").skillId("math.compare.ordering")
                .exerciseType(ExerciseType.sort_bins)
                .prompt(Item.Prompt.builder().text("Sort: bigger than 5 or smaller than 5").audio("audio/math_order_1.mp3").build())
                .answer(List.of("7", "8", "9")).distractors(List.of("2", "3", "4"))
                .hint(Item.Hint.builder().audio("audio/hint_math_order_1.mp3").removeDistractors(0).build())
                .assets(List.of()).difficulty(2).build());
        items.put("math.compare.ordering.002", Item.builder().id("math.compare.ordering.002").skillId("math.compare.ordering")
                .exerciseType(ExerciseType.number_line)
                .prompt(Item.Prompt.builder().text("Where is 7 on the number line?").audio("audio/math_order_2.mp3").build())
                .answer(List.of("7")).distractors(List.of())
                .hint(Item.Hint.builder().audio("audio/hint_math_order_2.mp3").removeDistractors(0).build())
                .assets(List.of("img/numberline_0_10.png")).difficulty(2).build());

        // Add match_pairs item to eng.letters.names for completeness
        items.put("eng.letters.names.006", Item.builder().id("eng.letters.names.006").skillId("eng.letters.names")
                .exerciseType(ExerciseType.match_pairs)
                .prompt(Item.Prompt.builder().text("Match uppercase to lowercase").audio("audio/eng_match_1.mp3").build())
                .answer(List.of("A-a", "B-b", "C-c")).distractors(List.of())
                .hint(Item.Hint.builder().audio("audio/hint_eng_match_1.mp3").removeDistractors(0).build())
                .assets(List.of()).difficulty(1).build());
        engLetterNames.getItemIds().add("eng.letters.names.006");

        // Add listen_and_answer item
        items.put("eng.letters.sounds.006", Item.builder().id("eng.letters.sounds.006").skillId("eng.letters.sounds")
                .exerciseType(ExerciseType.listen_and_answer)
                .prompt(Item.Prompt.builder().text("Listen: The cat sat on a mat. The cat is fat.").audio("audio/eng_listen_1.mp3").build())
                .answer(List.of("cat")).distractors(List.of("dog", "hat", "bat"))
                .hint(Item.Hint.builder().audio("audio/hint_eng_listen_1.mp3").removeDistractors(2).build())
                .assets(List.of()).difficulty(2).build());
        engLetterSounds.getItemIds().add("eng.letters.sounds.006");
    }

    // ===== Profile operations =====
    @Override
    public ChildProfile getOrCreateProfile(String profileId) {
        return profiles.computeIfAbsent(profileId, id -> ChildProfile.builder()
                .id(id).weekStartDate(LocalDate.now().with(java.time.DayOfWeek.MONDAY)).build());
    }

    @Override
    public void saveProfile(ChildProfile profile) {
        profiles.put(profile.getId(), profile);
    }

    // ===== Unit operations =====
    @Override
    public List<Unit> getAllUnits() { return new ArrayList<>(units.values()); }

    @Override
    public Unit getUnit(String unitId) { return units.get(unitId); }

    @Override
    public void saveUnit(Unit unit) { units.put(unit.getId(), unit); }

    @Override
    public void deleteUnit(String unitId) { units.remove(unitId); }

    // ===== Skill operations =====
    @Override
    public List<Skill> getAllSkills() { return new ArrayList<>(skills.values()); }

    @Override
    public List<Skill> getSkillsBySubject(Subject subject) {
        return skills.values().stream().filter(s -> s.getSubject() == subject).collect(Collectors.toList());
    }

    @Override
    public Skill getSkill(String skillId) { return skills.get(skillId); }

    @Override
    public void saveSkill(Skill skill) { skills.put(skill.getId(), skill); }

    @Override
    public void deleteSkill(String skillId) { skills.remove(skillId); }

    // ===== Item operations =====
    @Override
    public List<Item> getAllItems() { return new ArrayList<>(items.values()); }

    @Override
    public Item getItem(String itemId) { return items.get(itemId); }

    @Override
    public List<Item> getItemsBySkill(String skillId) {
        return items.values().stream().filter(i -> i.getSkillId().equals(skillId)).collect(Collectors.toList());
    }

    @Override
    public void saveItem(Item item) { items.put(item.getId(), item); }

    @Override
    public void deleteItem(String itemId) { items.remove(itemId); }

    // ===== Progress operations =====
    @Override
    public ItemProgress getItemProgress(String profileId, String itemId) {
        Map<String, ItemProgress> profileProgress = progress.get(profileId);
        if (profileProgress == null) return null;
        return profileProgress.get(itemId);
    }

    @Override
    public void saveItemProgress(String profileId, ItemProgress itemProgress) {
        progress.computeIfAbsent(profileId, k -> new ConcurrentHashMap<>()).put(itemProgress.getItemId(), itemProgress);
    }

    @Override
    public List<ItemProgress> getAllItemProgress(String profileId) {
        Map<String, ItemProgress> profileProgress = progress.get(profileId);
        if (profileProgress == null) return List.of();
        return new ArrayList<>(profileProgress.values());
    }

    @Override
    public void deleteItemProgress(String profileId, String itemId) {
        Map<String, ItemProgress> profileProgress = progress.get(profileId);
        if (profileProgress != null) profileProgress.remove(itemId);
    }

    @Override
    public void deleteAllProgress(String profileId) {
        progress.remove(profileId);
    }

    // ===== Content version =====
    @Override
    public int getContentVersion() { return contentVersion.get(); }

    @Override
    public void setContentVersion(int version) { contentVersion.set(version); }
}
