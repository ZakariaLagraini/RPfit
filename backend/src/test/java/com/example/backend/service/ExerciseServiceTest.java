package com.example.backend.service;

import com.example.backend.entity.Exercise;
import com.example.backend.repository.ExerciseRepository;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.MockitoAnnotations;

import java.util.Arrays;
import java.util.List;
import java.util.Optional;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.*;

class ExerciseServiceTest {

    @Mock
    private ExerciseRepository exerciseRepository;

    @InjectMocks
    private ExerciseService exerciseService;

    private Exercise testExercise;

    @BeforeEach
    void setUp() {
        MockitoAnnotations.openMocks(this);
        testExercise = new Exercise();
        testExercise.setId(1L);
        testExercise.setName("Bench Press");
        testExercise.setSets(3);
        testExercise.setReps(10);
        testExercise.setWeight(100.0);
        testExercise.setRestTime(90);
        testExercise.setWorkoutPlanId(1L);
    }

    @Test
    void addExercise_Success() {
        when(exerciseRepository.save(any(Exercise.class))).thenReturn(testExercise);

        Exercise savedExercise = exerciseService.addExercise(testExercise);

        assertNotNull(savedExercise);
        assertEquals(testExercise.getName(), savedExercise.getName());
        assertEquals(testExercise.getSets(), savedExercise.getSets());
        verify(exerciseRepository, times(1)).save(any(Exercise.class));
    }

    @Test
    void updateExercise_WhenExists() {
        Exercise updatedExercise = new Exercise();
        updatedExercise.setName("Updated Bench Press");
        updatedExercise.setSets(4);
        updatedExercise.setReps(12);
        updatedExercise.setWeight(110.0);
        updatedExercise.setRestTime(60);

        when(exerciseRepository.findById(1L)).thenReturn(Optional.of(testExercise));
        when(exerciseRepository.save(any(Exercise.class))).thenReturn(updatedExercise);

        Exercise result = exerciseService.updateExercise(1L, updatedExercise);

        assertNotNull(result);
        assertEquals(updatedExercise.getName(), result.getName());
        assertEquals(updatedExercise.getSets(), result.getSets());
        assertEquals(updatedExercise.getReps(), result.getReps());
        verify(exerciseRepository, times(1)).findById(1L);
        verify(exerciseRepository, times(1)).save(any(Exercise.class));
    }

    @Test
    void updateExercise_WhenNotExists() {
        when(exerciseRepository.findById(999L)).thenReturn(Optional.empty());

        Exercise result = exerciseService.updateExercise(999L, new Exercise());

        assertNull(result);
        verify(exerciseRepository, times(1)).findById(999L);
        verify(exerciseRepository, never()).save(any(Exercise.class));
    }

    @Test
    void getExercisesByWorkoutPlanId_Success() {
        List<Exercise> exercises = Arrays.asList(testExercise);
        when(exerciseRepository.findByWorkoutPlanId(1L)).thenReturn(exercises);

        List<Exercise> foundExercises = exerciseService.getExercisesByWorkoutPlanId(1L);

        assertEquals(1, foundExercises.size());
        assertEquals(testExercise.getName(), foundExercises.get(0).getName());
        verify(exerciseRepository, times(1)).findByWorkoutPlanId(1L);
    }

    @Test
    void getExerciseById_WhenExists() {
        when(exerciseRepository.findById(1L)).thenReturn(Optional.of(testExercise));

        Optional<Exercise> found = exerciseService.getExerciseById(1L);

        assertTrue(found.isPresent());
        assertEquals(testExercise.getName(), found.get().getName());
        verify(exerciseRepository, times(1)).findById(1L);
    }

    @Test
    void getExerciseById_WhenNotExists() {
        when(exerciseRepository.findById(999L)).thenReturn(Optional.empty());

        Optional<Exercise> found = exerciseService.getExerciseById(999L);

        assertFalse(found.isPresent());
        verify(exerciseRepository, times(1)).findById(999L);
    }

    @Test
    void deleteExercise_Success() {
        doNothing().when(exerciseRepository).deleteById(1L);

        exerciseService.deleteExercise(1L);

        verify(exerciseRepository, times(1)).deleteById(1L);
    }

    @Test
    void getAllExercises_Success() {
        List<Exercise> exercises = Arrays.asList(testExercise, new Exercise());
        when(exerciseRepository.findAll()).thenReturn(exercises);

        List<Exercise> foundExercises = exerciseService.getAllExercises();

        assertEquals(2, foundExercises.size());
        verify(exerciseRepository, times(1)).findAll();
    }
} 