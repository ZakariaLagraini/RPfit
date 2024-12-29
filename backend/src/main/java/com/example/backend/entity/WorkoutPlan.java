package com.example.backend.entity;

import com.fasterxml.jackson.annotation.JsonManagedReference;
import com.fasterxml.jackson.annotation.JsonIgnore;  // Add this import
import jakarta.persistence.*;
import lombok.*;

import java.util.List;

@Entity
@Data
@NoArgsConstructor
@AllArgsConstructor
public class WorkoutPlan {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String name;
    private int durationInWeeks;

    @JsonManagedReference
    @OneToMany(mappedBy = "workoutPlan", cascade = CascadeType.ALL)
    private List<Exercise> exercises;

    @JsonIgnore  // Add this annotation
    @ManyToOne
    @JoinColumn(name = "client_id")
    private Client client;
}