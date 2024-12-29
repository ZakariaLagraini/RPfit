package com.example.backend.service;

import com.example.backend.entity.Client;
import com.example.backend.repository.ClientRepository;
import com.example.backend.Enumeration.Gender;
import com.example.backend.Enumeration.Goal;
import com.example.backend.Enumeration.ActivityLevel;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.security.crypto.password.PasswordEncoder;

import java.util.Arrays;
import java.util.List;
import java.util.Optional;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.anyString;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class ClientServiceTest {

    @Mock
    private ClientRepository clientRepository;

    @Mock
    private PasswordEncoder passwordEncoder;

    @InjectMocks
    private ClientService clientService;

    private Client testClient;

    @BeforeEach
    void setUp() {
        testClient = new Client();
        testClient.setId(1L);
        testClient.setEmail("test@example.com");
        testClient.setPassword("password123");
        testClient.setWeight(70.0);
        testClient.setHeight(175.0);
        testClient.setAge(25.0);
        testClient.setGender(Gender.MALE);
        testClient.setGoal(Goal.GAIN_WEIGHT);
        testClient.setActivityLevel(ActivityLevel.MODERATELY_ACTIVE);
    }

    @Test
    void createClient_ShouldReturnSavedClient() {
        // Given
        String rawPassword = "password123";
        String encodedPassword = "encodedPassword";
        testClient.setPassword(rawPassword);
        
        when(passwordEncoder.encode(rawPassword)).thenReturn(encodedPassword);
        when(clientRepository.save(any(Client.class))).thenAnswer(invocation -> {
            Client savedClient = invocation.getArgument(0);
            assertThat(savedClient.getPassword()).isEqualTo(encodedPassword);
            return testClient;
        });

        // When
        Client savedClient = clientService.saveClient(testClient);

        // Then
        assertThat(savedClient).isNotNull();
        assertThat(savedClient.getId()).isEqualTo(testClient.getId());
        assertThat(savedClient.getEmail()).isEqualTo(testClient.getEmail());
        verify(passwordEncoder).encode(rawPassword);
        verify(clientRepository).save(any(Client.class));
    }

    @Test
    void updateClient_ShouldReturnUpdatedClient() {
        // Given
        Client updatedClient = new Client();
        updatedClient.setWeight(75.0);
        updatedClient.setHeight(180.0);
        updatedClient.setGoal(Goal.WEIGHT_LOSS);

        when(clientRepository.findById(anyLong())).thenReturn(Optional.of(testClient));
        when(clientRepository.save(any(Client.class))).thenReturn(updatedClient);

        // When
        Client result = clientService.updateClient(1L, updatedClient);

        // Then
        assertThat(result).isNotNull();
        assertThat(result.getWeight()).isEqualTo(updatedClient.getWeight());
        assertThat(result.getHeight()).isEqualTo(updatedClient.getHeight());
        assertThat(result.getGoal()).isEqualTo(updatedClient.getGoal());
        verify(clientRepository).findById(1L);
        verify(clientRepository).save(any(Client.class));
    }

    @Test
    void getClientById_ShouldReturnClient() {
        // Given
        when(clientRepository.findById(anyLong())).thenReturn(Optional.of(testClient));

        // When
        Optional<Client> result = clientService.getClientById(1L);

        // Then
        assertThat(result).isPresent();
        assertThat(result.get().getId()).isEqualTo(testClient.getId());
        assertThat(result.get().getEmail()).isEqualTo(testClient.getEmail());
        verify(clientRepository).findById(1L);
    }

    @Test
    void getAllClients_ShouldReturnListOfClients() {
        // Given
        List<Client> clients = Arrays.asList(testClient);
        when(clientRepository.findAll()).thenReturn(clients);

        // When
        List<Client> result = clientService.getAllClients();

        // Then
        assertThat(result).isNotEmpty();
        assertThat(result).hasSize(1);
        assertThat(result.get(0).getId()).isEqualTo(testClient.getId());
        verify(clientRepository).findAll();
    }

    @Test
    void deleteClient_ShouldCallRepository() {
        // Given
        doNothing().when(clientRepository).deleteById(anyLong());

        // When
        clientService.deleteClient(1L);

        // Then
        verify(clientRepository).deleteById(1L);
    }
}