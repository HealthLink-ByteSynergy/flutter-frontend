import 'dart:convert';
import 'package:healthlink/APIs.dart';
import 'package:healthlink/Service/auth_service.dart';
import 'package:healthlink/models/Patient.dart';
import 'package:healthlink/models/patient_details.dart';
import 'package:http/http.dart' as http;

class PatientService {
  String patientURL = API.baseURL + API.patientEndpoint;
  String deletePatientUrl = API.baseURL + API.patientEndpoint + "/delete";

  Future<Map<String, dynamic>> updatePatient(Patient patient) async {
    Map<String, dynamic> result = {};
    try {
      final String? jwtToken = await AuthService().getToken();
      final response = await http.put(
        Uri.parse('$patientURL/update/${patient.patientId}'),
        headers: {
          'Authorization': 'Bearer $jwtToken',
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(patient.toJson()),
      );

      if (response.statusCode == 200) {
        result['success'] = true;
        result['data'] = jsonDecode(response.body);
      } else {
        result['success'] = false;
        result['error'] = 'Failed to update patient: ${response.reasonPhrase}';
      }
    } catch (error) {
      result['success'] = false;
      result['error'] = 'Error occurred: $error';
    }
    return result;
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
        body: jsonEncode(patient.toJson()),
      );

      if (response.statusCode == 200) {
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

  Future<Patient?> getPatientById(String patientId) async {
    try {
      final String? jwtToken = await AuthService().getToken();
      final response = await http.get(
        Uri.parse(
            '${API.baseURL}${API.patientEndpoint}/id/$patientId'), // Assuming the endpoint structure
        headers: {
          'Authorization': 'Bearer $jwtToken',
          'Content-Type': 'application/json',
          // Add other necessary headers here if required by your API
        },
      );

      if (response.statusCode == 200) {
        final dynamic jsonResponse = json.decode(response.body);
        final Patient patient = Patient.fromJson(jsonResponse);
        return patient;
      } else {
        throw Exception('Failed to fetch patient');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<List<Patient>> getPatientByUserId(String userId) async {
    try {
      final String? jwtToken = await AuthService().getToken();
      final response = await http.get(
        Uri.parse('${API.baseURL}${API.patientEndpoint}/getByUserId/$userId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $jwtToken',
        },
      );

      // print(response.body);
      if (response.statusCode == 200) {
        final List<dynamic> jsonResponse = json.decode(response.body);
        List<Patient> patients =
            jsonResponse.map((json) => Patient.fromJson(json)).toList();
        return patients;
      } else {
        print('why');
        throw Exception('Failed to fetch patients');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<Map<String, dynamic>> deletePatient(String id) async {
    try {
      final String? jwtToken = await AuthService().getToken();
      final response = await http.delete(
        Uri.parse('$deletePatientUrl/$id'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $jwtToken',
        },
      );

      if (response.statusCode == 200) {
        // If the delete operation was successful
        print('Patient with ID: $id deleted successfully');
        return {
          'success': true,
          'message': 'Patient with ID $id deleted successfully'
        };
      } else {
        // If there was an issue with the delete operation
        print(
            'Failed to delete patient with ID: $id. Status code: ${response.statusCode}');
        return {
          'success': false,
          'message': 'Failed to delete patient with ID: $id'
        };
      }
    } catch (e) {
      // Handle any exceptions that might occur during the API call
      print('Exception during delete operation: $e');
      return {
        'success': false,
        'message': 'Exception occurred during delete operation'
      };
    }
  }
}
