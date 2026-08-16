package com.kidslearning.api.service;

import com.kidslearning.api.model.ItemProgress;
import org.springframework.stereotype.Service;
import java.time.LocalDate;

@Service
public class LeitnerService {

    private static final int[] REVIEW_INTERVALS_DAYS = {0, 1, 2, 4, 8, 16};

    /**
     * Calculate next box level based on current box and correctness.
     * Correct: move up one box (max 5). Incorrect: drop to box 1.
     */
    public int calculateNextBox(int currentBox, boolean correct) {
        if (correct) {
            return Math.min(currentBox + 1, 5);
        } else {
            return 1;
        }
    }

    /**
     * Calculate due date based on box level.
     * Box 1 = 1 day, Box 2 = 2 days, Box 3 = 4 days, Box 4 = 8 days, Box 5 = 16 days.
     */
    public LocalDate calculateDueDate(int box) {
        if (box < 1 || box > 5) return LocalDate.now();
        return LocalDate.now().plusDays(REVIEW_INTERVALS_DAYS[box]);
    }

    /**
     * Create a new ItemProgress for a first-time item.
     */
    public ItemProgress createInitialProgress(String itemId) {
        return ItemProgress.builder()
                .itemId(itemId)
                .box(0)
                .dueOn(LocalDate.now())
                .seen(0)
                .firstTryCorrect(0)
                .build();
    }

    /**
     * Update progress after an exercise attempt.
     */
    public ItemProgress updateProgress(ItemProgress existing, boolean firstTryCorrect) {
        int newBox = calculateNextBox(existing.getBox(), firstTryCorrect);
        return ItemProgress.builder()
                .itemId(existing.getItemId())
                .box(newBox)
                .dueOn(calculateDueDate(newBox))
                .seen(existing.getSeen() + 1)
                .firstTryCorrect(existing.getFirstTryCorrect() + (firstTryCorrect ? 1 : 0))
                .lastSeen(java.time.LocalDateTime.now())
                .build();
    }
}
