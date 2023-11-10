import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthMethods {
  static const String baseUrl =
      'https://your-api-base-url.com'; // Replace with your API base URL

  Future<String> signUp({
    required String email,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/signup'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final String token = data[
            'token']; // Assuming your API returns a 'token' field for successful signup

        return token;
      } else {
        throw Exception('Failed to register user');
      }
    } catch (error) {
      throw Exception('Failed to register user: $error');
    }
  }

  Future<String> loginUser({
    required String email,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final String token = data[
            'token']; // Assuming your API returns a 'token' field for successful login
        await AuthMethods.storeToken(token);
        return token;
      } else {
        throw Exception('Failed to log in');
      }
    } catch (error) {
      throw Exception('Failed to log in: $error');
    }
  }

  static Future<void> signOut() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('jwtToken'); // Remove the JWT token from shared preferences
  }

  Future<void> resetPassword({
    required String email,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/reset-password'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email}),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to reset password');
      }
    } catch (error) {
      throw Exception('Failed to reset password: $error');
    }
  }

  Future<bool> isLoggedIn() async {
    // Fetch the token from local storage
    String? token = await AuthMethods.fetchToken();

    // Check if the token is not null or empty
    return token != null && token.isNotEmpty;
  }

  static Future<String?> fetchToken() async {
    // Fetch the token from local storage
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('jwt_token');
    return token;
  }

  static Future<void> storeToken(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('jwtToken', token);
  }
}
