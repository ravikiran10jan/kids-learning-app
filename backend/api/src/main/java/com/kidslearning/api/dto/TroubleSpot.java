package com.kidslearning.api.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class TroubleSpot {
    private String itemId;
    private String skillId;
    private String prompt;
    private int missCount;
}
