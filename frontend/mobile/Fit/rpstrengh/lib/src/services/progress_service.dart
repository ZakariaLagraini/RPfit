import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:rpstrengh/src/models/progress.dart';
import 'package:rpstrengh/src/models/exercise.dart';
import '../config/env_dev.dart';
import 'package:rpstrengh/src/services/secure_storage.dart';

class ProgressService {
  static const String baseUrl = '${EnvDev.apiUrl}/progress';
  String? _token;

  Future<List<Progress>> getClientProgress() async {
    final token = await SecureStorage.getToken();
    if (token == null) {
      throw Exception('No authentication token found');
    }

    try {
      final response = await http.get(
        Uri.parse('${EnvDev.apiUrl}/progress/client'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        List<dynamic> jsonList = json.decode(response.body);
        return jsonList.map((json) => Progress.fromJson(json)).toList();
      } else if (response.statusCode == 403) {
        throw Exception('Authentication failed: Please login again');
      } else {
        throw Exception('Failed to load progress data: ${response.body}');
      }
    } catch (e) {
      print('Error fetching progress: $e');
      throw Exception('Failed to load progress data: $e');
    }
  }

  Future<Progress> createProgress(Progress progress) async {
    final token = await SecureStorage.getToken();
    if (token == null) {
      throw Exception('No authentication token found');
    }

    try {
      final response = await http.post(
        Uri.parse('${EnvDev.apiUrl}/progress'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode(progress.toJson()),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return Progress.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to create progress: ${response.body}');
      }
    } catch (e) {
      print('Error creating progress: $e');
      throw Exception('Failed to create progress: $e');
    }
  }

  Future<Progress> updateProgress(int id, Progress progress) async {
    _token = await SecureStorage.getToken();

    final response = await http.put(
      Uri.parse('$baseUrl/$id'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $_token',
      },
      body: json.encode({
        'exercise_id': progress.exercise.id,
        'date': progress.date.toIso8601String(),
        'repetitions': progress.repetitions,
        'weight': progress.weight,
        'sets': progress.sets,
        'duration': progress.duration,
        'notes': progress.notes,
      }),
    );

    if (response.statusCode == 200) {
      return _parseProgress(json.decode(response.body));
    }
    throw Exception('Failed to update progress');
  }

  Future<void> deleteProgress(int id) async {
    _token = await SecureStorage.getToken();

    final response = await http.delete(
      Uri.parse('$baseUrl/$id'),
      headers: {
        'Authorization': 'Bearer $_token',
      },
    );

    if (response.statusCode != 204) {
      throw Exception('Failed to delete progress');
    }
  }

  Future<List<Progress>> getProgressByExercise(int exerciseId) async {
    _token = await SecureStorage.getToken();

    final response = await http.get(
      Uri.parse('$baseUrl/exercise/$exerciseId'),
      headers: {
        'Authorization': 'Bearer $_token',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((json) => _parseProgress(json)).toList();
    }
    throw Exception('Failed to load exercise progress');
  }

  // Helper method to parse Progress from JSON
  Progress _parseProgress(Map<String, dynamic> json) {
    return Progress(
      id: json['id'],
      exercise: Exercise.fromJson(json['exercise']),
      date: DateTime.parse(json['date']),
      repetitions: json['repetitions'],
      weight: json['weight'].toDouble(),
      sets: json['sets'],
      duration: json['duration']?.toDouble() ?? 0.0,
      notes: json['notes'] ?? '',
    );
  }
}
