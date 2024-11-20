package com.example.backend.controller;

import com.example.backend.entity.Nutrition;
import com.example.backend.service.NutritionService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api")
public class NutritionController {

    private final NutritionService nutritionService;

    public NutritionController(NutritionService nutritionService) {
        this.nutritionService = nutritionService;
    }

    @GetMapping("/nutrition/{clientId}")
    public ResponseEntity<Nutrition> getNutrition(@PathVariable Long clientId) {
        Nutrition nutrition = nutritionService.calculateNutrition(clientId);
        return ResponseEntity.ok(nutrition);
    }
}
