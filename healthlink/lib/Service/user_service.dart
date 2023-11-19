import 'dart:convert';
import 'package:healthlink/Service/auth_service.dart';
import 'package:http/http.dart' as http;

class UserService {
  String userURL = 'http://10.0.2.2:5000/api/v1/user/getUserDetails';

  Future<Map<String, dynamic>?> getUserDetails() async {
    try {
      final String? token = await AuthService().getToken();
      // print(token); // Fetch the authentication token
      if (token == null) {
        // Handle case where token is null, could indicate a login issue or token expiration
        return null;
      }

      final response = await http.post(Uri.parse(userURL),
          headers: {
            'Content-Type': 'text/plain',
            'Authorization': 'Bearer $token',
          },
          body: token);

      if (response.statusCode == 200) {
        final Map<String, dynamic> userData = json.decode(response.body);
        // final String username = userData['username'];

        await AuthService().storeUserId(userData['id']);
        // print(username);
        return userData;
      } else {
        // print('in else');
        // print(response.statusCode);
        // print(response.body);
        // Handle error cases or return a default value
        return null;
      }
    } catch (e) {
      // print('error');
      // print(e);
      // Handle exceptions or return a default value
      return null;
    }
  }
}
