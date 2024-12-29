import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:rpstrengh/src/models/client.dart';
import '../config/env_dev.dart';
import 'package:rpstrengh/src/services/secure_storage.dart'; // Import SecureStorage



class ClientService {
  static const String baseUrl = EnvDev.apiUrl;
  String? _token;

  // Method to set the token (after login)
  void setToken(String token) {
    _token = token;
  }

  // Register a new client
  Future<Client> register(Client client) async {
    final response = await http.post(
      Uri.parse('$baseUrl/register'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'email': client.email,
        'password': client.password,
        'goal': client.goal,
        'age': client.age,
        'height': client.height,
        'weight': client.weight,
      }),
    );

    if (response.statusCode == 200) {
      return Client.fromJson(json.decode(response.body));
    }
    throw Exception(json.decode(response.body));
  }

  // Login
  Future<String> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'email': email,
        'password': password,
      }),
    );

    // Log the response body for debugging
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      // Check if the response is a valid JSON object or a plain token
      try {
        final Map<String, dynamic> data = json.decode(response.body);
        _token = data['token']; // Assuming the server returns a JSON object
      } catch (e) {
        // If decoding fails, treat the response as a plain token
        _token = response.body; // Directly assign the token
      }

      await SecureStorage.storeToken(_token!); // Store the token securely
      return _token!;
    } else {
      throw Exception('Login failed: ${response.body}');
    }
  }

  // Get all clients
  Future<List<Client>> getAllClients() async {
    final response = await http.get(
      Uri.parse(baseUrl),
      headers: {
        'Authorization': 'Bearer $_token',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((json) => Client.fromJson(json)).toList();
    }
    throw Exception('Failed to load clients');
  }

  // Update client
  Future<Client> updateClient(int id, Client client) async {
    final response = await http.put(
      Uri.parse('$baseUrl/$id'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $_token',
      },
      body: json.encode({
        'email': client.email,
        'goal': client.goal,
        'age': client.age,
        'height': client.height,
        'weight': client.weight,
      }),
    );

    if (response.statusCode == 200) {
      return Client.fromJson(json.decode(response.body));
    }
    throw Exception('Failed to update client');
  }

  // Delete client
  Future<void> deleteClient(int id) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/$id'),
      headers: {
        'Authorization': 'Bearer $_token',
      },
    );

    if (response.statusCode != 204) {
      throw Exception('Failed to delete client');
    }
  }

  // Get clients by goal
  Future<List<Client>> getClientsByGoal(String goal) async {
    final response = await http.get(
      Uri.parse('$baseUrl/goal/$goal'),
      headers: {
        'Authorization': 'Bearer $_token',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((json) => Client.fromJson(json)).toList();
    }
    throw Exception('Failed to load clients by goal');
  }

  // Get user profile
  Future<Client> getProfile() async {
    // Retrieve the token from secure storage
    _token = await SecureStorage.getToken();

    final response = await http.get(
      Uri.parse('$baseUrl/profile'), // Adjust the endpoint as necessary
      headers: {
        'Authorization': 'Bearer $_token', // Include the Bearer token
      },
    );

    if (response.statusCode == 200) {
      return Client.fromJson(json.decode(response.body));
    }
    throw Exception('Failed to load profile: ${response.body}');
  }
}
