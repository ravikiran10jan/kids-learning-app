package com.kidslearning.api.controller;

import com.kidslearning.api.dto.Lesson;
import com.kidslearning.api.model.LessonResult;
import com.kidslearning.api.service.LessonService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/lessons")
public class LessonController {

    private final LessonService lessonService;

    public LessonController(LessonService lessonService) {
        this.lessonService = lessonService;
    }

    @GetMapping("/compose")
    public ResponseEntity<Lesson> composeLesson(
            @RequestParam String profileId,
            @RequestParam String skillId) {
        try {
            Lesson lesson = lessonService.composeLesson(profileId, skillId);
            return ResponseEntity.ok(lesson);
        } catch (IllegalArgumentException e) {
            return ResponseEntity.badRequest().build();
        }
    }

    @PostMapping("/submit")
    public ResponseEntity<LessonResult> submitLesson(@RequestBody LessonResult result) {
        String profileId = result.getProfileId();
        if (profileId == null || profileId.isBlank()) {
            return ResponseEntity.badRequest().build();
        }
        LessonResult updated = lessonService.submitLesson(profileId, result);
        return ResponseEntity.ok(updated);
    }

    @GetMapping("/suggest-alternate")
    public ResponseEntity<Boolean> suggestAlternateSubject(@RequestParam String profileId) {
        return ResponseEntity.ok(lessonService.shouldSuggestAlternateSubject(profileId));
    }
}
