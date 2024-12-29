package com.example.backend.service;

import com.example.backend.entity.Client;
import com.example.backend.entity.Nutrition;
import com.example.backend.repository.ClientRepository;
import com.example.backend.Enumeration.Goal;
import com.example.backend.Enumeration.Gender;
import com.example.backend.Enumeration.ActivityLevel;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.MockitoAnnotations;

import java.util.Optional;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.Mockito.*;

class NutritionServiceTest {

    @Mock
    private ClientRepository clientRepository;

    @InjectMocks
    private NutritionService nutritionService;

    private Client testClient;

    @BeforeEach
    void setUp() {
        MockitoAnnotations.openMocks(this);
        testClient = new Client();
        testClient.setId(1L);
        testClient.setWeight(75.0); // 75 kg
        testClient.setHeight(180.0); // 180 cm
        testClient.setAge(30);
        testClient.setGender(Gender.MALE);
        testClient.setActivityLevel(ActivityLevel.MODERATE);
        testClient.setGoal(Goal.MAINTAIN_WEIGHT);
    }

    @Test
    void calculateNutrition_Success() {
        when(clientRepository.findById(1L)).thenReturn(Optional.of(testClient));

        Nutrition nutrition = nutritionService.calculateNutrition(1L);

        assertNotNull(nutrition);
        assertTrue(nutrition.getDailyCalories() > 0);
        assertTrue(nutrition.getProtein() > 0);
        assertTrue(nutrition.getCarbs() > 0);
        assertTrue(nutrition.getFat() > 0);
        assertEquals(testClient, nutrition.getClient());
        verify(clientRepository, times(1)).findById(1L);
    }

    @Test
    void calculateNutrition_ClientNotFound() {
        when(clientRepository.findById(999L)).thenReturn(Optional.empty());

        assertThrows(IllegalArgumentException.class, () -> 
            nutritionService.calculateNutrition(999L)
        );
        verify(clientRepository, times(1)).findById(999L);
    }

    @Test
    void calculateBMR_Male() {
        testClient.setGender(Gender.MALE);
        
        // Manual calculation: 10 * 75 + 6.25 * 180 - 5 * 30 + 5
        double expectedBMR = 10 * 75 + 6.25 * 180 - 5 * 30 + 5;
        
        Nutrition nutrition = nutritionService.calculateNutrition(1L);
        when(clientRepository.findById(1L)).thenReturn(Optional.of(testClient));

        assertNotNull(nutrition);
        assertTrue(Math.abs(expectedBMR - nutrition.getDailyCalories() / 
            testClient.getActivityLevel().getValue()) < 1);
    }

    @Test
    void calculateBMR_Female() {
        testClient.setGender(Gender.FEMALE);
        when(clientRepository.findById(1L)).thenReturn(Optional.of(testClient));

        // Manual calculation: 10 * 75 + 6.25 * 180 - 5 * 30 - 161
        double expectedBMR = 10 * 75 + 6.25 * 180 - 5 * 30 - 161;
        
        Nutrition nutrition = nutritionService.calculateNutrition(1L);

        assertNotNull(nutrition);
        assertTrue(Math.abs(expectedBMR - nutrition.getDailyCalories() / 
            testClient.getActivityLevel().getValue()) < 1);
    }

    @Test
    void calculateTDEE_WeightLoss() {
        testClient.setGoal(Goal.WEIGHT_LOSS);
        when(clientRepository.findById(1L)).thenReturn(Optional.of(testClient));

        Nutrition nutrition = nutritionService.calculateNutrition(1L);

        assertNotNull(nutrition);
        // Verify that calories are reduced for weight loss
        assertTrue(nutrition.getDailyCalories() < 
            calculateExpectedTDEE(testClient, false));
    }

    @Test
    void calculateTDEE_WeightGain() {
        testClient.setGoal(Goal.GAIN_WEIGHT);
        when(clientRepository.findById(1L)).thenReturn(Optional.of(testClient));

        Nutrition nutrition = nutritionService.calculateNutrition(1L);

        assertNotNull(nutrition);
        // Verify that calories are increased for weight gain
        assertTrue(nutrition.getDailyCalories() > 
            calculateExpectedTDEE(testClient, false));
    }

    @Test
    void calculateMacros_CorrectDistribution() {
        when(clientRepository.findById(1L)).thenReturn(Optional.of(testClient));

        Nutrition nutrition = nutritionService.calculateNutrition(1L);

        assertNotNull(nutrition);
        // Verify protein calculation (2g per kg of body weight)
        assertEquals(testClient.getWeight() * 2.0, nutrition.getProtein(), 0.1);
        
        // Verify that fat is approximately 25% of total calories
        double expectedFatCalories = nutrition.getDailyCalories() * 0.25;
        assertEquals(expectedFatCalories / 9, nutrition.getFat(), 0.1);
        
        // Verify total calories from macros matches TDEE
        double totalCalories = (nutrition.getProtein() * 4) + 
                             (nutrition.getCarbs() * 4) + 
                             (nutrition.getFat() * 9);
        assertEquals(nutrition.getDailyCalories(), totalCalories, 1.0);
    }

    // Helper method to calculate expected TDEE
    private double calculateExpectedTDEE(Client client, boolean includeGoalAdjustment) {
        double bmr;
        if (client.getGender() == Gender.MALE) {
            bmr = 10 * client.getWeight() + 6.25 * client.getHeight() - 
                  5 * client.getAge() + 5;
        } else {
            bmr = 10 * client.getWeight() + 6.25 * client.getHeight() - 
                  5 * client.getAge() - 161;
        }
        
        double tdee = bmr * client.getActivityLevel().getValue();
        
        if (includeGoalAdjustment) {
            if (client.getGoal() == Goal.WEIGHT_LOSS) {
                tdee -= 500;
            } else if (client.getGoal() == Goal.GAIN_WEIGHT) {
                tdee += 500;
            }
        }
        
        return tdee;
    }
} 