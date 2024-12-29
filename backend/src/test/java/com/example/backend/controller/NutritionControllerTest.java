package com.example.backend.controller;

import com.example.backend.entity.Nutrition;
import com.example.backend.entity.Client;
import com.example.backend.service.NutritionService;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.MockitoAnnotations;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.Mockito.*;

class NutritionControllerTest {

    @Mock
    private NutritionService nutritionService;

    @InjectMocks
    private NutritionController nutritionController;

    private Nutrition testNutrition;
    private Client testClient;

    @BeforeEach
    void setUp() {
        MockitoAnnotations.openMocks(this);
        
        testClient = new Client();
        testClient.setId(1L);
        testClient.setWeight(75.0);
        testClient.setHeight(180.0);
        
        testNutrition = new Nutrition();
        testNutrition.setId(1L);
        testNutrition.setClient(testClient);
        testNutrition.setDailyCalories(2500.0);
        testNutrition.setProtein(180.0);
        testNutrition.setCarbs(300.0);
        testNutrition.setFat(83.0);
    }

    @Test
    void getNutrition_Success() {
        when(nutritionService.calculateNutrition(1L)).thenReturn(testNutrition);

        ResponseEntity<Nutrition> response = nutritionController.getNutrition(1L);

        assertEquals(HttpStatus.OK, response.getStatusCode());
        assertNotNull(response.getBody());
        assertEquals(testNutrition, response.getBody());
        assertEquals(2500.0, response.getBody().getDailyCalories());
        assertEquals(180.0, response.getBody().getProtein());
        assertEquals(300.0, response.getBody().getCarbs());
        assertEquals(83.0, response.getBody().getFat());
        verify(nutritionService, times(1)).calculateNutrition(1L);
    }

    @Test
    void getNutrition_ClientNotFound() {
        when(nutritionService.calculateNutrition(999L))
            .thenThrow(new IllegalArgumentException("Client not found"));

        assertThrows(IllegalArgumentException.class, () -> 
            nutritionController.getNutrition(999L)
        );
        
        verify(nutritionService, times(1)).calculateNutrition(999L);
    }

    @Test
    void getNutrition_ValidatesNutritionValues() {
        when(nutritionService.calculateNutrition(1L)).thenReturn(testNutrition);

        ResponseEntity<Nutrition> response = nutritionController.getNutrition(1L);

        assertNotNull(response.getBody());
        assertTrue(response.getBody().getDailyCalories() > 0);
        assertTrue(response.getBody().getProtein() > 0);
        assertTrue(response.getBody().getCarbs() > 0);
        assertTrue(response.getBody().getFat() > 0);
        
        // Verify macronutrient distribution adds up correctly
        double totalCalories = response.getBody().getProtein() * 4 + 
                             response.getBody().getCarbs() * 4 + 
                             response.getBody().getFat() * 9;
        assertEquals(response.getBody().getDailyCalories(), totalCalories, 1.0);
    }

    @Test
    void getNutrition_IncludesClientInfo() {
        when(nutritionService.calculateNutrition(1L)).thenReturn(testNutrition);

        ResponseEntity<Nutrition> response = nutritionController.getNutrition(1L);

        assertNotNull(response.getBody());
        assertNotNull(response.getBody().getClient());
        assertEquals(1L, response.getBody().getClient().getId());
        assertEquals(75.0, response.getBody().getClient().getWeight());
        assertEquals(180.0, response.getBody().getClient().getHeight());
    }

    @Test
    void getNutrition_HandlesZeroValues() {
        testNutrition.setDailyCalories(0.0);
        when(nutritionService.calculateNutrition(1L)).thenReturn(testNutrition);

        ResponseEntity<Nutrition> response = nutritionController.getNutrition(1L);

        assertEquals(HttpStatus.OK, response.getStatusCode());
        assertNotNull(response.getBody());
        assertEquals(0.0, response.getBody().getDailyCalories());
    }

    @Test
    void getNutrition_HandlesNullClient() {
        testNutrition.setClient(null);
        when(nutritionService.calculateNutrition(1L)).thenReturn(testNutrition);

        ResponseEntity<Nutrition> response = nutritionController.getNutrition(1L);

        assertEquals(HttpStatus.OK, response.getStatusCode());
        assertNotNull(response.getBody());
        assertNull(response.getBody().getClient());
    }
} 