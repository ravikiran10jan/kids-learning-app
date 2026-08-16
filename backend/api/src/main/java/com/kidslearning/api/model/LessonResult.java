package com.kidslearning.api.model;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import java.util.List;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class LessonResult {
    private String lessonId;
    private String skillId;
    private String profileId;
    private int totalExercises;
    private int firstTryCorrectCount;
    private int coinsEarned;
    private List<ExerciseResult> exerciseResults;
}
