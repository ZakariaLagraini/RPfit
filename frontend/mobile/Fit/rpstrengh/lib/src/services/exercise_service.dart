import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:rpstrengh/src/models/exercise.dart';
import 'package:rpstrengh/src/services/secure_storage.dart';
import 'package:rpstrengh/src/config/env_dev.dart';

class ExerciseService {
  static const String baseUrl = '${EnvDev.apiUrl}/exercises';

  // Get all exercises
  Future<List<Exercise>> getAllExercises() async {
    final token = await SecureStorage.getToken();
    if (token == null) throw Exception('No authentication token found');

    final response = await http.get(
      Uri.parse('$baseUrl/all'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((json) => Exercise.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load exercises: ${response.body}');
    }
  }

  // Get exercises by workout plan
  Future<List<Exercise>> getExercisesByWorkoutPlan(int workoutPlanId) async {
    final token = await SecureStorage.getToken();
    if (token == null) throw Exception('No authentication token found');

    final response = await http.get(
      Uri.parse('$baseUrl/workoutPlan/$workoutPlanId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((json) => Exercise.fromJson(json)).toList();
    } else {
      throw Exception(
          'Failed to load exercises for workout plan: ${response.body}');
    }
  }

  // Get single exercise by ID
  Future<Exercise> getExerciseById(int id) async {
    final token = await SecureStorage.getToken();
    if (token == null) throw Exception('No authentication token found');

    final response = await http.get(
      Uri.parse('$baseUrl/$id'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return Exercise.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load exercise: ${response.body}');
    }
  }

  // Create new exercise
  Future<Exercise> createExercise(Exercise exercise) async {
    final token = await SecureStorage.getToken();
    if (token == null) throw Exception('No authentication token found');

    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode(exercise.toJson()),
    );

    if (response.statusCode == 201) {
      return Exercise.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to create exercise: ${response.body}');
    }
  }

  // Update exercise
  Future<Exercise> updateExercise(int id, Exercise exercise) async {
    final token = await SecureStorage.getToken();
    if (token == null) throw Exception('No authentication token found');

    final response = await http.put(
      Uri.parse('$baseUrl/$id'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode(exercise.toJson()),
    );

    if (response.statusCode == 200) {
      return Exercise.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to update exercise: ${response.body}');
    }
  }

  // Delete exercise
  Future<void> deleteExercise(int id) async {
    final token = await SecureStorage.getToken();
    if (token == null) throw Exception('No authentication token found');

    final response = await http.delete(
      Uri.parse('$baseUrl/$id'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode != 204) {
      throw Exception('Failed to delete exercise: ${response.body}');
    }
  }
}
