package com.example.backend.service;

import com.example.backend.entity.WorkoutPlan;
import com.example.backend.repository.WorkoutPlanRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public class WorkoutPlanService {

    private final WorkoutPlanRepository workoutPlanRepository;

    public WorkoutPlanService(WorkoutPlanRepository workoutPlanRepository) {
        this.workoutPlanRepository = workoutPlanRepository;
    }

    // Add a new workout plan
    public WorkoutPlan addWorkoutPlan(WorkoutPlan workoutPlan) {
        return workoutPlanRepository.save(workoutPlan);
    }

    // Update an existing workout plan
    public WorkoutPlan updateWorkoutPlan(Long id, WorkoutPlan updatedWorkoutPlan) {
        Optional<WorkoutPlan> optionalWorkoutPlan = workoutPlanRepository.findById(id);
        if (optionalWorkoutPlan.isPresent()) {
            WorkoutPlan workoutPlan = optionalWorkoutPlan.get();
            workoutPlan.setName(updatedWorkoutPlan.getName());
            workoutPlan.setDurationInWeeks(updatedWorkoutPlan.getDurationInWeeks());
            workoutPlan.setExercises(updatedWorkoutPlan.getExercises());
            return workoutPlanRepository.save(workoutPlan);
        }
        return null;
    }

    public List<WorkoutPlan> getWorkoutPlansByExercises(List<String> exerciseNames) {
        return workoutPlanRepository.findByExerciseNamesIn(exerciseNames);
    }

    // Get all workout plans for a specific client
    public List<WorkoutPlan> getWorkoutPlansByClientId(Long clientId) {
        return workoutPlanRepository.findByClientId(clientId);
    }

    // Get a single workout plan by ID
    public Optional<WorkoutPlan> getWorkoutPlanById(Long id) {
        return workoutPlanRepository.findById(id);
    }

    // Delete a workout plan by ID
    public void deleteWorkoutPlan(Long id) {
        workoutPlanRepository.deleteById(id);
    }
}

