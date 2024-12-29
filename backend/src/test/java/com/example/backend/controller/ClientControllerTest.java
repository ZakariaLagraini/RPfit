package com.example.backend.controller;

import com.example.backend.Enumeration.Goal;
import com.example.backend.entity.Client;
import com.example.backend.repository.ClientRepository;
import com.example.backend.service.ClientService;
import com.example.backend.service.ClientDetailsService;
import com.example.backend.security.JwtUtil;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.MockitoAnnotations;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.BadCredentialsException;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.userdetails.User;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.crypto.password.PasswordEncoder;

import java.util.Arrays;
import java.util.Collections;
import java.util.List;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.anyString;
import static org.mockito.Mockito.*;

class ClientControllerTest {

    @Mock
    private ClientService clientService;
    
    @Mock
    private ClientRepository clientRepository;
    
    @Mock
    private PasswordEncoder passwordEncoder;
    
    @Mock
    private AuthenticationManager authenticationManager;
    
    @Mock
    private JwtUtil jwtUtil;
    
    @Mock
    private ClientDetailsService clientDetailsService;

    @Mock
    private Authentication authentication;

    @InjectMocks
    private ClientController clientController;

    private Client testClient;

    @BeforeEach
    void setUp() {
        MockitoAnnotations.openMocks(this);
        testClient = new Client();
        testClient.setId(1L);
        testClient.setEmail("test@example.com");
        testClient.setPassword("password123");
    }

    @Test
    void register_Success() {
        when(clientRepository.findByEmail(anyString())).thenReturn(null);
        when(passwordEncoder.encode(anyString())).thenReturn("encodedPassword");
        when(clientRepository.save(any(Client.class))).thenReturn(testClient);

        ResponseEntity<?> response = clientController.register(testClient);

        assertEquals(HttpStatus.OK, response.getStatusCode());
        assertNotNull(response.getBody());
        verify(clientRepository, times(1)).findByEmail(testClient.getEmail());
        verify(passwordEncoder, times(1)).encode(testClient.getPassword());
        verify(clientRepository, times(1)).save(any(Client.class));
    }

    @Test
    void register_EmailAlreadyExists() {
        when(clientRepository.findByEmail(anyString())).thenReturn(testClient);

        ResponseEntity<?> response = clientController.register(testClient);

        assertEquals(HttpStatus.BAD_REQUEST, response.getStatusCode());
        assertEquals("L'email est déjà utilisé", response.getBody());
        verify(clientRepository, times(1)).findByEmail(testClient.getEmail());
        verify(clientRepository, never()).save(any(Client.class));
    }

    @Test
    void login_Success() {
        String jwt = "dummy.jwt.token";
        UserDetails userDetails = new User(testClient.getEmail(), testClient.getPassword(), Collections.emptyList());
        
        when(authenticationManager.authenticate(any(UsernamePasswordAuthenticationToken.class)))
            .thenReturn(authentication);
        when(clientDetailsService.loadUserByUsername(anyString())).thenReturn(userDetails);
        when(jwtUtil.generateToken(anyString())).thenReturn(jwt);

        ResponseEntity<?> response = clientController.login(testClient);

        assertEquals(HttpStatus.OK, response.getStatusCode());
        assertEquals(jwt, response.getBody());
        verify(authenticationManager, times(1))
            .authenticate(any(UsernamePasswordAuthenticationToken.class));
        verify(clientDetailsService, times(1)).loadUserByUsername(testClient.getEmail());
        verify(jwtUtil, times(1)).generateToken(testClient.getEmail());
    }

    @Test
    void login_BadCredentials() {
        when(authenticationManager.authenticate(any(UsernamePasswordAuthenticationToken.class)))
            .thenThrow(new BadCredentialsException("Bad credentials"));

        ResponseEntity<?> response = clientController.login(testClient);

        assertEquals(HttpStatus.UNAUTHORIZED, response.getStatusCode());
        assertEquals("Email ou mot de passe incorrect", response.getBody());
        verify(authenticationManager, times(1))
            .authenticate(any(UsernamePasswordAuthenticationToken.class));
        verify(clientDetailsService, never()).loadUserByUsername(anyString());
        verify(jwtUtil, never()).generateToken(anyString());
    }

    @Test
    void getAllClients_Success() {
        List<Client> clients = Arrays.asList(testClient);
        when(clientService.getAllClients()).thenReturn(clients);

        ResponseEntity<List<Client>> response = clientController.getAllClients();

        assertEquals(HttpStatus.OK, response.getStatusCode());
        assertEquals(clients, response.getBody());
        verify(clientService, times(1)).getAllClients();
    }

    @Test
    void updateClient_Success() {
        when(clientService.updateClient(eq(1L), any(Client.class))).thenReturn(testClient);

        ResponseEntity<Client> response = clientController.updateClient(1L, testClient);

        assertEquals(HttpStatus.OK, response.getStatusCode());
        assertEquals(testClient, response.getBody());
        verify(clientService, times(1)).updateClient(eq(1L), any(Client.class));
    }

    @Test
    void deleteClient_Success() {
        doNothing().when(clientService).deleteClient(1L);

        ResponseEntity<Void> response = clientController.deleteClient(1L);

        assertEquals(HttpStatus.NO_CONTENT, response.getStatusCode());
        verify(clientService, times(1)).deleteClient(1L);
    }

    @Test
    void getClientsByGoal_Success() {
        List<Client> clients = Arrays.asList(testClient);
        when(clientService.getClientsByGoal(any(Goal.class))).thenReturn(clients);

        ResponseEntity<List<Client>> response = clientController.getClientsByGoal(Goal.WEIGHT_LOSS);

        assertEquals(HttpStatus.OK, response.getStatusCode());
        assertEquals(clients, response.getBody());
        verify(clientService, times(1)).getClientsByGoal(Goal.WEIGHT_LOSS);
    }

    @Test
    void getClientProfile_Success() {
        when(authentication.getName()).thenReturn(testClient.getEmail());
        when(clientService.getClientByEmail(testClient.getEmail())).thenReturn(testClient);

        ResponseEntity<Client> response = clientController.getClientProfile(authentication);

        assertEquals(HttpStatus.OK, response.getStatusCode());
        assertNotNull(response.getBody());
        assertNull(response.getBody().getPassword());
        verify(clientService, times(1)).getClientByEmail(testClient.getEmail());
    }
} 