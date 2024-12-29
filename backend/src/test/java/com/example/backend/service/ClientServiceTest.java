package com.example.backend.service;

import com.example.backend.Enumeration.Goal;
import com.example.backend.entity.Client;
import com.example.backend.repository.ClientRepository;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.MockitoAnnotations;

import java.util.Arrays;
import java.util.List;
import java.util.Optional;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.Mockito.*;

class ClientServiceTest {

    @Mock
    private ClientRepository clientRepository;

    @InjectMocks
    private ClientService clientService;

    private Client testClient;

    @BeforeEach
    void setUp() {
        MockitoAnnotations.openMocks(this);
        testClient = new Client();
        testClient.setId(1L);
        testClient.setEmail("test@example.com");
        testClient.setPassword("password123");
        testClient.setHeight(180);
        testClient.setWeight(75.0);
        testClient.setAge(25);
        testClient.setGoal(Goal.WEIGHT_LOSS);
    }

    @Test
    void saveClient_Success() {
        when(clientRepository.save(any(Client.class))).thenReturn(testClient);

        Client savedClient = clientService.saveClient(testClient);

        assertNotNull(savedClient);
        assertEquals(testClient.getEmail(), savedClient.getEmail());
        verify(clientRepository, times(1)).save(any(Client.class));
    }

    @Test
    void getClientById_WhenExists() {
        when(clientRepository.findById(1L)).thenReturn(Optional.of(testClient));

        Optional<Client> found = clientService.getClientById(1L);

        assertTrue(found.isPresent());
        assertEquals(testClient.getEmail(), found.get().getEmail());
        verify(clientRepository, times(1)).findById(1L);
    }

    @Test
    void getClientById_WhenNotExists() {
        when(clientRepository.findById(999L)).thenReturn(Optional.empty());

        Optional<Client> found = clientService.getClientById(999L);

        assertFalse(found.isPresent());
        verify(clientRepository, times(1)).findById(999L);
    }

    @Test
    void getAllClients_Success() {
        List<Client> clients = Arrays.asList(testClient, new Client());
        when(clientRepository.findAll()).thenReturn(clients);

        List<Client> foundClients = clientService.getAllClients();

        assertEquals(2, foundClients.size());
        verify(clientRepository, times(1)).findAll();
    }

    @Test
    void updateClient_WhenExists() {
        Client updatedClient = new Client();
        updatedClient.setEmail("updated@example.com");
        updatedClient.setWeight(80.0);

        when(clientRepository.findById(1L)).thenReturn(Optional.of(testClient));
        when(clientRepository.save(any(Client.class))).thenReturn(updatedClient);

        Client result = clientService.updateClient(1L, updatedClient);

        assertNotNull(result);
        assertEquals(updatedClient.getEmail(), result.getEmail());
        verify(clientRepository, times(1)).findById(1L);
        verify(clientRepository, times(1)).save(any(Client.class));
    }

    @Test
    void updateClient_WhenNotExists() {
        Client updatedClient = new Client();
        when(clientRepository.findById(999L)).thenReturn(Optional.empty());

        assertThrows(RuntimeException.class, () -> 
            clientService.updateClient(999L, updatedClient)
        );
        verify(clientRepository, times(1)).findById(999L);
        verify(clientRepository, never()).save(any(Client.class));
    }

    @Test
    void deleteClient_Success() {
        doNothing().when(clientRepository).deleteById(1L);

        clientService.deleteClient(1L);

        verify(clientRepository, times(1)).deleteById(1L);
    }

    @Test
    void getClientsByGoal_Success() {
        List<Client> clients = Arrays.asList(testClient);
        when(clientRepository.findByGoal(Goal.WEIGHT_LOSS)).thenReturn(clients);

        List<Client> foundClients = clientService.getClientsByGoal(Goal.WEIGHT_LOSS);

        assertEquals(1, foundClients.size());
        assertEquals(Goal.WEIGHT_LOSS, foundClients.get(0).getGoal());
        verify(clientRepository, times(1)).findByGoal(Goal.WEIGHT_LOSS);
    }

    @Test
    void getClientByEmail_WhenExists() {
        when(clientRepository.findByEmail("test@example.com")).thenReturn(testClient);

        Client found = clientService.getClientByEmail("test@example.com");

        assertNotNull(found);
        assertEquals("test@example.com", found.getEmail());
        verify(clientRepository, times(1)).findByEmail("test@example.com");
    }
} 