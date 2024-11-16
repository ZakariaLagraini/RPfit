package com.example.backend.service;

import com.example.backend.Enumeration.Goal;
import com.example.backend.entity.Client;
import com.example.backend.repository.ClientRepository;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public class ClientService {
    private final ClientRepository clientRepository;

    public ClientService(ClientRepository clientRepository) {
        this.clientRepository = clientRepository;
    }

    public Client saveClient(Client client) {
        return clientRepository.save(client);
    }

    public Optional<Client> getClientById(Long id) {
        return clientRepository.findById(id);
    }

    public List<Client> getAllClients() {
        return clientRepository.findAll();
    }

    public Client updateClient(Long id, Client updatedClient) {
        return clientRepository.findById(id)
                .map(client -> {
                    client.setHeight(updatedClient.getHeight());
                    client.setWeight(updatedClient.getWeight());
                    client.setAge(updatedClient.getAge());
                    client.setEmail(updatedClient.getEmail());
                    client.setPassword(updatedClient.getPassword());
                    client.setGoal(updatedClient.getGoal());
                    return clientRepository.save(client);
                }).orElseThrow(() -> new RuntimeException("Client not found"));
    }

    public void deleteClient(Long id) {
        clientRepository.deleteById(id);
    }

    public List<Client> getClientsByGoal(Goal goal) {
        return clientRepository.findByGoal(goal);
    }
}