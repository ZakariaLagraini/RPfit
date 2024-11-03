package com.example.backend.entity;

import jakarta.persistence.*;
import lombok.*;

import java.time.LocalDate;

@Entity
@Data
@NoArgsConstructor
@AllArgsConstructor
public class Progress {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne
    @JoinColumn(name = "client_id", nullable = false)
    private Client client;

    @ManyToOne
    @JoinColumn(name = "exercise_id", nullable = false)
    private Exercise exercise;

    private LocalDate date; // Date of the progress record

    private int repetitions; // Number of repetitions completed
    private double weight; // Weight lifted
    private int sets; // Number of sets completed
    private double duration; // Duration of the exercise in minutes (if applicable)

    private String notes; // Any additional notes or comments on progress
}

