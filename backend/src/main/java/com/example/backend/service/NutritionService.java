package com.example.backend.service;

import com.example.backend.entity.Client;
import com.example.backend.entity.Nutrition;
import com.example.backend.repository.ClientRepository;
import com.example.backend.Enumeration.Goal;
import com.example.backend.Enumeration.Gender;
import com.example.backend.Enumeration.ActivityLevel;
import org.springframework.stereotype.Service;

@Service
public class NutritionService {

    private final ClientRepository clientRepository;

    public NutritionService(ClientRepository clientRepository) {
        this.clientRepository = clientRepository;
    }

    public Nutrition calculateNutrition(Long clientId) {
        Client client = clientRepository.findById(clientId)
                .orElseThrow(() -> new IllegalArgumentException("Client not found"));

        // Calculate BMR
        double bmr = calculateBMR(client);

        // Calculate TDEE
        double tdee = calculateTDEE(bmr, client.getActivityLevel(), client.getGoal());

        // Calculate Macronutrients
        Nutrition nutrition = calculateMacros(client, tdee);

        nutrition.setClient(client); // Link nutrition to the client
        return nutrition;
    }

    private double calculateBMR(Client client) {
        if (client.getGender() == Gender.MALE) {
            return 10 * client.getWeight() + 6.25 * client.getHeight() - 5 * client.getAge() + 5;
        } else {
            return 10 * client.getWeight() + 6.25 * client.getHeight() - 5 * client.getAge() - 161;
        }
    }

    private double calculateTDEE(double bmr, ActivityLevel activityLevel, Goal goal) {
        double tdee = bmr * activityLevel.getValue();

        if (goal == Goal.WEIGHT_LOSS) {
            tdee -= 500; // Reduce 500 calories for weight loss
        } else if (goal == Goal.GAIN_WEIGHT) {
            tdee += 500; // Add 500 calories for weight gain
        }

        return tdee;
    }

    private Nutrition calculateMacros(Client client, double tdee) {
        double weight = client.getWeight();

        // Protein: 2.0 grams per kg of body weight
        double protein = weight * 2.0;
        double proteinCalories = protein * 4;

        // Fat: 25% of total calories
        double fatCalories = 0.25 * tdee;
        double fat = fatCalories / 9;

        // Carbs: Remaining calories
        double carbCalories = tdee - (proteinCalories + fatCalories);
        double carbs = carbCalories / 4;

        return new Nutrition(tdee, protein, carbs, fat);
    }
}
