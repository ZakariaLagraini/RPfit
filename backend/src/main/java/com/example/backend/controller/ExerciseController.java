package com.example.backend.controller;

import com.example.backend.entity.Exercise;
import com.example.backend.service.ExerciseService;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Optional;

@RestController
@RequestMapping("/api/exercises")
public class ExerciseController {

    private final ExerciseService exerciseService;

    public ExerciseController(ExerciseService exerciseService) {
        this.exerciseService = exerciseService;
    }

    // Create a new exercise
    @PostMapping
    public ResponseEntity<Exercise> createExercise(@RequestBody Exercise exercise) {
        Exercise createdExercise = exerciseService.addExercise(exercise);
        return new ResponseEntity<>(createdExercise, HttpStatus.CREATED);
    }

    // Update an existing exercise by ID
    @PutMapping("/{id}")
    public ResponseEntity<Exercise> updateExercise(
            @PathVariable Long id,
            @RequestBody Exercise updatedExercise) {
        Exercise exercise = exerciseService.updateExercise(id, updatedExercise);
        if (exercise != null) {
            return new ResponseEntity<>(exercise, HttpStatus.OK);
        } else {
            return new ResponseEntity<>(HttpStatus.NOT_FOUND);
        }
    }

    // Get all exercises for a specific workout plan
    @GetMapping("/workoutPlan/{workoutPlanId}")
    public ResponseEntity<List<Exercise>> getExercisesByWorkoutPlanId(@PathVariable Long workoutPlanId) {
        List<Exercise> exercises = exerciseService.getExercisesByWorkoutPlanId(workoutPlanId);
        return new ResponseEntity<>(exercises, HttpStatus.OK);
    }

    // Get a single exercise by ID
    @GetMapping("/{id}")
    public ResponseEntity<Exercise> getExerciseById(@PathVariable Long id) {
        Optional<Exercise> exercise = exerciseService.getExerciseById(id);
        return exercise.map(value -> new ResponseEntity<>(value, HttpStatus.OK))
                .orElseGet(() -> new ResponseEntity<>(HttpStatus.NOT_FOUND));
    }

    // Delete an exercise by ID
    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteExercise(@PathVariable Long id) {
        exerciseService.deleteExercise(id);
        return new ResponseEntity<>(HttpStatus.NO_CONTENT);
    }
}