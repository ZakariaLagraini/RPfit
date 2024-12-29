package com.example.backend.controller;

import com.example.backend.Enumeration.Goal;
import com.example.backend.entity.Client;
import com.example.backend.repository.ClientRepository;
import com.example.backend.security.JwtUtil;
import com.example.backend.service.ClientService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.authentication.*;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequiredArgsConstructor
@RequestMapping("/api")
public class ClientController {

    private final ClientService clientService;
    private final ClientRepository clientRepository;
    private final PasswordEncoder passwordEncoder;
    private final AuthenticationManager authenticationManager;
    private final JwtUtil jwtUtil;
    private final com.example.backend.service.ClientDetailsService clientDetailsService;

    @PostMapping("/register")
    public ResponseEntity<?> register(@RequestBody Client client) {
        System.out.println("Requête reçue pour l'email : " + client.getEmail());        if (clientRepository.findByEmail(client.getEmail()) != null) {
            return ResponseEntity.badRequest().body("L'email est déjà utilisé");
        }
        // Hache le mot de passe avant de le stocker
        client.setPassword(passwordEncoder.encode(client.getPassword()));
        Client savedClient = clientRepository.save(client);
        return ResponseEntity.ok(savedClient);
    }

    @PostMapping("/login")
    public ResponseEntity<?> login(@RequestBody Client client) {
        try {
            // Authentifie l'utilisateur
            Authentication authentication = authenticationManager.authenticate(
                    new UsernamePasswordAuthenticationToken(client.getEmail(), client.getPassword())
            );

            // Charge les détails de l'utilisateur
            UserDetails userDetails = clientDetailsService.loadUserByUsername(client.getEmail());

            // Génère le token JWT
            final String jwt = jwtUtil.generateToken(userDetails.getUsername());

            // Retourne le token JWT
            return ResponseEntity.ok(jwt);
        } catch (BadCredentialsException e) {
            // Si les informations d'identification sont incorrectes
            return ResponseEntity.status(401).body("Email ou mot de passe incorrect");
        }
    }

    @GetMapping
    public ResponseEntity<List<Client>> getAllClients() {
        return ResponseEntity.ok(clientService.getAllClients());
    }

    @PutMapping("/{id}")
    public ResponseEntity<Client> updateClient(@PathVariable Long id, @RequestBody Client client) {
        return ResponseEntity.ok(clientService.updateClient(id, client));
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteClient(@PathVariable Long id) {
        clientService.deleteClient(id);
        return ResponseEntity.noContent().build();
    }

    @GetMapping("/goal/{goal}")
    public ResponseEntity<List<Client>> getClientsByGoal(@PathVariable Goal goal) {
        List<Client> clients = clientService.getClientsByGoal(goal);
        return ResponseEntity.ok(clients);
    }

    @GetMapping("/profile")
    public ResponseEntity<Client> getClientProfile(Authentication authentication) {
        String email = authentication.getName();
        Client client = clientService.getClientByEmail(email);

        // Remove sensitive information before returning
        client.setPassword(null);

        return ResponseEntity.ok(client);
    }
}
