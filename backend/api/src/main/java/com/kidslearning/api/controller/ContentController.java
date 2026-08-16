package com.kidslearning.api.controller;

import com.kidslearning.api.model.*;
import com.kidslearning.api.repository.FirebaseRepository;
import com.kidslearning.api.service.CurriculumService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/content")
public class ContentController {

    private final CurriculumService curriculumService;
    private final FirebaseRepository repository;

    public ContentController(CurriculumService curriculumService, FirebaseRepository repository) {
        this.curriculumService = curriculumService;
        this.repository = repository;
    }

    @GetMapping("/units")
    public ResponseEntity<List<Unit>> getAllUnits() {
        return ResponseEntity.ok(curriculumService.getAllUnits());
    }

    @GetMapping("/units/{unitId}")
    public ResponseEntity<Unit> getUnit(@PathVariable String unitId) {
        Unit unit = curriculumService.getUnit(unitId);
        return unit != null ? ResponseEntity.ok(unit) : ResponseEntity.notFound().build();
    }

    @GetMapping("/skills")
    public ResponseEntity<List<Skill>> getSkillsBySubject(@RequestParam Subject subject) {
        return ResponseEntity.ok(curriculumService.getSkillsBySubject(subject));
    }

    @GetMapping("/skills/{skillId}")
    public ResponseEntity<Skill> getSkill(@PathVariable String skillId) {
        Skill skill = curriculumService.getSkill(skillId);
        return skill != null ? ResponseEntity.ok(skill) : ResponseEntity.notFound().build();
    }

    @GetMapping("/items/{itemId}")
    public ResponseEntity<Item> getItem(@PathVariable String itemId) {
        Item item = curriculumService.getItem(itemId);
        return item != null ? ResponseEntity.ok(item) : ResponseEntity.notFound().build();
    }

    @GetMapping("/items-by-skill/{skillId}")
    public ResponseEntity<List<Item>> getItemsBySkill(@PathVariable String skillId) {
        return ResponseEntity.ok(curriculumService.getItemsBySkill(skillId));
    }

    @GetMapping("/content-version")
    public ResponseEntity<Integer> getContentVersion() {
        return ResponseEntity.ok(repository.getContentVersion());
    }
}
