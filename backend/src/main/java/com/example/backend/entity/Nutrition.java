package com.example.backend.entity;

import jakarta.persistence.*;
import lombok.*;

@Entity
@Data
@NoArgsConstructor
@AllArgsConstructor
public class Nutrition {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false)
    private double calories; // Total daily calories

    @Column(nullable = false)
    private double proteins; // Grams of protein

    @Column(nullable = false)
    private double carbs; // Grams of carbohydrates

    @Column(nullable = false)
    private double fats; // Grams of fat

    @OneToOne
    @JoinColumn(name = "client_id", referencedColumnName = "id", nullable = false)
    private Client client; // Link to the Client

    public Nutrition(double calories, double protein, double carbs, double fat) {
        this.calories = calories;
        this.proteins = protein;
        this.carbs = carbs;
        this.fats = fat;
    }
}
