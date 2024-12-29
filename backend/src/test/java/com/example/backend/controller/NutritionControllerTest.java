package com.example.backend.controller;

import com.example.backend.entity.Client;
import com.example.backend.entity.Nutrition;
import com.example.backend.service.NutritionService;
import com.example.backend.security.JwtUtil;
import com.example.backend.service.ClientDetailsService;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.WebMvcTest;
import org.springframework.boot.test.mock.mockito.MockBean;
import org.springframework.http.MediaType;
import org.springframework.security.test.context.support.WithMockUser;
import org.springframework.test.web.servlet.MockMvc;

import static org.mockito.ArgumentMatchers.anyLong;
import static org.mockito.Mockito.when;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

@WebMvcTest(NutritionController.class)
class NutritionControllerTest {

    @Autowired
    private MockMvc mockMvc;

    @MockBean
    private NutritionService nutritionService;

    @MockBean
    private JwtUtil jwtUtil;

    @MockBean
    private ClientDetailsService clientDetailsService;

    private Nutrition testNutrition;
    private Client testClient;

    @BeforeEach
    void setUp() {
        // Create a test nutrition object
        testNutrition = new Nutrition(2500.0, 180.0, 250.0, 83.0);
        
        // Create a test client
        testClient = new Client();
        testClient.setId(1L);
        
        // Set the client for the nutrition
        testNutrition.setClient(testClient);
    }

    @Test
    @WithMockUser
    void getNutrition_ShouldReturnNutritionForValidClientId() throws Exception {
        // Given
        when(nutritionService.calculateNutrition(anyLong())).thenReturn(testNutrition);

        // When/Then
        mockMvc.perform(get("/api/nutrition/1")
                .contentType(MediaType.APPLICATION_JSON))
                .andExpect(status().isOk())
                .andExpect(content().contentType(MediaType.APPLICATION_JSON))
                .andExpect(jsonPath("$.calories").value(2500.0))
                .andExpect(jsonPath("$.proteins").value(180.0))
                .andExpect(jsonPath("$.carbs").value(250.0))
                .andExpect(jsonPath("$.fats").value(83.0));
    }

    @Test
    @WithMockUser
    void getNutrition_ShouldReturn404WhenClientNotFound() throws Exception {
        // Given
        when(nutritionService.calculateNutrition(anyLong()))
                .thenThrow(new IllegalArgumentException("Client not found"));

        // When/Then
        mockMvc.perform(get("/api/nutrition/999")
                .contentType(MediaType.APPLICATION_JSON))
                .andExpect(status().isNotFound());
    }
}