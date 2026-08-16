package com.kidslearning.api.model;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import java.time.LocalDate;
import java.time.LocalDateTime;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class ItemProgress {
    private String itemId;
    @Builder.Default
    private int box = 0;
    private LocalDate dueOn;
    @Builder.Default
    private int seen = 0;
    @Builder.Default
    private int firstTryCorrect = 0;
    private LocalDateTime lastSeen;
}
