package com.example.backend.entity;

import com.example.backend.Enumeration.Goal;
import jakarta.persistence.*;
import lombok.*;

import java.util.List;

@Entity
@Data
@NoArgsConstructor
@AllArgsConstructor
public class Client {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    private double Height;
    private double Weight;
    private double Age;
    @Enumerated(EnumType.STRING)
    private Goal goal;
    @OneToMany(mappedBy = "client", cascade = CascadeType.ALL)
    private List<WorkoutPlan> workoutPlans;
    private String email;
    private String password;
}
