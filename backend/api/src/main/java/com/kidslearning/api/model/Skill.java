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
public class Skill {
    private String id;
    private Subject subject;
    private String unitCode;
    private String title;
    private String icon;
    private List<String> prerequisites;
    private List<String> itemIds;
}
