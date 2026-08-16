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
public class Unit {
    private String id;
    private Subject subject;
    private String code;
    private String title;
    private List<String> skillIds;
}
