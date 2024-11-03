package com.example.backend.service;

import com.example.backend.entity.Progress;
import com.example.backend.repository.ProgressRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public class ProgressService {

    private final ProgressRepository progressRepository;

    public ProgressService(ProgressRepository progressRepository) {
        this.progressRepository = progressRepository;
    }

    public Progress createProgress(Progress progress) {
        return progressRepository.save(progress);
    }

    public Progress updateProgress(Long id, Progress updatedProgress) {
        Optional<Progress> existingProgress = progressRepository.findById(id);
        if (existingProgress.isPresent()) {
            Progress progress = existingProgress.get();
            progress.setDate(updatedProgress.getDate());
            progress.setRepetitions(updatedProgress.getRepetitions());
            progress.setWeight(updatedProgress.getWeight());
            progress.setSets(updatedProgress.getSets());
            progress.setDuration(updatedProgress.getDuration());
            progress.setNotes(updatedProgress.getNotes());
            return progressRepository.save(progress);
        } else {
            throw new RuntimeException("Progress not found with id " + id);
        }
    }

    public void deleteProgress(Long id) {
        progressRepository.deleteById(id);
    }

    public Progress getProgressById(Long id) {
        return progressRepository.findById(id).orElse(null);
    }

    public List<Progress> getProgressByClientId(Long clientId) {
        return progressRepository.findByClientId(clientId);
    }

    public List<Progress> getProgressByExerciseId(Long exerciseId) {
        return progressRepository.findByExerciseId(exerciseId);
    }
}
