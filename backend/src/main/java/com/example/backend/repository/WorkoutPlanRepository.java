package com.example.backend.repository;

import com.example.backend.entity.WorkoutPlan;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import java.util.List;

@Repository
public interface WorkoutPlanRepository extends JpaRepository<WorkoutPlan, Long> {

    // Find all workout plans for a specific client
    List<WorkoutPlan> findByClientId(Long clientId);
    @Query("SELECT DISTINCT wp FROM WorkoutPlan wp JOIN wp.exercises e WHERE e.name IN :exerciseNames")
    List<WorkoutPlan> findByExerciseNamesIn(@Param("exerciseNames") List<String> exerciseNames);
}

