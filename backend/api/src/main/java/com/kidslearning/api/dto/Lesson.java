package com.kidslearning.api.dto;

import com.kidslearning.api.model.Item;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import java.util.List;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class Lesson {
    private String id;
    private String skillId;
    private List<Item> exercises;
    private int newCount;
    private int reviewCount;
    private int mistakeCount;
}
