package com.example.backend.controller;

import com.example.backend.entity.Client;
import com.example.backend.entity.Exercise;
import com.example.backend.entity.WorkoutPlan;
import com.example.backend.security.JwtUtil;
import com.example.backend.service.ClientDetailsService;
import com.example.backend.service.WorkoutPlanService;
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

import java.util.Arrays;
import java.util.List;
import java.util.Optional;

import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.anyLong;
import static org.mockito.Mockito.doNothing;
import static org.mockito.Mockito.when;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

@WebMvcTest(WorkoutPlanController.class)
class WorkoutPlanControllerTest {

    @Autowired
    private MockMvc mockMvc;

    @Autowired
    private ObjectMapper objectMapper;

    @MockBean
    private WorkoutPlanService workoutPlanService;

    @MockBean
    private JwtUtil jwtUtil;

    @MockBean
    private ClientDetailsService clientDetailsService;

    private WorkoutPlan testWorkoutPlan;
    private Client testClient;
    private Exercise testExercise;

    @BeforeEach
    void setUp() {
        testClient = new Client();
        testClient.setId(1L);

        testExercise = new Exercise();
        testExercise.setId(1L);
        testExercise.setName("Bench Press");
        testExercise.setSets(3);
        testExercise.setReps(10);
        testExercise.setWeight(100.0);

        testWorkoutPlan = new WorkoutPlan();
        testWorkoutPlan.setId(1L);
        testWorkoutPlan.setName("Test Workout Plan");
        testWorkoutPlan.setDurationInWeeks(4);
        testWorkoutPlan.setClient(testClient);
        testWorkoutPlan.setExercises(Arrays.asList(testExercise));
    }

    @Test
    @WithMockUser
    void createWorkoutPlan_ShouldReturnCreatedWorkoutPlan() throws Exception {
        when(workoutPlanService.addWorkoutPlan(any(WorkoutPlan.class))).thenReturn(testWorkoutPlan);

        mockMvc.perform(post("/api/workoutPlans")
                .with(SecurityMockMvcRequestPostProcessors.csrf())
                .contentType(MediaType.APPLICATION_JSON)
                .content(objectMapper.writeValueAsString(testWorkoutPlan)))
                .andExpect(status().isCreated())
                .andExpect(content().contentType(MediaType.APPLICATION_JSON))
                .andExpect(jsonPath("$.id").value(testWorkoutPlan.getId()))
                .andExpect(jsonPath("$.name").value(testWorkoutPlan.getName()))
                .andExpect(jsonPath("$.durationInWeeks").value(testWorkoutPlan.getDurationInWeeks()));
    }

    @Test
    @WithMockUser
    void updateWorkoutPlan_ShouldReturnUpdatedWorkoutPlan() throws Exception {
        when(workoutPlanService.updateWorkoutPlan(anyLong(), any(WorkoutPlan.class))).thenReturn(testWorkoutPlan);

        mockMvc.perform(put("/api/workoutPlans/1")
                .with(SecurityMockMvcRequestPostProcessors.csrf())
                .contentType(MediaType.APPLICATION_JSON)
                .content(objectMapper.writeValueAsString(testWorkoutPlan)))
                .andExpect(status().isOk())
                .andExpect(content().contentType(MediaType.APPLICATION_JSON))
                .andExpect(jsonPath("$.id").value(testWorkoutPlan.getId()))
                .andExpect(jsonPath("$.name").value(testWorkoutPlan.getName()))
                .andExpect(jsonPath("$.durationInWeeks").value(testWorkoutPlan.getDurationInWeeks()));
    }

    @Test
    @WithMockUser
    void updateWorkoutPlan_ShouldReturn404WhenNotFound() throws Exception {
        when(workoutPlanService.updateWorkoutPlan(anyLong(), any(WorkoutPlan.class))).thenReturn(null);

        mockMvc.perform(put("/api/workoutPlans/999")
                .with(SecurityMockMvcRequestPostProcessors.csrf())
                .contentType(MediaType.APPLICATION_JSON)
                .content(objectMapper.writeValueAsString(testWorkoutPlan)))
                .andExpect(status().isNotFound());
    }

    @Test
    @WithMockUser
    void getWorkoutPlansByClientId_ShouldReturnWorkoutPlanList() throws Exception {
        List<WorkoutPlan> workoutPlans = Arrays.asList(testWorkoutPlan);
        when(workoutPlanService.getWorkoutPlansByClientId(anyLong())).thenReturn(workoutPlans);

        mockMvc.perform(get("/api/workoutPlans/client/1"))
                .andExpect(status().isOk())
                .andExpect(content().contentType(MediaType.APPLICATION_JSON))
                .andExpect(jsonPath("$[0].id").value(testWorkoutPlan.getId()))
                .andExpect(jsonPath("$[0].name").value(testWorkoutPlan.getName()))
                .andExpect(jsonPath("$[0].durationInWeeks").value(testWorkoutPlan.getDurationInWeeks()));
    }

    @Test
    @WithMockUser
    void getWorkoutPlanById_ShouldReturnWorkoutPlan() throws Exception {
        when(workoutPlanService.getWorkoutPlanById(anyLong())).thenReturn(Optional.of(testWorkoutPlan));

        mockMvc.perform(get("/api/workoutPlans/1"))
                .andExpect(status().isOk())
                .andExpect(content().contentType(MediaType.APPLICATION_JSON))
                .andExpect(jsonPath("$.id").value(testWorkoutPlan.getId()))
                .andExpect(jsonPath("$.name").value(testWorkoutPlan.getName()))
                .andExpect(jsonPath("$.durationInWeeks").value(testWorkoutPlan.getDurationInWeeks()));
    }

    @Test
    @WithMockUser
    void getWorkoutPlanById_ShouldReturn404WhenNotFound() throws Exception {
        when(workoutPlanService.getWorkoutPlanById(anyLong())).thenReturn(Optional.empty());

        mockMvc.perform(get("/api/workoutPlans/999"))
                .andExpect(status().isNotFound());
    }

    @Test
    @WithMockUser
    void deleteWorkoutPlan_ShouldReturnNoContent() throws Exception {
        doNothing().when(workoutPlanService).deleteWorkoutPlan(anyLong());

        mockMvc.perform(delete("/api/workoutPlans/1")
                .with(SecurityMockMvcRequestPostProcessors.csrf()))
                .andExpect(status().isNoContent());
    }
}