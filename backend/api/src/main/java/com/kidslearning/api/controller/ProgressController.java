package com.kidslearning.api.controller;

import com.kidslearning.api.dto.TroubleSpot;
import com.kidslearning.api.model.ChildProfile;
import com.kidslearning.api.service.ProgressService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/progress")
public class ProgressController {

    private final ProgressService progressService;

    public ProgressController(ProgressService progressService) {
        this.progressService = progressService;
    }

    @GetMapping("/profile/{profileId}")
    public ResponseEntity<ChildProfile> getProfile(@PathVariable String profileId) {
        return ResponseEntity.ok(progressService.getProfile(profileId));
    }

    @GetMapping("/dashboard/{profileId}")
    public ResponseEntity<Map<String, Object>> getDashboard(@PathVariable String profileId) {
        return ResponseEntity.ok(progressService.getDashboardData(profileId));
    }

    @GetMapping("/trouble-spots/{profileId}")
    public ResponseEntity<List<TroubleSpot>> getTroubleSpots(
            @PathVariable String profileId,
            @RequestParam(defaultValue = "10") int limit) {
        return ResponseEntity.ok(progressService.getTroubleSpots(profileId, limit));
    }

    @PostMapping("/settings/{profileId}")
    public ResponseEntity<Void> updateSettings(
            @PathVariable String profileId,
            @RequestBody Map<String, Object> settings) {
        progressService.updateSettings(profileId, settings);
        return ResponseEntity.ok().build();
    }

    @PostMapping("/reset-skill/{profileId}")
    public ResponseEntity<Void> resetSkill(
            @PathVariable String profileId,
            @RequestParam String skillId) {
        progressService.resetSkill(profileId, skillId);
        return ResponseEntity.ok().build();
    }

    @PostMapping("/toggle-unit/{profileId}")
    public ResponseEntity<Void> toggleUnit(
            @PathVariable String profileId,
            @RequestParam String unitCode,
            @RequestParam boolean enabled) {
        progressService.enableDisableUnit(profileId, unitCode, enabled);
        return ResponseEntity.ok().build();
    }

    @GetMapping("/export/{profileId}")
    public ResponseEntity<String> exportProgress(@PathVariable String profileId) {
        return ResponseEntity.ok(progressService.exportProgress(profileId));
    }

    @PostMapping("/wipe/{profileId}")
    public ResponseEntity<Void> wipeAllData(@PathVariable String profileId) {
        progressService.wipeAllData(profileId);
        return ResponseEntity.ok().build();
    }

    @PostMapping("/coins/{profileId}")
    public ResponseEntity<Void> addCoins(
            @PathVariable String profileId,
            @RequestParam int amount) {
        progressService.addCoins(profileId, amount);
        return ResponseEntity.ok().build();
    }
}
