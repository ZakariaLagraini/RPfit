package com.example.backend.controller;

import com.example.backend.entity.WorkoutPlan;
import com.example.backend.service.WorkoutPlanService;
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
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.Mockito.*;

class WorkoutPlanControllerTest {

    @Mock
    private WorkoutPlanService workoutPlanService;

    @InjectMocks
    private WorkoutPlanController workoutPlanController;

    private WorkoutPlan testWorkoutPlan;

    @BeforeEach
    void setUp() {
        MockitoAnnotations.openMocks(this);
        testWorkoutPlan = new WorkoutPlan();
        testWorkoutPlan.setId(1L);
        testWorkoutPlan.setName("Test Workout Plan");
        testWorkoutPlan.setDurationInWeeks(8);
        testWorkoutPlan.setClientId(1L);
    }

    @Test
    void createWorkoutPlan_Success() {
        when(workoutPlanService.addWorkoutPlan(any(WorkoutPlan.class))).thenReturn(testWorkoutPlan);

        ResponseEntity<WorkoutPlan> response = workoutPlanController.createWorkoutPlan(testWorkoutPlan);

        assertEquals(HttpStatus.CREATED, response.getStatusCode());
        assertNotNull(response.getBody());
        assertEquals(testWorkoutPlan.getName(), response.getBody().getName());
        assertEquals(testWorkoutPlan.getDurationInWeeks(), response.getBody().getDurationInWeeks());
        verify(workoutPlanService, times(1)).addWorkoutPlan(any(WorkoutPlan.class));
    }

    @Test
    void updateWorkoutPlan_WhenExists() {
        when(workoutPlanService.updateWorkoutPlan(eq(1L), any(WorkoutPlan.class)))
            .thenReturn(testWorkoutPlan);

        ResponseEntity<WorkoutPlan> response = workoutPlanController
            .updateWorkoutPlan(1L, testWorkoutPlan);

        assertEquals(HttpStatus.OK, response.getStatusCode());
        assertNotNull(response.getBody());
        assertEquals(testWorkoutPlan.getName(), response.getBody().getName());
        verify(workoutPlanService, times(1)).updateWorkoutPlan(eq(1L), any(WorkoutPlan.class));
    }

    @Test
    void updateWorkoutPlan_WhenNotExists() {
        when(workoutPlanService.updateWorkoutPlan(eq(999L), any(WorkoutPlan.class)))
            .thenReturn(null);

        ResponseEntity<WorkoutPlan> response = workoutPlanController
            .updateWorkoutPlan(999L, testWorkoutPlan);

        assertEquals(HttpStatus.NOT_FOUND, response.getStatusCode());
        assertNull(response.getBody());
        verify(workoutPlanService, times(1)).updateWorkoutPlan(eq(999L), any(WorkoutPlan.class));
    }

    @Test
    void getWorkoutPlansByClientId_Success() {
        List<WorkoutPlan> workoutPlans = Arrays.asList(testWorkoutPlan);
        when(workoutPlanService.getWorkoutPlansByClientId(1L)).thenReturn(workoutPlans);

        ResponseEntity<List<WorkoutPlan>> response = workoutPlanController
            .getWorkoutPlansByClientId(1L);

        assertEquals(HttpStatus.OK, response.getStatusCode());
        assertNotNull(response.getBody());
        assertEquals(1, response.getBody().size());
        assertEquals(testWorkoutPlan.getName(), response.getBody().get(0).getName());
        verify(workoutPlanService, times(1)).getWorkoutPlansByClientId(1L);
    }

    @Test
    void getWorkoutPlansByClientId_EmptyList() {
        when(workoutPlanService.getWorkoutPlansByClientId(1L)).thenReturn(Arrays.asList());

        ResponseEntity<List<WorkoutPlan>> response = workoutPlanController
            .getWorkoutPlansByClientId(1L);

        assertEquals(HttpStatus.OK, response.getStatusCode());
        assertNotNull(response.getBody());
        assertTrue(response.getBody().isEmpty());
        verify(workoutPlanService, times(1)).getWorkoutPlansByClientId(1L);
    }

    @Test
    void getWorkoutPlanById_WhenExists() {
        when(workoutPlanService.getWorkoutPlanById(1L)).thenReturn(Optional.of(testWorkoutPlan));

        ResponseEntity<WorkoutPlan> response = workoutPlanController.getWorkoutPlanById(1L);

        assertEquals(HttpStatus.OK, response.getStatusCode());
        assertNotNull(response.getBody());
        assertEquals(testWorkoutPlan.getName(), response.getBody().getName());
        verify(workoutPlanService, times(1)).getWorkoutPlanById(1L);
    }

    @Test
    void getWorkoutPlanById_WhenNotExists() {
        when(workoutPlanService.getWorkoutPlanById(999L)).thenReturn(Optional.empty());

        ResponseEntity<WorkoutPlan> response = workoutPlanController.getWorkoutPlanById(999L);

        assertEquals(HttpStatus.NOT_FOUND, response.getStatusCode());
        assertNull(response.getBody());
        verify(workoutPlanService, times(1)).getWorkoutPlanById(999L);
    }

    @Test
    void deleteWorkoutPlan_Success() {
        doNothing().when(workoutPlanService).deleteWorkoutPlan(1L);

        ResponseEntity<Void> response = workoutPlanController.deleteWorkoutPlan(1L);

        assertEquals(HttpStatus.NO_CONTENT, response.getStatusCode());
        assertNull(response.getBody());
        verify(workoutPlanService, times(1)).deleteWorkoutPlan(1L);
    }

    @Test
    void createWorkoutPlan_WithNullName() {
        testWorkoutPlan.setName(null);
        when(workoutPlanService.addWorkoutPlan(any(WorkoutPlan.class))).thenReturn(testWorkoutPlan);

        ResponseEntity<WorkoutPlan> response = workoutPlanController.createWorkoutPlan(testWorkoutPlan);

        assertEquals(HttpStatus.CREATED, response.getStatusCode());
        assertNotNull(response.getBody());
        assertNull(response.getBody().getName());
        verify(workoutPlanService, times(1)).addWorkoutPlan(any(WorkoutPlan.class));
    }

    @Test
    void createWorkoutPlan_WithZeroDuration() {
        testWorkoutPlan.setDurationInWeeks(0);
        when(workoutPlanService.addWorkoutPlan(any(WorkoutPlan.class))).thenReturn(testWorkoutPlan);

        ResponseEntity<WorkoutPlan> response = workoutPlanController.createWorkoutPlan(testWorkoutPlan);

        assertEquals(HttpStatus.CREATED, response.getStatusCode());
        assertNotNull(response.getBody());
        assertEquals(0, response.getBody().getDurationInWeeks());
        verify(workoutPlanService, times(1)).addWorkoutPlan(any(WorkoutPlan.class));
    }
} 