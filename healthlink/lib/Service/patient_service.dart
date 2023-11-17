import 'dart:convert';
import 'package:healthlink/Service/auth_service.dart';
import 'package:healthlink/models/Patient.dart';
import 'package:healthlink/models/patient_details.dart';
import 'package:http/http.dart' as http;

class PatientService {
  String patientURL = 'http://10.0.2.2:5000/api/v1/patient';

  Future<void> updatePatient(Patient patient) async {
    // Implement logic to handle /api/v1/patient/update
    // Use the 'patient' object as input
  }

  Future<Map<String, dynamic>> savePatient(CustomForm form) async {
    Map<String, dynamic> result = {};
    try {
      Patient patient = Patient();
      patient.form = form;
      patient.userId = await AuthService().getUserId();
      final String? jwtToken = await AuthService().getToken();
      final response = await http.post(
        Uri.parse('$patientURL/save'),
        headers: <String, String>{
          'Authorization': 'Bearer $jwtToken',
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(
            patient.toJson()), // Assuming 'toJson()' method in Patient class
      );

      if (response.statusCode == 200) {
        // Successful response, store result in a map
        result['success'] = true;
        result['data'] = jsonDecode(response.body);
      } else {
        // Request failed, store error message in the result map
        result['success'] = false;
        result['error'] = 'Failed to save patient: ${response.reasonPhrase}';
      }
    } catch (error) {
      // Handle other errors like network issues
      result['success'] = false;
      result['error'] = 'Error occurred: $error';
    }

    return result;
  }

  Future<Patient> getPatientById(String id) async {
    return Patient();
    // Implement logic to handle /api/v1/patient/id
    // Use the 'id' string as input and return a 'Patient' object
  }

  Future<Patient> getPatientByUserId(String userId) async {
    // Implement logic to handle /api/v1/patient/getByUserId
    // Use the 'userId' string as input and return a 'Patient' object
    return Patient();
  }

  Future<void> deletePatient(String id) async {
    // Implement logic to handle /api/v1/patient/delete
    // Use the 'id' string as input
  }
}
