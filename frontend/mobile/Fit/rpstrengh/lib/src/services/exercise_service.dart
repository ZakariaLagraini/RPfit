import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:rpstrengh/src/models/exercise.dart';
import 'package:rpstrengh/src/services/secure_storage.dart';
import 'package:rpstrengh/src/config/env_dev.dart';

class ExerciseService {
  static const String baseUrl = '${EnvDev.apiUrl}/exercises';

  Future<List<Exercise>> getExercisesByWorkoutPlan(int workoutPlanId) async {
    final token = await SecureStorage.getToken();

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
      throw Exception('Failed to load exercises');
    }
  }

  Future<List<Exercise>> getAllExercises() async {
    final token = await SecureStorage.getToken();

    final response = await http.get(
      Uri.parse('$baseUrl/all'), // Changed to get all exercises
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((json) => Exercise.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load exercises');
    }
  }
}
