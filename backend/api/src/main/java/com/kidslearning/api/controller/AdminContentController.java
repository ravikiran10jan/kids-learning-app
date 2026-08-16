package com.kidslearning.api.controller;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.kidslearning.api.model.*;
import com.kidslearning.api.repository.FirebaseRepository;
import com.kidslearning.api.service.CurriculumService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.*;

@RestController
@RequestMapping("/api/admin")
public class AdminContentController {

    private final FirebaseRepository repository;
    private final CurriculumService curriculumService;
    private final ObjectMapper objectMapper = new ObjectMapper();

    public AdminContentController(FirebaseRepository repository, CurriculumService curriculumService) {
        this.repository = repository;
        this.curriculumService = curriculumService;
    }

    // ===== UNITS =====
    @GetMapping("/units")
    public ResponseEntity<List<Unit>> listUnits() {
        return ResponseEntity.ok(repository.getAllUnits());
    }

    @PostMapping("/units")
    public ResponseEntity<Unit> createUnit(@RequestBody Unit unit) {
        repository.saveUnit(unit);
        return ResponseEntity.ok(unit);
    }

    @PutMapping("/units/{id}")
    public ResponseEntity<Unit> updateUnit(@PathVariable String id, @RequestBody Unit unit) {
        unit.setId(id);
        repository.saveUnit(unit);
        return ResponseEntity.ok(unit);
    }

    @DeleteMapping("/units/{id}")
    public ResponseEntity<Void> deleteUnit(@PathVariable String id) {
        repository.deleteUnit(id);
        return ResponseEntity.ok().build();
    }

    // ===== SKILLS =====
    @GetMapping("/skills")
    public ResponseEntity<List<Skill>> listSkills(@RequestParam(required = false) Subject subject) {
        if (subject != null) {
            return ResponseEntity.ok(repository.getSkillsBySubject(subject));
        }
        return ResponseEntity.ok(repository.getAllSkills());
    }

    @PostMapping("/skills")
    public ResponseEntity<Skill> createSkill(@RequestBody Skill skill) {
        repository.saveSkill(skill);
        return ResponseEntity.ok(skill);
    }

    @PutMapping("/skills/{id}")
    public ResponseEntity<Skill> updateSkill(@PathVariable String id, @RequestBody Skill skill) {
        skill.setId(id);
        repository.saveSkill(skill);
        return ResponseEntity.ok(skill);
    }

    @DeleteMapping("/skills/{id}")
    public ResponseEntity<Void> deleteSkill(@PathVariable String id) {
        repository.deleteSkill(id);
        return ResponseEntity.ok().build();
    }

    // ===== ITEMS =====
    @GetMapping("/items")
    public ResponseEntity<List<Item>> listItems(
            @RequestParam(required = false) String skillId,
            @RequestParam(required = false) ExerciseType exerciseType) {
        List<Item> items;
        if (skillId != null) {
            items = repository.getItemsBySkill(skillId);
        } else {
            items = repository.getAllItems();
        }
        if (exerciseType != null) {
            items = items.stream().filter(i -> i.getExerciseType() == exerciseType).toList();
        }
        return ResponseEntity.ok(items);
    }

    @PostMapping("/items")
    public ResponseEntity<Item> createItem(@RequestBody Item item) {
        repository.saveItem(item);
        return ResponseEntity.ok(item);
    }

    @PutMapping("/items/{id}")
    public ResponseEntity<Item> updateItem(@PathVariable String id, @RequestBody Item item) {
        item.setId(id);
        repository.saveItem(item);
        return ResponseEntity.ok(item);
    }

    @DeleteMapping("/items/{id}")
    public ResponseEntity<Void> deleteItem(@PathVariable String id) {
        repository.deleteItem(id);
        return ResponseEntity.ok().build();
    }

    @PostMapping("/items/bulk")
    public ResponseEntity<Map<String, Object>> bulkCreateItems(@RequestBody List<Item> items) {
        for (Item item : items) {
            repository.saveItem(item);
        }
        return ResponseEntity.ok(Map.of("imported", items.size()));
    }

