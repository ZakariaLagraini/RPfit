package com.example.backend.service;

import com.example.backend.entity.Exercise;
import com.example.backend.entity.WorkoutPlan;
import com.example.backend.repository.ExerciseRepository;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.util.Arrays;
import java.util.List;
import java.util.Optional;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.anyLong;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class ExerciseServiceTest {

    @Mock
    private ExerciseRepository exerciseRepository;

    @InjectMocks
    private ExerciseService exerciseService;

    private Exercise testExercise;
    private WorkoutPlan testWorkoutPlan;

    @BeforeEach
    void setUp() {
        testWorkoutPlan = new WorkoutPlan();
        testWorkoutPlan.setId(1L);
        testWorkoutPlan.setName("Test Workout Plan");
        testWorkoutPlan.setDurationInWeeks(4);

        testExercise = new Exercise();
        testExercise.setId(1L);
        testExercise.setName("Bench Press");
        testExercise.setSets(3);
        testExercise.setReps(10);
        testExercise.setWeight(60.0);
        testExercise.setRestTime(90);
        testExercise.setWorkoutPlan(testWorkoutPlan);
    }

    @Test
    void createExercise_ShouldReturnSavedExercise() {
        // Given
        when(exerciseRepository.save(any(Exercise.class))).thenReturn(testExercise);

        // When
        Exercise savedExercise = exerciseService.addExercise(testExercise);

        // Then
        assertThat(savedExercise).isNotNull();
        assertThat(savedExercise.getId()).isEqualTo(testExercise.getId());
        assertThat(savedExercise.getName()).isEqualTo(testExercise.getName());
        assertThat(savedExercise.getSets()).isEqualTo(testExercise.getSets());
        assertThat(savedExercise.getReps()).isEqualTo(testExercise.getReps());
        verify(exerciseRepository).save(any(Exercise.class));
    }

    @Test
    void updateExercise_ShouldReturnUpdatedExercise() {
        // Given
        Exercise updatedExercise = new Exercise();
        updatedExercise.setName("Updated Exercise");
        updatedExercise.setSets(4);
        updatedExercise.setReps(12);
        updatedExercise.setWeight(70.0);

        when(exerciseRepository.findById(anyLong())).thenReturn(Optional.of(testExercise));
        when(exerciseRepository.save(any(Exercise.class))).thenReturn(updatedExercise);

        // When
        Exercise result = exerciseService.updateExercise(1L, updatedExercise);

        // Then
        assertThat(result).isNotNull();
        assertThat(result.getName()).isEqualTo(updatedExercise.getName());
        assertThat(result.getSets()).isEqualTo(updatedExercise.getSets());
        assertThat(result.getReps()).isEqualTo(updatedExercise.getReps());
        assertThat(result.getWeight()).isEqualTo(updatedExercise.getWeight());
        verify(exerciseRepository).findById(1L);
        verify(exerciseRepository).save(any(Exercise.class));
    }

    @Test
    void getExerciseById_ShouldReturnExercise() {
        // Given
        when(exerciseRepository.findById(anyLong())).thenReturn(Optional.of(testExercise));

        // When
        Optional<Exercise> result = exerciseService.getExerciseById(1L);

        // Then
        assertThat(result).isPresent();
        assertThat(result.get().getId()).isEqualTo(testExercise.getId());
        assertThat(result.get().getName()).isEqualTo(testExercise.getName());
        verify(exerciseRepository).findById(1L);
    }

    @Test
    void getAllExercises_ShouldReturnListOfExercises() {
        // Given
        List<Exercise> exercises = Arrays.asList(testExercise);
        when(exerciseRepository.findAll()).thenReturn(exercises);

        // When
        List<Exercise> result = exerciseService.getAllExercises();

        // Then
        assertThat(result).isNotEmpty();
        assertThat(result).hasSize(1);
        assertThat(result.get(0).getId()).isEqualTo(testExercise.getId());
        verify(exerciseRepository).findAll();
    }

    @Test
    void getExercisesByWorkoutPlanId_ShouldReturnListOfExercises() {
        // Given
        List<Exercise> exercises = Arrays.asList(testExercise);
        when(exerciseRepository.findByWorkoutPlanId(anyLong())).thenReturn(exercises);

        // When
        List<Exercise> result = exerciseService.getExercisesByWorkoutPlanId(1L);

        // Then
        assertThat(result).isNotEmpty();
        assertThat(result).hasSize(1);
        assertThat(result.get(0).getId()).isEqualTo(testExercise.getId());
        verify(exerciseRepository).findByWorkoutPlanId(1L);
    }

    @Test
    void deleteExercise_ShouldCallRepository() {
        // Given
        doNothing().when(exerciseRepository).deleteById(anyLong());

        // When
        exerciseService.deleteExercise(1L);

        // Then
        verify(exerciseRepository).deleteById(1L);
    }
}