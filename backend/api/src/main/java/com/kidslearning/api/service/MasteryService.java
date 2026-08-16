package com.kidslearning.api.service;

import com.kidslearning.api.model.ItemProgress;
import com.kidslearning.api.model.Skill;
import com.kidslearning.api.repository.FirebaseRepository;
import org.springframework.stereotype.Service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
public class MasteryService {

    private static final int MASTERY_BOX_THRESHOLD = 3;
    private static final double MASTERY_UNLOCK_THRESHOLD = 0.80;

    private final FirebaseRepository repository;

    public MasteryService(FirebaseRepository repository) {
        this.repository = repository;
    }

    /**
     * Calculate mastery percentage for a skill.
     * Mastery = (items at box >= 3) / (total items) * 100.
     */
    public double calculateSkillMastery(String profileId, String skillId) {
        Skill skill = repository.getSkill(skillId);
        if (skill == null || skill.getItemIds() == null || skill.getItemIds().isEmpty()) {
            return 0.0;
        }

        int totalItems = skill.getItemIds().size();
        long masteredItems = skill.getItemIds().stream()
                .map(itemId -> repository.getItemProgress(profileId, itemId))
                .filter(p -> p != null && p.getBox() >= MASTERY_BOX_THRESHOLD)
                .count();

        return (double) masteredItems / totalItems * 100.0;
    }

    /**
     * Check if a skill is unlocked based on prerequisite mastery.
     */
    public boolean isSkillUnlocked(String profileId, Skill skill) {
        if (skill.getPrerequisites() == null || skill.getPrerequisites().isEmpty()) {
            return true;
        }
        return skill.getPrerequisites().stream()
                .allMatch(prereqId -> calculateSkillMastery(profileId, prereqId) >= MASTERY_UNLOCK_THRESHOLD * 100);
    }

    /**
     * Get mastery percentages for all skills.
     */
    public Map<String, Double> getAllSkillMastery(String profileId) {
        Map<String, Double> masteryMap = new HashMap<>();
        List<Skill> allSkills = repository.getAllSkills();
        for (Skill skill : allSkills) {
            masteryMap.put(skill.getId(), calculateSkillMastery(profileId, skill.getId()));
        }
        return masteryMap;
    }

    /**
     * Check if a unit is complete (all skills at >= 80% mastery).
     */
    public boolean isUnitComplete(String profileId, String unitCode) {
        List<Skill> unitSkills = repository.getAllSkills().stream()
                .filter(s -> s.getUnitCode().equals(unitCode))
                .toList();
        if (unitSkills.isEmpty()) return false;
        return unitSkills.stream()
                .allMatch(s -> calculateSkillMastery(profileId, s.getId()) >= MASTERY_UNLOCK_THRESHOLD * 100);
    }
}
