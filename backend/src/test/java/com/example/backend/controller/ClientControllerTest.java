package com.example.backend.controller;

import com.example.backend.Enumeration.Goal;
import com.example.backend.entity.Client;
import com.example.backend.repository.ClientRepository;
import com.example.backend.service.ClientDetailsService;
import com.example.backend.service.ClientService;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.WebMvcTest;
import org.springframework.boot.test.mock.mockito.MockBean;
import org.springframework.http.MediaType;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.userdetails.User;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.test.web.servlet.MockMvc;
import com.example.backend.security.JwtUtil;
import org.springframework.security.test.context.support.WithMockUser;
import org.springframework.security.test.web.servlet.setup.SecurityMockMvcConfigurers;
import org.springframework.test.web.servlet.setup.MockMvcBuilders;
import org.springframework.web.context.WebApplicationContext;
import static org.springframework.security.test.web.servlet.request.SecurityMockMvcRequestPostProcessors.csrf;

import java.util.Arrays;
import java.util.Collections;

import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.anyString;
import static org.mockito.Mockito.when;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

@WebMvcTest(ClientController.class)
public class ClientControllerTest {

    @Autowired
    private WebApplicationContext context;

    private MockMvc mockMvc;

    @MockBean
    private ClientService clientService;

    @MockBean
    private ClientRepository clientRepository;

    @MockBean
    private PasswordEncoder passwordEncoder;

    @MockBean
    private AuthenticationManager authenticationManager;

    @MockBean
    private ClientDetailsService clientDetailsService;

    @MockBean
    private JwtUtil jwtUtil;

    private Client testClient;
    private ObjectMapper objectMapper = new ObjectMapper();

    @BeforeEach
    void setUp() {
        mockMvc = MockMvcBuilders
                .webAppContextSetup(context)
                .apply(SecurityMockMvcConfigurers.springSecurity())
                .build();

        testClient = new Client();
        testClient.setId(1L);
        testClient.setEmail("test@example.com");
        testClient.setPassword("password123");
        testClient.setGoal(Goal.WEIGHT_LOSS);
    }

    @Test
    @WithMockUser(roles = "USER")
    void registerClient_Success() throws Exception {
        when(clientRepository.findByEmail(anyString())).thenReturn(null);
        when(passwordEncoder.encode(anyString())).thenReturn("encodedPassword");
        when(clientRepository.save(any(Client.class))).thenReturn(testClient);

        mockMvc.perform(post("/api/register")
                .with(csrf())
                .contentType(MediaType.APPLICATION_JSON)
                .content(objectMapper.writeValueAsString(testClient)))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.email").value(testClient.getEmail()));
    }

    @Test
    @WithMockUser(roles = "USER")
    void registerClient_DuplicateEmail() throws Exception {
        when(clientRepository.findByEmail(anyString())).thenReturn(testClient);

        mockMvc.perform(post("/api/register")
                .with(csrf())
                .contentType(MediaType.APPLICATION_JSON)
                .content(objectMapper.writeValueAsString(testClient)))
                .andExpect(status().isBadRequest())
                .andExpect(content().string("L'email est déjà utilisé"));
    }

    @Test
    @WithMockUser(roles = "USER")
    void login_Success() throws Exception {
        Authentication auth = new UsernamePasswordAuthenticationToken(testClient.getEmail(), testClient.getPassword());
        UserDetails userDetails = User.builder()
                .username(testClient.getEmail())
                .password(testClient.getPassword())
                .roles("USER")
                .build();

        when(authenticationManager.authenticate(any())).thenReturn(auth);
        when(clientDetailsService.loadUserByUsername(anyString())).thenReturn(userDetails);
        when(jwtUtil.generateToken(anyString())).thenReturn("dummy-token");

        mockMvc.perform(post("/api/login")
                .with(csrf())
                .contentType(MediaType.APPLICATION_JSON)
                .content(objectMapper.writeValueAsString(testClient)))
                .andExpect(status().isOk())
                .andExpect(content().string("dummy-token"));
    }

    @Test
    @WithMockUser(roles = "USER")
    void getAllClients_Success() throws Exception {
        when(clientService.getAllClients()).thenReturn(Arrays.asList(testClient));

        mockMvc.perform(get("/api")
                .with(csrf()))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$[0].email").value(testClient.getEmail()));
    }

    @Test
    @WithMockUser(roles = "USER")
    void getClientsByGoal_Success() throws Exception {
        when(clientService.getClientsByGoal(any(Goal.class))).thenReturn(Collections.singletonList(testClient));

        mockMvc.perform(get("/api/goal/WEIGHT_LOSS")
                .with(csrf()))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$[0].email").value(testClient.getEmail()));
    }

    @Test
    @WithMockUser(roles = "USER")
    void updateClient_Success() throws Exception {
        when(clientService.updateClient(any(Long.class), any(Client.class))).thenReturn(testClient);

        mockMvc.perform(put("/api/1")
                .with(csrf())
                .contentType(MediaType.APPLICATION_JSON)
                .content(objectMapper.writeValueAsString(testClient)))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.email").value(testClient.getEmail()));
    }

    @Test
    @WithMockUser(roles = "USER")
    void deleteClient_Success() throws Exception {
        mockMvc.perform(delete("/api/1")
                .with(csrf()))
                .andExpect(status().isNoContent());
    }
} 