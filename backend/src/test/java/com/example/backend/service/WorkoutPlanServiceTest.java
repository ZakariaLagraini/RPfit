package com.example.backend.service;

import com.example.backend.entity.Client;
import com.example.backend.entity.Exercise;
import com.example.backend.entity.WorkoutPlan;
import com.example.backend.repository.WorkoutPlanRepository;
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

class WorkoutPlanServiceTest {

    @Mock
    private WorkoutPlanRepository workoutPlanRepository;

    @InjectMocks
    private WorkoutPlanService workoutPlanService;

    private WorkoutPlan workoutPlan;
    private Client client;
    private Exercise exercise;

    @BeforeEach
    void setUp() {
        MockitoAnnotations.openMocks(this);

        client = new Client();
        client.setId(1L);

        exercise = new Exercise();
        exercise.setId(1L);
        exercise.setName("Bench Press");

        workoutPlan = new WorkoutPlan();
        workoutPlan.setId(1L);
        workoutPlan.setName("Strength Training");
        workoutPlan.setDurationInWeeks(12);
        workoutPlan.setClient(client);
        workoutPlan.setExercises(Arrays.asList(exercise));
    }

    @Test
    void addWorkoutPlan_ShouldReturnSavedWorkoutPlan() {
        when(workoutPlanRepository.save(any(WorkoutPlan.class))).thenReturn(workoutPlan);

        WorkoutPlan savedWorkoutPlan = workoutPlanService.addWorkoutPlan(workoutPlan);

        assertNotNull(savedWorkoutPlan);
        assertEquals(workoutPlan.getId(), savedWorkoutPlan.getId());
        assertEquals(workoutPlan.getName(), savedWorkoutPlan.getName());
        verify(workoutPlanRepository, times(1)).save(workoutPlan);
    }

    @Test
    void updateWorkoutPlan_WhenPlanExists_ShouldUpdateAndReturnPlan() {
        WorkoutPlan updatedWorkoutPlan = new WorkoutPlan();
        updatedWorkoutPlan.setName("Updated Plan");
        updatedWorkoutPlan.setDurationInWeeks(16);
        updatedWorkoutPlan.setExercises(Arrays.asList(exercise));

        when(workoutPlanRepository.findById(1L)).thenReturn(Optional.of(workoutPlan));
        when(workoutPlanRepository.save(any(WorkoutPlan.class))).thenReturn(workoutPlan);

        WorkoutPlan result = workoutPlanService.updateWorkoutPlan(1L, updatedWorkoutPlan);

        assertNotNull(result);
        assertEquals(updatedWorkoutPlan.getName(), result.getName());
        assertEquals(updatedWorkoutPlan.getDurationInWeeks(), result.getDurationInWeeks());
        assertEquals(updatedWorkoutPlan.getExercises(), result.getExercises());
        verify(workoutPlanRepository, times(1)).save(workoutPlan);
    }

    @Test
    void updateWorkoutPlan_WhenPlanDoesNotExist_ShouldReturnNull() {
        when(workoutPlanRepository.findById(1L)).thenReturn(Optional.empty());

        WorkoutPlan result = workoutPlanService.updateWorkoutPlan(1L, new WorkoutPlan());

        assertNull(result);
        verify(workoutPlanRepository, never()).save(any());
    }

    @Test
    void getWorkoutPlansByClientId_ShouldReturnListOfPlans() {
        List<WorkoutPlan> workoutPlans = Arrays.asList(workoutPlan);
        when(workoutPlanRepository.findByClientId(1L)).thenReturn(workoutPlans);

        List<WorkoutPlan> result = workoutPlanService.getWorkoutPlansByClientId(1L);

        assertNotNull(result);
        assertEquals(1, result.size());
        assertEquals(workoutPlan.getId(), result.get(0).getId());
        verify(workoutPlanRepository, times(1)).findByClientId(1L);
    }

    @Test
    void getWorkoutPlanById_WhenPlanExists_ShouldReturnPlan() {
        when(workoutPlanRepository.findById(1L)).thenReturn(Optional.of(workoutPlan));

        Optional<WorkoutPlan> result = workoutPlanService.getWorkoutPlanById(1L);

        assertTrue(result.isPresent());
        assertEquals(workoutPlan.getId(), result.get().getId());
        verify(workoutPlanRepository, times(1)).findById(1L);
    }

    @Test
    void getWorkoutPlanById_WhenPlanDoesNotExist_ShouldReturnEmptyOptional() {
        when(workoutPlanRepository.findById(1L)).thenReturn(Optional.empty());

        Optional<WorkoutPlan> result = workoutPlanService.getWorkoutPlanById(1L);

        assertFalse(result.isPresent());
        verify(workoutPlanRepository, times(1)).findById(1L);
    }

    @Test
    void deleteWorkoutPlan_ShouldCallRepositoryDelete() {
        workoutPlanService.deleteWorkoutPlan(1L);
        
        verify(workoutPlanRepository, times(1)).deleteById(1L);
    }
}