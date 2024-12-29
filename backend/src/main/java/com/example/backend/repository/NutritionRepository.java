package com.example.backend.repository;

import com.example.backend.entity.Nutrition;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface NutritionRepository extends JpaRepository<Nutrition, Long> {

    // Custom query if needed to find by client
    Nutrition findByClientId(Long clientId);
}
