import 'dart:convert'; // Import for JSON encoding
import 'package:shared_preferences/shared_preferences.dart';

class SecureStorage {
  static const _tokenKey = 'jwt_token';
  static final _prefs = SharedPreferences.getInstance();

  // Store token as JSON
  static Future<void> storeToken(String token) async {
    final prefs = await _prefs;
    final tokenJson = json.encode({'token': token}); // Wrap token in JSON
    await prefs.setString(_tokenKey, tokenJson);
  }

  // Retrieve token from JSON
  static Future<String?> getToken() async {
    final prefs = await _prefs;
    final tokenJson = prefs.getString(_tokenKey);
    if (tokenJson != null) {
      final Map<String, dynamic> decoded = json.decode(tokenJson);
      return decoded['token']; // Extract token from JSON
    }
    return null;
  }

  static Future<void> deleteToken() async {
    final prefs = await _prefs;
    await prefs.remove(_tokenKey);
  }
}
