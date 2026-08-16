package com.kidslearning.api.model;

import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import java.util.List;
import java.util.Map;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class Item {
    private String id;
    private String skillId;
    private ExerciseType exerciseType;
    private Prompt prompt;
    private List<String> answer;
    private List<String> distractors;
    private Hint hint;
    private List<String> assets;
    private int difficulty;

    @Data
    @Builder
    @NoArgsConstructor
    @AllArgsConstructor
    public static class Prompt {
        private String text;
        private String audio;
    }

    @Data
    @Builder
    @NoArgsConstructor
    @AllArgsConstructor
    public static class Hint {
        private String audio;
        private int removeDistractors;
    }
}
