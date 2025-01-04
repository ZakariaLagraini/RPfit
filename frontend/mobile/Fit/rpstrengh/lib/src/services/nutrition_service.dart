import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/nutrition.dart';
import './secure_storage.dart';
import '../config/env_dev.dart';

class NutritionService {
  static const String baseUrl = '${EnvDev.apiUrl}/nutrition';

  Future<List<Nutrition>> getNutrition(int clientId) async {
    final token = await SecureStorage.getToken();

    final response = await http.get(
      Uri.parse('$baseUrl/$clientId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((json) => Nutrition.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load nutrition data: ${response.statusCode}');
    }
  }
}
