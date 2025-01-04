package com.example.backend.controller;

import com.example.backend.entity.Nutrition;
import com.example.backend.service.NutritionService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api")
public class NutritionController {

    private final NutritionService nutritionService;

    public NutritionController(NutritionService nutritionService) {
        this.nutritionService = nutritionService;
    }

    @GetMapping("/nutrition/{clientId}")
    public ResponseEntity<List<Nutrition>> getNutrition(@PathVariable Long clientId) {
        try {
            List<Nutrition> nutritions = nutritionService.getNutritionsByClientId(clientId);
            return ResponseEntity.ok(nutritions);
        } catch (IllegalArgumentException e) {
            return ResponseEntity.notFound().build();
        }
    }
}
