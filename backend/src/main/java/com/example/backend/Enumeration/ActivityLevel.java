package com.example.backend.Enumeration;

public enum ActivityLevel {
    SEDENTARY(1.2),   // Little or no exercise
    LIGHTLY_ACTIVE(1.375),  // Light exercise/sports 1-3 days/week
    MODERATELY_ACTIVE(1.55),  // Moderate exercise/sports 3-5 days/week
    VERY_ACTIVE(1.725),  // Hard exercise/sports 6-7 days a week
    EXTRA_ACTIVE(1.9);   // Very hard exercise, twice per day, training for a marathon, triathlon, etc.

    private final double value;

    ActivityLevel(double value) {
        this.value = value;
    }

    public double getValue() {
        return value;
    }
}
