package com.example.backend.service;

import com.example.backend.entity.Client;
import com.example.backend.repository.ClientRepository;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.MockitoAnnotations;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UsernameNotFoundException;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.Mockito.*;

class ClientDetailsServiceTest {

    @Mock
    private ClientRepository clientRepository;

    @InjectMocks
    private ClientDetailsService clientDetailsService;

    @BeforeEach
    void setUp() {
        MockitoAnnotations.openMocks(this);
    }

    @Test
    void loadUserByUsername_WhenClientExists_ReturnsUserDetails() {
        // Arrange
        String email = "test@example.com";
        String password = "password123";
        Client client = new Client();
        client.setEmail(email);
        client.setPassword(password);
        
        when(clientRepository.findByEmail(email)).thenReturn(client);

        // Act
        UserDetails userDetails = clientDetailsService.loadUserByUsername(email);

        // Assert
        assertNotNull(userDetails);
        assertEquals(email, userDetails.getUsername());
        assertEquals(password, userDetails.getPassword());
        assertTrue(userDetails.getAuthorities().isEmpty());
        verify(clientRepository, times(1)).findByEmail(email);
    }

    @Test
    void loadUserByUsername_WhenClientNotFound_ThrowsException() {
        // Arrange
        String email = "nonexistent@example.com";
        when(clientRepository.findByEmail(email)).thenReturn(null);

        // Act & Assert
        UsernameNotFoundException exception = assertThrows(
            UsernameNotFoundException.class,
            () -> clientDetailsService.loadUserByUsername(email)
        );

        assertEquals("Client non trouvé avec l'email : " + email, exception.getMessage());
        verify(clientRepository, times(1)).findByEmail(email);
    }
} 