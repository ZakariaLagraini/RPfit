package com.example.backend.controller;

import com.example.backend.entity.Exercise;
import com.example.backend.service.ExerciseService;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.MockitoAnnotations;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;

import java.util.Arrays;
import java.util.List;
import java.util.Optional;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.*;

class ExerciseControllerTest {

    @Mock
    private ExerciseService exerciseService;

    @InjectMocks
    private ExerciseController exerciseController;

    private Exercise testExercise;

    @BeforeEach
    void setUp() {
        MockitoAnnotations.openMocks(this);
        testExercise = new Exercise();
        testExercise.setId(1L);
        testExercise.setName("Bench Press");
        testExercise.setSets(3);
        testExercise.setReps(10);
        testExercise.setWorkoutPlanId(1L);
    }

    @Test
    void createExercise_Success() {
        when(exerciseService.addExercise(any(Exercise.class))).thenReturn(testExercise);

        ResponseEntity<Exercise> response = exerciseController.createExercise(testExercise);

        assertEquals(HttpStatus.CREATED, response.getStatusCode());
        assertEquals(testExercise, response.getBody());
        verify(exerciseService, times(1)).addExercise(any(Exercise.class));
    }

    @Test
    void updateExercise_WhenExists() {
        when(exerciseService.updateExercise(eq(1L), any(Exercise.class))).thenReturn(testExercise);

        ResponseEntity<Exercise> response = exerciseController.updateExercise(1L, testExercise);

        assertEquals(HttpStatus.OK, response.getStatusCode());
        assertEquals(testExercise, response.getBody());
        verify(exerciseService, times(1)).updateExercise(eq(1L), any(Exercise.class));
    }

    @Test
    void updateExercise_WhenNotExists() {
        when(exerciseService.updateExercise(eq(999L), any(Exercise.class))).thenReturn(null);

        ResponseEntity<Exercise> response = exerciseController.updateExercise(999L, testExercise);

        assertEquals(HttpStatus.NOT_FOUND, response.getStatusCode());
        assertNull(response.getBody());
        verify(exerciseService, times(1)).updateExercise(eq(999L), any(Exercise.class));
    }

    @Test
    void getExercisesByWorkoutPlanId_Success() {
        List<Exercise> exercises = Arrays.asList(testExercise);
        when(exerciseService.getExercisesByWorkoutPlanId(1L)).thenReturn(exercises);

        ResponseEntity<List<Exercise>> response = exerciseController.getExercisesByWorkoutPlanId(1L);

        assertEquals(HttpStatus.OK, response.getStatusCode());
        assertEquals(exercises, response.getBody());
        verify(exerciseService, times(1)).getExercisesByWorkoutPlanId(1L);
    }

    @Test
    void getExerciseById_WhenExists() {
        when(exerciseService.getExerciseById(1L)).thenReturn(Optional.of(testExercise));

        ResponseEntity<Exercise> response = exerciseController.getExerciseById(1L);

        assertEquals(HttpStatus.OK, response.getStatusCode());
        assertEquals(testExercise, response.getBody());
        verify(exerciseService, times(1)).getExerciseById(1L);
    }

    @Test
    void getExerciseById_WhenNotExists() {
        when(exerciseService.getExerciseById(999L)).thenReturn(Optional.empty());

        ResponseEntity<Exercise> response = exerciseController.getExerciseById(999L);

        assertEquals(HttpStatus.NOT_FOUND, response.getStatusCode());
        assertNull(response.getBody());
        verify(exerciseService, times(1)).getExerciseById(999L);
    }

    @Test
    void deleteExercise_Success() {
        doNothing().when(exerciseService).deleteExercise(1L);

        ResponseEntity<Void> response = exerciseController.deleteExercise(1L);

        assertEquals(HttpStatus.NO_CONTENT, response.getStatusCode());
        verify(exerciseService, times(1)).deleteExercise(1L);
    }

    @Test
    void getAllExercises_Success() {
        List<Exercise> exercises = Arrays.asList(testExercise);
        when(exerciseService.getAllExercises()).thenReturn(exercises);

        ResponseEntity<List<Exercise>> response = exerciseController.getAllExercises();

        assertEquals(HttpStatus.OK, response.getStatusCode());
        assertEquals(exercises, response.getBody());
        verify(exerciseService, times(1)).getAllExercises();
    }
} 