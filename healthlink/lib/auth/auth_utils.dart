import 'package:shared_preferences/shared_preferences.dart';

class AuthUtils {
  // Function to store JWT token in local storage (SharedPreferences)
  static Future<void> storeTokenInLocalStorage(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('jwt_token', token);
  }

  // Function to fetch JWT token from local storage (SharedPreferences)
  static Future<String?> fetchTokenFromLocalStorage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('jwt_token');
  }

  // Function to clear JWT token from local storage (SharedPreferences)
  static Future<void> clearTokenFromLocalStorage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('jwt_token');
  }
}
