package com.example.backend.service;

import com.example.backend.entity.Client;
import com.example.backend.entity.Exercise;
import com.example.backend.entity.Progress;
import com.example.backend.repository.ProgressRepository;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.MockitoAnnotations;

import java.time.LocalDate;
import java.util.Arrays;
import java.util.List;
import java.util.Optional;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.*;

class ProgressServiceTest {

    @Mock
    private ProgressRepository progressRepository;

    @InjectMocks
    private ProgressService progressService;

    private Progress progress;
    private Client client;
    private Exercise exercise;

    @BeforeEach
    void setUp() {
        MockitoAnnotations.openMocks(this);

        client = new Client();
        client.setId(1L);

        exercise = new Exercise();
        exercise.setId(1L);

        progress = new Progress();
        progress.setId(1L);
        progress.setClient(client);
        progress.setExercise(exercise);
        progress.setDate(LocalDate.now());
        progress.setRepetitions(10);
        progress.setWeight(50.0);
        progress.setSets(3);
        progress.setDuration(30.0);
        progress.setNotes("Test notes");
    }

    @Test
    void createProgress_ShouldReturnSavedProgress() {
        when(progressRepository.save(any(Progress.class))).thenReturn(progress);

        Progress savedProgress = progressService.createProgress(progress);

        assertNotNull(savedProgress);
        assertEquals(progress.getId(), savedProgress.getId());
        verify(progressRepository, times(1)).save(progress);
    }

    @Test
    void updateProgress_WhenProgressExists_ShouldUpdateAndReturnProgress() {
        Progress updatedProgress = new Progress();
        updatedProgress.setDate(LocalDate.now().plusDays(1));
        updatedProgress.setRepetitions(12);
        updatedProgress.setWeight(55.0);
        updatedProgress.setSets(4);
        updatedProgress.setDuration(35.0);
        updatedProgress.setNotes("Updated notes");

        when(progressRepository.findById(1L)).thenReturn(Optional.of(progress));
        when(progressRepository.save(any(Progress.class))).thenReturn(progress);

        Progress result = progressService.updateProgress(1L, updatedProgress);

        assertNotNull(result);
        assertEquals(updatedProgress.getDate(), result.getDate());
        assertEquals(updatedProgress.getRepetitions(), result.getRepetitions());
        assertEquals(updatedProgress.getWeight(), result.getWeight());
        assertEquals(updatedProgress.getSets(), result.getSets());
        assertEquals(updatedProgress.getDuration(), result.getDuration());
        assertEquals(updatedProgress.getNotes(), result.getNotes());
        verify(progressRepository, times(1)).save(progress);
    }

    @Test
    void updateProgress_WhenProgressDoesNotExist_ShouldThrowException() {
        when(progressRepository.findById(1L)).thenReturn(Optional.empty());

        assertThrows(RuntimeException.class, () -> 
            progressService.updateProgress(1L, new Progress())
        );
        verify(progressRepository, never()).save(any());
    }

    @Test
    void deleteProgress_ShouldCallRepositoryDelete() {
        progressService.deleteProgress(1L);
        verify(progressRepository, times(1)).deleteById(1L);
    }

    @Test
    void getProgressById_WhenProgressExists_ShouldReturnProgress() {
        when(progressRepository.findById(1L)).thenReturn(Optional.of(progress));

        Progress result = progressService.getProgressById(1L);

        assertNotNull(result);
        assertEquals(progress.getId(), result.getId());
    }

    @Test
    void getProgressById_WhenProgressDoesNotExist_ShouldReturnNull() {
        when(progressRepository.findById(1L)).thenReturn(Optional.empty());

        Progress result = progressService.getProgressById(1L);

        assertNull(result);
    }

    @Test
    void getProgressByClientId_ShouldReturnListOfProgress() {
        List<Progress> progressList = Arrays.asList(progress);
        when(progressRepository.findByClientId(1L)).thenReturn(progressList);

        List<Progress> result = progressService.getProgressByClientId(1L);

        assertNotNull(result);
        assertEquals(1, result.size());
        assertEquals(progress.getId(), result.get(0).getId());
    }

    @Test
    void getProgressByExerciseId_ShouldReturnListOfProgress() {
        List<Progress> progressList = Arrays.asList(progress);
        when(progressRepository.findByExerciseId(1L)).thenReturn(progressList);

        List<Progress> result = progressService.getProgressByExerciseId(1L);

        assertNotNull(result);
        assertEquals(1, result.size());
        assertEquals(progress.getId(), result.get(0).getId());
    }
} 