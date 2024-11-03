package com.example.backend.controller;

import com.example.backend.entity.Progress;
import com.example.backend.service.ProgressService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequiredArgsConstructor
@RequestMapping("/api/progress")
public class ProgressController {

    private final ProgressService progressService;

    @PostMapping
    public ResponseEntity<Progress> createProgress(@RequestBody Progress progress) {
        Progress createdProgress = progressService.createProgress(progress);
        return ResponseEntity.ok(createdProgress);
    }

    @PutMapping("/{id}")
    public ResponseEntity<Progress> updateProgress(@PathVariable Long id, @RequestBody Progress progress) {
        Progress updatedProgress = progressService.updateProgress(id, progress);
        return ResponseEntity.ok(updatedProgress);
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteProgress(@PathVariable Long id) {
        progressService.deleteProgress(id);
        return ResponseEntity.noContent().build();
    }

    @GetMapping("/{id}")
    public ResponseEntity<Progress> getProgressById(@PathVariable Long id) {
        Progress progress = progressService.getProgressById(id);
        return ResponseEntity.ok(progress);
    }

    @GetMapping("/client/{clientId}")
    public ResponseEntity<List<Progress>> getProgressByClientId(@PathVariable Long clientId) {
        List<Progress> progressList = progressService.getProgressByClientId(clientId);
        return ResponseEntity.ok(progressList);
    }

    @GetMapping("/exercise/{exerciseId}")
    public ResponseEntity<List<Progress>> getProgressByExerciseId(@PathVariable Long exerciseId) {
        List<Progress> progressList = progressService.getProgressByExerciseId(exerciseId);
        return ResponseEntity.ok(progressList);
    }
}
