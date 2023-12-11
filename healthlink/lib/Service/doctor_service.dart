import 'dart:convert';
import 'package:healthlink/APIs.dart';
import 'package:healthlink/Service/auth_service.dart';
import 'package:healthlink/models/Doctor.dart';
import 'package:http/http.dart' as http;

class DoctorService {
  String doctorURL = API.baseURL + API.doctorEndpoint;

  Future<Doctor?> getDoctorByUserId() async {
    try {
      // AuthService().removeToken();
      // String jwtToken = '';
      final String? jwtToken = await AuthService().getToken();
      final String? userId = await AuthService().getUserId();
      final response = await http.get(
        Uri.parse(
            '$doctorURL/userid/$userId'), // Assuming the endpoint structure
        headers: {
          'Authorization': 'Bearer $jwtToken',
          'Content-Type': 'application/json',
        },
      );

      // print(response.body);
      if (response.statusCode == 200) {
        final dynamic jsonResponse = json.decode(response.body);
        print(jsonResponse);
        final Doctor doctor = Doctor.fromJson(jsonResponse);
        // print(doctor.username);
        return doctor;
      } else {
        throw Exception('Failed to fetch doctor');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<Doctor?> getDoctorById(String doctorId) async {
    try {
      final String? jwtToken = await AuthService().getToken();
      final response = await http.get(
        Uri.parse(
            '${API.baseURL}${API.doctorEndpoint}/doctorid/$doctorId'), // Assuming the endpoint structure
        headers: {
          'Authorization': 'Bearer $jwtToken',
          'Content-Type': 'application/json',
          // Add other necessary headers here if required by your API
        },
      );

      if (response.statusCode == 200) {
        final dynamic jsonResponse = json.decode(response.body);
        final Doctor doctor = Doctor.fromJson(jsonResponse);
        return doctor;
      } else {
        throw Exception('Failed to fetch doctor');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}
