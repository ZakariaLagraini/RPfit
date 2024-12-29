package com.example.backend.controller;

import com.example.backend.entity.Progress;
import com.example.backend.service.ProgressService;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.MockitoAnnotations;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;

import java.time.LocalDateTime;
import java.util.Arrays;
import java.util.List;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.Mockito.*;

class ProgressControllerTest {

    @Mock
    private ProgressService progressService;

    @InjectMocks
    private ProgressController progressController;

    private Progress testProgress;

    @BeforeEach
    void setUp() {
        MockitoAnnotations.openMocks(this);
        testProgress = new Progress();
        testProgress.setId(1L);
        testProgress.setClientId(1L);
        testProgress.setExerciseId(1L);
        testProgress.setWeight(75.0);
        testProgress.setReps(12);
        testProgress.setSets(3);
        testProgress.setDate(LocalDateTime.now());
    }

    @Test
    void createProgress_Success() {
        when(progressService.createProgress(any(Progress.class))).thenReturn(testProgress);

        ResponseEntity<Progress> response = progressController.createProgress(testProgress);

        assertEquals(HttpStatus.OK, response.getStatusCode());
        assertNotNull(response.getBody());
        assertEquals(testProgress.getClientId(), response.getBody().getClientId());
        assertEquals(testProgress.getExerciseId(), response.getBody().getExerciseId());
        assertEquals(testProgress.getWeight(), response.getBody().getWeight());
        verify(progressService, times(1)).createProgress(any(Progress.class));
    }

    @Test
    void updateProgress_Success() {
        when(progressService.updateProgress(eq(1L), any(Progress.class))).thenReturn(testProgress);

        ResponseEntity<Progress> response = progressController.updateProgress(1L, testProgress);

        assertEquals(HttpStatus.OK, response.getStatusCode());
        assertNotNull(response.getBody());
        assertEquals(testProgress.getWeight(), response.getBody().getWeight());
        assertEquals(testProgress.getReps(), response.getBody().getReps());
        verify(progressService, times(1)).updateProgress(eq(1L), any(Progress.class));
    }

    @Test
    void deleteProgress_Success() {
        doNothing().when(progressService).deleteProgress(1L);

        ResponseEntity<Void> response = progressController.deleteProgress(1L);

        assertEquals(HttpStatus.NO_CONTENT, response.getStatusCode());
        assertNull(response.getBody());
        verify(progressService, times(1)).deleteProgress(1L);
    }

    @Test
    void getProgressById_Success() {
        when(progressService.getProgressById(1L)).thenReturn(testProgress);

        ResponseEntity<Progress> response = progressController.getProgressById(1L);

        assertEquals(HttpStatus.OK, response.getStatusCode());
        assertNotNull(response.getBody());
        assertEquals(testProgress.getId(), response.getBody().getId());
        verify(progressService, times(1)).getProgressById(1L);
    }

    @Test
    void getProgressByClientId_Success() {
        List<Progress> progressList = Arrays.asList(testProgress);
        when(progressService.getProgressByClientId(1L)).thenReturn(progressList);

        ResponseEntity<List<Progress>> response = progressController.getProgressByClientId(1L);

        assertEquals(HttpStatus.OK, response.getStatusCode());
        assertNotNull(response.getBody());
        assertEquals(1, response.getBody().size());
        assertEquals(testProgress.getClientId(), response.getBody().get(0).getClientId());
        verify(progressService, times(1)).getProgressByClientId(1L);
    }

    @Test
    void getProgressByExerciseId_Success() {
        List<Progress> progressList = Arrays.asList(testProgress);
        when(progressService.getProgressByExerciseId(1L)).thenReturn(progressList);

        ResponseEntity<List<Progress>> response = progressController.getProgressByExerciseId(1L);

        assertEquals(HttpStatus.OK, response.getStatusCode());
        assertNotNull(response.getBody());
        assertEquals(1, response.getBody().size());
        assertEquals(testProgress.getExerciseId(), response.getBody().get(0).getExerciseId());
        verify(progressService, times(1)).getProgressByExerciseId(1L);
    }

    @Test
    void getProgressByClientId_EmptyList() {
        when(progressService.getProgressByClientId(1L)).thenReturn(Arrays.asList());

        ResponseEntity<List<Progress>> response = progressController.getProgressByClientId(1L);

        assertEquals(HttpStatus.OK, response.getStatusCode());
        assertNotNull(response.getBody());
        assertTrue(response.getBody().isEmpty());
        verify(progressService, times(1)).getProgressByClientId(1L);
    }

    @Test
    void getProgressByExerciseId_EmptyList() {
        when(progressService.getProgressByExerciseId(1L)).thenReturn(Arrays.asList());

        ResponseEntity<List<Progress>> response = progressController.getProgressByExerciseId(1L);

        assertEquals(HttpStatus.OK, response.getStatusCode());
        assertNotNull(response.getBody());
        assertTrue(response.getBody().isEmpty());
        verify(progressService, times(1)).getProgressByExerciseId(1L);
    }

    @Test
    void createProgress_WithNullValues() {
        testProgress.setWeight(null);
        when(progressService.createProgress(any(Progress.class))).thenReturn(testProgress);

        ResponseEntity<Progress> response = progressController.createProgress(testProgress);

        assertEquals(HttpStatus.OK, response.getStatusCode());
        assertNotNull(response.getBody());
        assertNull(response.getBody().getWeight());
        verify(progressService, times(1)).createProgress(any(Progress.class));
    }
} 