package com.kidslearning.api.model;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import java.time.LocalDate;
import java.util.*;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class ChildProfile {
    private String id;
    @Builder.Default
    private int coins = 0;
    @Builder.Default
    private int weeklyGoalDays = 4;
    @Builder.Default
    private int weeklyDaysPracticed = 0;
    private LocalDate weekStartDate;
    @Builder.Default
    private int dailyGoalLessons = 2;
    @Builder.Default
    private int dailyLessonsCompleted = 0;
    private LocalDate lastPracticeDate;
    @Builder.Default
    private List<String> trophyUnitIds = new ArrayList<>();
    @Builder.Default
    private List<String> petItems = new ArrayList<>();
    @Builder.Default
    private List<String> equippedPetItems = new ArrayList<>();
    @Builder.Default
    private Map<String, Object> settings = new HashMap<>();
    @Builder.Default
    private List<String> mistakeQueue = new ArrayList<>();
    @Builder.Default
    private List<String> disabledUnits = new ArrayList<>();
    @Builder.Default
    private int contentVersion = 1;
    @Builder.Default
    private Subject lastSubject = null;
}