    // ===== IMPORT / EXPORT =====
    @PostMapping("/import/json")
    public ResponseEntity<Map<String, Object>> importJson(@RequestBody String jsonContent) {
        try {
            JsonNode root = objectMapper.readTree(jsonContent);
            int importedCount = 0;

            if (root.has("unit")) {
                Unit unit = objectMapper.treeToValue(root.get("unit"), Unit.class);
                repository.saveUnit(unit);
            }
            if (root.has("skills")) {
                for (JsonNode node : root.get("skills")) {
                    Skill skill = objectMapper.treeToValue(node, Skill.class);
                    repository.saveSkill(skill);
                }
            }
            if (root.has("items")) {
                for (JsonNode node : root.get("items")) {
                    Item item = objectMapper.treeToValue(node, Item.class);
                    repository.saveItem(item);
                    importedCount++;
                }
            }

            Map<String, Object> result = new HashMap<>();
            result.put("imported", importedCount);
            result.put("status", "success");
            return ResponseEntity.ok(result);
        } catch (Exception e) {
            Map<String, Object> error = new HashMap<>();
            error.put("status", "error");
            error.put("message", e.getMessage());
            return ResponseEntity.badRequest().body(error);
        }
    }

    @GetMapping("/export/all")
    public ResponseEntity<Map<String, Object>> exportAll() {
        Map<String, Object> data = new HashMap<>();
        data.put("units", repository.getAllUnits());
        data.put("skills", repository.getAllSkills());
        data.put("items", repository.getAllItems());
        return ResponseEntity.ok(data);
    }

    @GetMapping("/export/unit/{unitCode}")
    public ResponseEntity<Map<String, Object>> exportUnit(@PathVariable String unitCode) {
        Map<String, Object> data = new HashMap<>();
        List<Skill> unitSkills = repository.getAllSkills().stream()
                .filter(s -> s.getUnitCode().equals(unitCode)).toList();
        List<Item> unitItems = unitSkills.stream()
                .flatMap(s -> repository.getItemsBySkill(s.getId()).stream()).toList();
        data.put("unit", repository.getAllUnits().stream()
                .filter(u -> u.getCode().equals(unitCode)).findFirst().orElse(null));
        data.put("skills", unitSkills);
        data.put("items", unitItems);
        return ResponseEntity.ok(data);
    }

    @GetMapping("/export/skill/{skillId}")
    public ResponseEntity<Map<String, Object>> exportSkill(@PathVariable String skillId) {
        Map<String, Object> data = new HashMap<>();
        data.put("skill", repository.getSkill(skillId));
        data.put("items", repository.getItemsBySkill(skillId));
        return ResponseEntity.ok(data);
    }

    // ===== CONTENT VERSION =====
    @PutMapping("/content-version")
    public ResponseEntity<Integer> incrementContentVersion() {
        int newVersion = repository.getContentVersion() + 1;
        repository.setContentVersion(newVersion);
        return ResponseEntity.ok(newVersion);
    }

    // ===== HEALTH CHECK =====
    @GetMapping("/health")
    public ResponseEntity<Map<String, Object>> contentHealth() {
        Map<String, Object> health = new HashMap<>();
        List<Item> allItems = repository.getAllItems();
        List<Skill> allSkills = repository.getAllSkills();

        long missingAudio = allItems.stream()
                .filter(i -> i.getPrompt() == null || i.getPrompt().getAudio() == null || i.getPrompt().getAudio().isEmpty())
                .count();
        long missingImages = allItems.stream()
                .filter(i -> i.getAssets() == null || i.getAssets().isEmpty())
                .count();
        long missingDistractors = allItems.stream()
                .filter(i -> i.getDistractors() == null || i.getDistractors().isEmpty())
                .count();
        List<String> smallSkills = allSkills.stream()
                .filter(s -> s.getItemIds() == null || s.getItemIds().size() < 5)
                .map(Skill::getId)
                .toList();

        health.put("totalUnits", repository.getAllUnits().size());
        health.put("totalSkills", allSkills.size());
        health.put("totalItems", allItems.size());
        health.put("itemsWithMissingAudio", missingAudio);
        health.put("itemsWithMissingImages", missingImages);
        health.put("itemsWithNoDistractors", missingDistractors);
        health.put("skillsWithFewerThan5Items", smallSkills);
        return ResponseEntity.ok(health);
    }
}
