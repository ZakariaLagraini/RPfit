package com.example.backend.service;

import com.example.backend.entity.Client;
import com.example.backend.entity.Nutrition;
import com.example.backend.repository.ClientRepository;
import com.example.backend.Enumeration.Gender;
import com.example.backend.Enumeration.Goal;
import com.example.backend.Enumeration.ActivityLevel;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.util.Optional;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.within;
import static org.junit.jupiter.api.Assertions.assertThrows;
import static org.mockito.ArgumentMatchers.anyLong;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
class NutritionServiceTest {

    @Mock
    private ClientRepository clientRepository;

    @InjectMocks
    private NutritionService nutritionService;

    private Client testClient;

    @BeforeEach
    void setUp() {
        testClient = new Client();
        testClient.setId(1L);
        testClient.setWeight(70.0);
        testClient.setHeight(175.0);
        testClient.setAge(25.0);
        testClient.setGender(Gender.MALE);
        testClient.setActivityLevel(ActivityLevel.MODERATELY_ACTIVE);
        testClient.setGoal(Goal.MAINTAIN);
    }

    @Test
    void calculateNutrition_ShouldReturnCorrectNutritionForMale() {
        // Given
        when(clientRepository.findById(anyLong())).thenReturn(Optional.of(testClient));

        // When
        Nutrition result = nutritionService.calculateNutrition(1L);

        // Then
        assertThat(result).isNotNull();
        // BMR for male = 10 * 70 + 6.25 * 175 - 5 * 25 + 5 = 1673.75
        // TDEE = 1673.75 * 1.55 = 2594.3125
        assertThat(result.getCalories()).isEqualTo(2594.3125);
        // Protein = 70kg * 2.0 = 140g
        assertThat(result.getProteins()).isEqualTo(140.0);
        // Fat calories = 2594.3125 * 0.25 = 648.578125
        // Fat grams = 648.578125 / 9 = 72.064...
        assertThat(result.getFats()).isCloseTo(72.064, within(0.001));
        // Remaining calories for carbs = 2594.3125 - (140 * 4 + 648.578125) = 1385.734375
        // Carb grams = 1385.734375 / 4 = 346.433...
        assertThat(result.getCarbs()).isCloseTo(346.433, within(0.001));
    }

    @Test
    void calculateNutrition_ShouldReturnCorrectNutritionForFemale() {
        // Given
        testClient.setGender(Gender.FEMALE);
        when(clientRepository.findById(anyLong())).thenReturn(Optional.of(testClient));

        // When
        Nutrition result = nutritionService.calculateNutrition(1L);

        // Then
        assertThat(result).isNotNull();
        // BMR for female = 10 * 70 + 6.25 * 175 - 5 * 25 - 161 = 1507.75
        // TDEE = 1507.75 * 1.55 = 2337.0125
        assertThat(result.getCalories()).isCloseTo(2337.0125, within(0.0001));
        // Protein = 70kg * 2.0 = 140g
        assertThat(result.getProteins()).isEqualTo(140.0);
        // Fat = (2337.0125 * 0.25) / 9 = 64.917
        assertThat(result.getFats()).isCloseTo(64.917, within(0.001));
        // Remaining calories = 2337.0125 - (140 * 4 + 2337.0125 * 0.25)
        // Carbs = remaining calories / 4 = 298.19
        assertThat(result.getCarbs()).isCloseTo(298.19, within(0.001));
    }

    @Test
    void calculateNutrition_ShouldAdjustForWeightLossGoal() {
        // Given
        testClient.setGoal(Goal.WEIGHT_LOSS);
        when(clientRepository.findById(anyLong())).thenReturn(Optional.of(testClient));

        // When
        Nutrition result = nutritionService.calculateNutrition(1L);

        // Then
        assertThat(result).isNotNull();
        // TDEE = 2594.3125 - 500 = 2094.3125
        assertThat(result.getCalories()).isEqualTo(2094.3125);
    }

    @Test
    void calculateNutrition_ShouldAdjustForWeightGainGoal() {
        // Given
        testClient.setGoal(Goal.GAIN_WEIGHT);
        when(clientRepository.findById(anyLong())).thenReturn(Optional.of(testClient));

        // When
        Nutrition result = nutritionService.calculateNutrition(1L);

        // Then
        assertThat(result).isNotNull();
        // TDEE = 2594.3125 + 500 = 3094.3125
        assertThat(result.getCalories()).isEqualTo(3094.3125);
    }

    @Test
    void calculateNutrition_ShouldThrowExceptionWhenClientNotFound() {
        // Given
        when(clientRepository.findById(anyLong())).thenReturn(Optional.empty());

        // When/Then
        assertThrows(IllegalArgumentException.class, () -> {
            nutritionService.calculateNutrition(1L);
        });
    }
}