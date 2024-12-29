package com.example.backend.service;

import com.example.backend.entity.WorkoutPlan;
import com.example.backend.entity.Exercise;
import com.example.backend.repository.WorkoutPlanRepository;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.MockitoAnnotations;

import java.util.Arrays;
import java.util.List;
import java.util.Optional;
import java.util.ArrayList;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.*;

class WorkoutPlanServiceTest {

    @Mock
    private WorkoutPlanRepository workoutPlanRepository;

    @InjectMocks
    private WorkoutPlanService workoutPlanService;

    private WorkoutPlan testWorkoutPlan;

    @BeforeEach
    void setUp() {
        MockitoAnnotations.openMocks(this);
        testWorkoutPlan = new WorkoutPlan();
        testWorkoutPlan.setId(1L);
        testWorkoutPlan.setName("Test Workout Plan");
        testWorkoutPlan.setDurationInWeeks(8);
        testWorkoutPlan.setClientId(1L);
        
        List<Exercise> exercises = new ArrayList<>();
        Exercise exercise = new Exercise();
        exercise.setId(1L);
        exercise.setName("Bench Press");
        exercises.add(exercise);
        testWorkoutPlan.setExercises(exercises);
    }

    @Test
    void addWorkoutPlan_Success() {
        when(workoutPlanRepository.save(any(WorkoutPlan.class))).thenReturn(testWorkoutPlan);

        WorkoutPlan savedPlan = workoutPlanService.addWorkoutPlan(testWorkoutPlan);

        assertNotNull(savedPlan);
        assertEquals(testWorkoutPlan.getName(), savedPlan.getName());
        assertEquals(testWorkoutPlan.getDurationInWeeks(), savedPlan.getDurationInWeeks());
        verify(workoutPlanRepository, times(1)).save(any(WorkoutPlan.class));
    }

    @Test
    void updateWorkoutPlan_WhenExists() {
        WorkoutPlan updatedPlan = new WorkoutPlan();
        updatedPlan.setName("Updated Plan");
        updatedPlan.setDurationInWeeks(12);
        
        when(workoutPlanRepository.findById(1L)).thenReturn(Optional.of(testWorkoutPlan));
        when(workoutPlanRepository.save(any(WorkoutPlan.class))).thenReturn(updatedPlan);

        WorkoutPlan result = workoutPlanService.updateWorkoutPlan(1L, updatedPlan);

        assertNotNull(result);
        assertEquals(updatedPlan.getName(), result.getName());
        assertEquals(updatedPlan.getDurationInWeeks(), result.getDurationInWeeks());
        verify(workoutPlanRepository, times(1)).findById(1L);
        verify(workoutPlanRepository, times(1)).save(any(WorkoutPlan.class));
    }

    @Test
    void updateWorkoutPlan_WhenNotExists() {
        WorkoutPlan updatedPlan = new WorkoutPlan();
        when(workoutPlanRepository.findById(999L)).thenReturn(Optional.empty());

        WorkoutPlan result = workoutPlanService.updateWorkoutPlan(999L, updatedPlan);

        assertNull(result);
        verify(workoutPlanRepository, times(1)).findById(999L);
        verify(workoutPlanRepository, never()).save(any(WorkoutPlan.class));
    }

    @Test
    void getWorkoutPlansByClientId_Success() {
        List<WorkoutPlan> plans = Arrays.asList(testWorkoutPlan);
        when(workoutPlanRepository.findByClientId(1L)).thenReturn(plans);

        List<WorkoutPlan> foundPlans = workoutPlanService.getWorkoutPlansByClientId(1L);

        assertEquals(1, foundPlans.size());
        assertEquals(testWorkoutPlan.getName(), foundPlans.get(0).getName());
        verify(workoutPlanRepository, times(1)).findByClientId(1L);
    }

    @Test
    void getWorkoutPlanById_WhenExists() {
        when(workoutPlanRepository.findById(1L)).thenReturn(Optional.of(testWorkoutPlan));

        Optional<WorkoutPlan> found = workoutPlanService.getWorkoutPlanById(1L);

        assertTrue(found.isPresent());
        assertEquals(testWorkoutPlan.getName(), found.get().getName());
        verify(workoutPlanRepository, times(1)).findById(1L);
    }

    @Test
    void getWorkoutPlanById_WhenNotExists() {
        when(workoutPlanRepository.findById(999L)).thenReturn(Optional.empty());

        Optional<WorkoutPlan> found = workoutPlanService.getWorkoutPlanById(999L);

        assertFalse(found.isPresent());
        verify(workoutPlanRepository, times(1)).findById(999L);
    }

    @Test
    void deleteWorkoutPlan_Success() {
        doNothing().when(workoutPlanRepository).deleteById(1L);

        workoutPlanService.deleteWorkoutPlan(1L);

        verify(workoutPlanRepository, times(1)).deleteById(1L);
    }

    @Test
    void updateWorkoutPlan_PreservesExistingFields() {
        WorkoutPlan updatedPlan = new WorkoutPlan();
        updatedPlan.setName("Updated Plan");
        // Note: not setting duration or exercises

        when(workoutPlanRepository.findById(1L)).thenReturn(Optional.of(testWorkoutPlan));
        when(workoutPlanRepository.save(any(WorkoutPlan.class))).thenAnswer(i -> i.getArguments()[0]);

        WorkoutPlan result = workoutPlanService.updateWorkoutPlan(1L, updatedPlan);

        assertNotNull(result);
        assertEquals("Updated Plan", result.getName());
        assertEquals(testWorkoutPlan.getDurationInWeeks(), result.getDurationInWeeks());
        assertEquals(testWorkoutPlan.getExercises(), result.getExercises());
        verify(workoutPlanRepository, times(1)).findById(1L);
        verify(workoutPlanRepository, times(1)).save(any(WorkoutPlan.class));
    }
}