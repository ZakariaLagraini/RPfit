package com.example.backend.controller;

import com.example.backend.entity.Exercise;
import com.example.backend.entity.WorkoutPlan;
import com.example.backend.security.JwtUtil;
import com.example.backend.service.ClientDetailsService;
import com.example.backend.service.ExerciseService;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.WebMvcTest;
import org.springframework.boot.test.mock.mockito.MockBean;
import org.springframework.http.MediaType;
import org.springframework.security.test.context.support.WithMockUser;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.setup.MockMvcBuilders;
import org.springframework.web.context.WebApplicationContext;

import java.util.Arrays;
import java.util.Optional;

import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.*;
import static org.springframework.security.test.web.servlet.request.SecurityMockMvcRequestPostProcessors.csrf;
import static org.springframework.security.test.web.servlet.setup.SecurityMockMvcConfigurers.springSecurity;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

@WebMvcTest(ExerciseController.class)
public class ExerciseControllerTest {

    @Autowired
    private WebApplicationContext context;

    private MockMvc mockMvc;

    @MockBean
    private ExerciseService exerciseService;

    @MockBean
    private JwtUtil jwtUtil;

    @MockBean
    private ClientDetailsService clientDetailsService;

    private Exercise testExercise;
    private ObjectMapper objectMapper = new ObjectMapper();

    @BeforeEach
    void setUp() {
        mockMvc = MockMvcBuilders
                .webAppContextSetup(context)
                .apply(springSecurity())
                .build();

        testExercise = new Exercise();
        testExercise.setId(1L);
        testExercise.setName("Bench Press");
        testExercise.setSets(3);
        testExercise.setReps(10);
        testExercise.setWeight(60.0);
        testExercise.setRestTime(90);
        testExercise.setWorkoutPlan(new WorkoutPlan());
    }

    @Test
    @WithMockUser(roles = "USER")
    void createExercise_Success() throws Exception {
        when(exerciseService.addExercise(any(Exercise.class))).thenReturn(testExercise);

        mockMvc.perform(post("/api/exercises")
                .with(csrf())
                .contentType(MediaType.APPLICATION_JSON)
                .content(objectMapper.writeValueAsString(testExercise)))
                .andExpect(status().isCreated())
                .andExpect(jsonPath("$.name").value("Bench Press"))
                .andExpect(jsonPath("$.sets").value(3))
                .andExpect(jsonPath("$.reps").value(10))
                .andExpect(jsonPath("$.weight").value(60.0))
                .andExpect(jsonPath("$.restTime").value(90));

        verify(exerciseService).addExercise(any(Exercise.class));
    }

    @Test
    @WithMockUser(roles = "USER")
    void updateExercise_Success() throws Exception {
        when(exerciseService.updateExercise(eq(1L), any(Exercise.class))).thenReturn(testExercise);

        mockMvc.perform(put("/api/exercises/1")
                .with(csrf())
                .contentType(MediaType.APPLICATION_JSON)
                .content(objectMapper.writeValueAsString(testExercise)))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.name").value("Bench Press"));

        verify(exerciseService).updateExercise(eq(1L), any(Exercise.class));
    }

    @Test
    @WithMockUser(roles = "USER")
    void updateExercise_NotFound() throws Exception {
        when(exerciseService.updateExercise(eq(1L), any(Exercise.class))).thenReturn(null);

        mockMvc.perform(put("/api/exercises/1")
                .with(csrf())
                .contentType(MediaType.APPLICATION_JSON)
                .content(objectMapper.writeValueAsString(testExercise)))
                .andExpect(status().isNotFound());

        verify(exerciseService).updateExercise(eq(1L), any(Exercise.class));
    }

    @Test
    @WithMockUser(roles = "USER")
    void getExercisesByWorkoutPlanId_Success() throws Exception {
        when(exerciseService.getExercisesByWorkoutPlanId(1L))
                .thenReturn(Arrays.asList(testExercise));

        mockMvc.perform(get("/api/exercises/workoutPlan/1")
                .with(csrf()))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$[0].name").value("Bench Press"));

        verify(exerciseService).getExercisesByWorkoutPlanId(1L);
    }

    @Test
    @WithMockUser(roles = "USER")
    void getExerciseById_Success() throws Exception {
        when(exerciseService.getExerciseById(1L)).thenReturn(Optional.of(testExercise));

        mockMvc.perform(get("/api/exercises/1")
                .with(csrf()))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.name").value("Bench Press"));

        verify(exerciseService).getExerciseById(1L);
    }

    @Test
    @WithMockUser(roles = "USER")
    void getExerciseById_NotFound() throws Exception {
        when(exerciseService.getExerciseById(1L)).thenReturn(Optional.empty());

        mockMvc.perform(get("/api/exercises/1")
                .with(csrf()))
                .andExpect(status().isNotFound());

        verify(exerciseService).getExerciseById(1L);
    }

    @Test
    @WithMockUser(roles = "USER")
    void deleteExercise_Success() throws Exception {
        mockMvc.perform(delete("/api/exercises/1")
                .with(csrf()))
                .andExpect(status().isNoContent());

        verify(exerciseService).deleteExercise(1L);
    }

    @Test
    @WithMockUser(roles = "USER")
    void getAllExercises_Success() throws Exception {
        when(exerciseService.getAllExercises()).thenReturn(Arrays.asList(testExercise));

        mockMvc.perform(get("/api/exercises/all")
                .with(csrf()))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$[0].name").value("Bench Press"));

        verify(exerciseService).getAllExercises();
    }
}