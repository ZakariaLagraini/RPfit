import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:rpstrengh/src/models/workout_plan.dart';
import 'package:rpstrengh/src/services/secure_storage.dart';
import 'package:rpstrengh/src/config/env_dev.dart';

class WorkoutPlanService {
  static const String baseUrl = '${EnvDev.apiUrl}/workoutPlans';

  Future<List<WorkoutPlan>> getWorkoutPlansByClientId(int clientId) async {
    try {
      final token = await SecureStorage.getToken();
      if (token == null) {
        throw Exception('No authentication token found');
      }

      final response = await http.get(
        Uri.parse('$baseUrl/client/$clientId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        List<dynamic> jsonList = json.decode(response.body);
        return jsonList.map((json) => WorkoutPlan.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load workout plans: ${response.statusCode}');
      }
    } catch (e) {
      print('Error in getWorkoutPlansByClientId: $e');
      rethrow;
    }
  }

  Future<List<WorkoutPlan>> getWorkoutPlansByExercises(
      List<String> exercises) async {
    try {
      final token = await SecureStorage.getToken();
      if (token == null) {
        throw Exception('No authentication token found');
      }

      final queryParams = exercises.map((e) => 'exercises=$e').join('&');
      final response = await http.get(
        Uri.parse('$baseUrl/exercises/filter?$queryParams'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        List<dynamic> jsonList = json.decode(response.body);
        return jsonList.map((json) => WorkoutPlan.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load workout plans: ${response.statusCode}');
      }
    } catch (e) {
      print('Error in getWorkoutPlansByExercises: $e');
      rethrow;
    }
  }
}
