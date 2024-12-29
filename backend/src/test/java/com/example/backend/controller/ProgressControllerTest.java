package com.example.backend.controller;

import com.example.backend.entity.Client;
import com.example.backend.entity.Exercise;
import com.example.backend.entity.Progress;
import com.example.backend.security.JwtUtil;
import com.example.backend.service.ClientDetailsService;
import com.example.backend.service.ProgressService;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.WebMvcTest;
import org.springframework.boot.test.mock.mockito.MockBean;
import org.springframework.http.MediaType;
import org.springframework.security.test.context.support.WithMockUser;
import org.springframework.security.test.web.servlet.request.SecurityMockMvcRequestPostProcessors;
import org.springframework.test.web.servlet.MockMvc;

import java.time.LocalDate;
import java.util.Arrays;
import java.util.List;

import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.anyLong;
import static org.mockito.Mockito.doNothing;
import static org.mockito.Mockito.when;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

@WebMvcTest(ProgressController.class)
class ProgressControllerTest {

    @Autowired
    private MockMvc mockMvc;

    @Autowired
    private ObjectMapper objectMapper;

    @MockBean
    private ProgressService progressService;

    @MockBean
    private JwtUtil jwtUtil;

    @MockBean
    private ClientDetailsService clientDetailsService;

    private Progress testProgress;
    private Client testClient;
    private Exercise testExercise;

    @BeforeEach
    void setUp() {
        testClient = new Client();
        testClient.setId(1L);

        testExercise = new Exercise();
        testExercise.setId(1L);

        testProgress = new Progress();
        testProgress.setId(1L);
        testProgress.setClient(testClient);
        testProgress.setExercise(testExercise);
        testProgress.setDate(LocalDate.now());
        testProgress.setRepetitions(12);
        testProgress.setWeight(50.0);
        testProgress.setSets(3);
        testProgress.setDuration(30.0);
        testProgress.setNotes("Test progress");
    }

    @Test
    @WithMockUser
    void createProgress_ShouldReturnCreatedProgress() throws Exception {
        when(progressService.createProgress(any(Progress.class))).thenReturn(testProgress);

        mockMvc.perform(post("/api/progress")
                .with(SecurityMockMvcRequestPostProcessors.csrf())
                .contentType(MediaType.APPLICATION_JSON)
                .content(objectMapper.writeValueAsString(testProgress)))
                .andExpect(status().isOk())
                .andExpect(content().contentType(MediaType.APPLICATION_JSON))
                .andExpect(jsonPath("$.id").value(testProgress.getId()))
                .andExpect(jsonPath("$.repetitions").value(testProgress.getRepetitions()))
                .andExpect(jsonPath("$.weight").value(testProgress.getWeight()));
    }

    @Test
    @WithMockUser
    void updateProgress_ShouldReturnUpdatedProgress() throws Exception {
        when(progressService.updateProgress(anyLong(), any(Progress.class))).thenReturn(testProgress);

        mockMvc.perform(put("/api/progress/1")
                .with(SecurityMockMvcRequestPostProcessors.csrf())
                .contentType(MediaType.APPLICATION_JSON)
                .content(objectMapper.writeValueAsString(testProgress)))
                .andExpect(status().isOk())
                .andExpect(content().contentType(MediaType.APPLICATION_JSON))
                .andExpect(jsonPath("$.id").value(testProgress.getId()))
                .andExpect(jsonPath("$.repetitions").value(testProgress.getRepetitions()))
                .andExpect(jsonPath("$.weight").value(testProgress.getWeight()));
    }

    @Test
    @WithMockUser
    void deleteProgress_ShouldReturnNoContent() throws Exception {
        doNothing().when(progressService).deleteProgress(anyLong());

        mockMvc.perform(delete("/api/progress/1")
                .with(SecurityMockMvcRequestPostProcessors.csrf()))
                .andExpect(status().isNoContent());
    }

    @Test
    @WithMockUser
    void getProgressById_ShouldReturnProgress() throws Exception {
        when(progressService.getProgressById(anyLong())).thenReturn(testProgress);

        mockMvc.perform(get("/api/progress/1"))
                .andExpect(status().isOk())
                .andExpect(content().contentType(MediaType.APPLICATION_JSON))
                .andExpect(jsonPath("$.id").value(testProgress.getId()))
                .andExpect(jsonPath("$.repetitions").value(testProgress.getRepetitions()))
                .andExpect(jsonPath("$.weight").value(testProgress.getWeight()));
    }

    @Test
    @WithMockUser
    void getProgressByClientId_ShouldReturnProgressList() throws Exception {
        List<Progress> progressList = Arrays.asList(testProgress);
        when(progressService.getProgressByClientId(anyLong())).thenReturn(progressList);

        mockMvc.perform(get("/api/progress/client/1"))
                .andExpect(status().isOk())
                .andExpect(content().contentType(MediaType.APPLICATION_JSON))
                .andExpect(jsonPath("$[0].id").value(testProgress.getId()))
                .andExpect(jsonPath("$[0].repetitions").value(testProgress.getRepetitions()))
                .andExpect(jsonPath("$[0].weight").value(testProgress.getWeight()));
    }

    @Test
    @WithMockUser
    void getProgressByExerciseId_ShouldReturnProgressList() throws Exception {
        List<Progress> progressList = Arrays.asList(testProgress);
        when(progressService.getProgressByExerciseId(anyLong())).thenReturn(progressList);

        mockMvc.perform(get("/api/progress/exercise/1"))
                .andExpect(status().isOk())
                .andExpect(content().contentType(MediaType.APPLICATION_JSON))
                .andExpect(jsonPath("$[0].id").value(testProgress.getId()))
                .andExpect(jsonPath("$[0].repetitions").value(testProgress.getRepetitions()))
                .andExpect(jsonPath("$[0].weight").value(testProgress.getWeight()));
    }
}