package com.example.backend.controller;

import com.example.backend.entity.Client;
import com.example.backend.entity.Progress;
import com.example.backend.service.ClientService;
import com.example.backend.service.ProgressService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDate;
import java.util.List;

@RestController
@RequiredArgsConstructor
@RequestMapping("/api/progress")
public class ProgressController {

    private final ProgressService progressService;
    private final ClientService clientService;

    @PostMapping
    public ResponseEntity<Progress> createProgress(@RequestBody Progress progress, Authentication authentication) {
        try {
            if (authentication == null) {
                return ResponseEntity.status(HttpStatus.UNAUTHORIZED).build();
            }

            // Get the user details from the authentication object
            UserDetails userDetails = (UserDetails) authentication.getPrincipal();
            String userEmail = userDetails.getUsername();

            System.out.println("Creating progress for user: " + userEmail);
            System.out.println("Received progress data: " + progress);

            // Get the client using the email
            Client client = clientService.getClientByEmail(userEmail);
            if (client == null) {
                System.out.println("Client not found for email: " + userEmail);
                return ResponseEntity.notFound().build();
            }

            // Set the client before saving
            progress.setClient(client);

            // Convert the date if it's null
            if (progress.getDate() == null) {
                progress.setDate(LocalDate.now());
            }

            Progress createdProgress = progressService.createProgress(progress);
            System.out.println("Progress created successfully: " + createdProgress);
            return ResponseEntity.ok(createdProgress);
        } catch (Exception e) {
            System.err.println("Error creating progress: " + e.getMessage());
            e.printStackTrace();
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(null);
        }
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

    @GetMapping("/client")
    public ResponseEntity<List<Progress>> getClientProgress(Authentication authentication) {
        if (authentication == null) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).build();
        }

        // Get the user details from the authentication object
        UserDetails userDetails = (UserDetails) authentication.getPrincipal();
        String userEmail = userDetails.getUsername(); // This will be the email

        // Get the client ID using the email
        Client client = clientService.getClientByEmail(userEmail);
        if (client == null) {
            return ResponseEntity.notFound().build();
        }

        // Get the progress for this client
        List<Progress> progressList = progressService.getProgressByClientId(client.getId());
        return ResponseEntity.ok(progressList);
    }
    @GetMapping("/exercise/{exerciseId}")
    public ResponseEntity<List<Progress>> getProgressByExerciseId(@PathVariable Long exerciseId) {
        List<Progress> progressList = progressService.getProgressByExerciseId(exerciseId);
        return ResponseEntity.ok(progressList);
    }
}
