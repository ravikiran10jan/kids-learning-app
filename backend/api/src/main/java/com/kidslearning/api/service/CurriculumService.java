package com.kidslearning.api.service;

import com.kidslearning.api.model.*;
import com.kidslearning.api.repository.FirebaseRepository;
import org.springframework.stereotype.Service;
import java.util.List;

@Service
public class CurriculumService {

    private final FirebaseRepository repository;

    public CurriculumService(FirebaseRepository repository) {
        this.repository = repository;
    }

    public List<Unit> getAllUnits() {
        return repository.getAllUnits();
    }

    public Unit getUnit(String unitId) {
        return repository.getUnit(unitId);
    }

    public List<Skill> getSkillsBySubject(Subject subject) {
        return repository.getSkillsBySubject(subject);
    }

    public List<Skill> getAllSkills() {
        return repository.getAllSkills();
    }

    public Skill getSkill(String skillId) {
        return repository.getSkill(skillId);
    }

    public Item getItem(String itemId) {
        return repository.getItem(itemId);
    }

    public List<Item> getItemsBySkill(String skillId) {
        return repository.getItemsBySkill(skillId);
    }

    public List<Item> getAllItems() {
        return repository.getAllItems();
    }
}
