package com.example.backend.repository;

import com.example.backend.entity.WorkoutPlan;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import java.util.List;

@Repository
public interface WorkoutPlanRepository extends JpaRepository<WorkoutPlan, Long> {

    // Find all workout plans for a specific client
    List<WorkoutPlan> findByClientId(Long clientId);
}
