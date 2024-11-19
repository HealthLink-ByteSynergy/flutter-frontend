import 'dart:convert';
import 'package:healthlink/APIs.dart';
import 'package:healthlink/models/Doctor.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const String loginURL = '${API.baseURL}/user/login';
  static const String signupURL = '${API.baseURL}/user/signup';
  static const String logoutURL = '${API.baseURL}/user/logout';

  Future<void> storeToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<void> removeToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
  }

  Future<void> storeUserId(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userId', userId);
  }

  Future<String?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('userId');
  }

  Future<void> removeUserId() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('userId');
  }

  Future<Map<String, dynamic>> login(String email, String password) async {
    print('hello');
    try {
      final response = await http.post(
        Uri.parse(loginURL),
        body: jsonEncode({'email': email, 'password': password}),
        headers: {'Content-Type': 'application/json'},
      );
      print(response.body);
      print(response.statusCode);
      if (response.statusCode == 200) {
        // final Map<String, dynamic> responseData = json.decode(response.body);
        // final token = responseData['token'];

        final token = response.body;

        await storeToken(token);

        print(response.body);

        return {'success': true, 'token': token};
      } else {
        return {'success': false, 'message': 'Login failed'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Exception: $e'};
    }
  }

  Future<Map<String, dynamic>> signUpUser(
      String name, String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse(signupURL),
        body: jsonEncode(
            {"username": name, "email": email, "password": password}),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        // final Map<String, dynamic> responseData = json.decode(response.body);
        // final token = responseData['token'];
        // print(token);
        final token = response.body;

        await storeToken(token);

        return {'success': true, 'token': token};
      } else {
        return {'success': false, 'message': 'Sign up failed'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Exception: $e'};
    }
  }

  Future<Map<String, dynamic>> signUpDoctor(Doctor doctor) async {
    try {
      final response = await http.post(
        Uri.parse('http://10.0.2.2:5000/api/v1/user/doctorsignup'),
        body: jsonEncode({
          "userEntity": {
            "id": '',
            "username": doctor.username,
            "email": doctor.email,
            "password": doctor.password
          },
          "doctorEntity": {
            "specialization": doctor.specializations,
            "licenseNumber": doctor.licenseNumber,
            "phoneNumber": doctor.phoneNumber,
          }
        }),
        headers: {'Content-Type': 'application/json'},
      );

      // print('doctor signup response');
      // print(response.body);

      if (response.statusCode == 200) {
        // final Map<String, dynamic> responseData = json.decode(response.body);
        // print(token);
        final token = response.body;

        // print('token from doctor signup');
        // print(token);
        await storeToken(token);

        return {'success': true, 'token': token};
      } else {
        return {'success': false, 'message': 'Sign up failed'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Exception: $e'};
    }
  }

  Future<Map<String, dynamic>> logout() async {
    try {
      String? token = await getToken();
      final response = await http.get(
        Uri.parse(logoutURL),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      // print(response.body);
      if (response.statusCode == 200) {
        await removeToken();
        return {'success': true};
      } else {
        return {'success': false, 'message': 'Logout failed'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Exception: $e'};
    }
  }
}
