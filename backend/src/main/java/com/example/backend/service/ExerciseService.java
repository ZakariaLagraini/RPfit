package com.example.backend.service;

import com.example.backend.entity.Exercise;
import com.example.backend.repository.ExerciseRepository;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public class ExerciseService {

    private final ExerciseRepository exerciseRepository;

    public ExerciseService(ExerciseRepository exerciseRepository) {
        this.exerciseRepository = exerciseRepository;
    }

    public Exercise addExercise(Exercise exercise) {
        return exerciseRepository.save(exercise);
    }

    // Update an existing exercise
    public Exercise updateExercise(Long id, Exercise updatedExercise) {
        Optional<Exercise> optionalExercise = exerciseRepository.findById(id);
        if (optionalExercise.isPresent()) {
            Exercise exercise = optionalExercise.get();
            exercise.setName(updatedExercise.getName());
            exercise.setSets(updatedExercise.getSets());
            exercise.setReps(updatedExercise.getReps());
            exercise.setWeight(updatedExercise.getWeight());
            exercise.setRestTime(updatedExercise.getRestTime());
            return exerciseRepository.save(exercise);
        }
        return null;
    }

    // Get all exercises by workout plan ID
    public List<Exercise> getExercisesByWorkoutPlanId(Long workoutPlanId) {
        return exerciseRepository.findByWorkoutPlanId(workoutPlanId);
    }

    // Get a single exercise by ID
    public Optional<Exercise> getExerciseById(Long id) {
        return exerciseRepository.findById(id);
    }

    // Delete an exercise by ID
    public void deleteExercise(Long id) {
        exerciseRepository.deleteById(id);
    }

    public List<Exercise> getAllExercises() { return exerciseRepository.findAll(); }

}
