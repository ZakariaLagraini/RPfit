package com.example.backend.controller;

import com.example.backend.entity.WorkoutPlan;
import com.example.backend.service.WorkoutPlanService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Optional;

@RestController
@RequestMapping("/api/workoutPlans")
public class WorkoutPlanController {

    private final WorkoutPlanService workoutPlanService;

    public WorkoutPlanController(WorkoutPlanService workoutPlanService) {
        this.workoutPlanService = workoutPlanService;
    }

    // Create a new workout plan
    @PostMapping
    public ResponseEntity<WorkoutPlan> createWorkoutPlan(@RequestBody WorkoutPlan workoutPlan) {
        WorkoutPlan createdWorkoutPlan = workoutPlanService.addWorkoutPlan(workoutPlan);
        return new ResponseEntity<>(createdWorkoutPlan, HttpStatus.CREATED);
    }

    // Update an existing workout plan by ID
    @PutMapping("/{id}")
    public ResponseEntity<WorkoutPlan> updateWorkoutPlan(
            @PathVariable Long id,
            @RequestBody WorkoutPlan updatedWorkoutPlan) {
        WorkoutPlan workoutPlan = workoutPlanService.updateWorkoutPlan(id, updatedWorkoutPlan);
        if (workoutPlan != null) {
            return new ResponseEntity<>(workoutPlan, HttpStatus.OK);
        } else {
            return new ResponseEntity<>(HttpStatus.NOT_FOUND);
        }
    }

    // Get all workout plans for a specific client
    @GetMapping("/client/{clientId}")
    public ResponseEntity<List<WorkoutPlan>> getWorkoutPlansByClientId(@PathVariable Long clientId) {
        List<WorkoutPlan> workoutPlans = workoutPlanService.getWorkoutPlansByClientId(clientId);
        return new ResponseEntity<>(workoutPlans, HttpStatus.OK);
    }

    // Get a single workout plan by ID
    @GetMapping("/{id}")
    public ResponseEntity<WorkoutPlan> getWorkoutPlanById(@PathVariable Long id) {
        Optional<WorkoutPlan> workoutPlan = workoutPlanService.getWorkoutPlanById(id);
        return workoutPlan.map(value -> new ResponseEntity<>(value, HttpStatus.OK))
                .orElseGet(() -> new ResponseEntity<>(HttpStatus.NOT_FOUND));
    }

    // Delete a workout plan by ID
    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteWorkoutPlan(@PathVariable Long id) {
        workoutPlanService.deleteWorkoutPlan(id);
        return new ResponseEntity<>(HttpStatus.NO_CONTENT);
    }
}
