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
public class ExerciseResult {
    private String itemId;
    private boolean correct;
    private boolean firstTry;
    private int attempts;
}
