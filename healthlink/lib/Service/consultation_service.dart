import 'dart:convert';
import 'package:healthlink/APIs.dart';
import 'package:healthlink/Service/auth_service.dart';
import 'package:healthlink/models/ConsultationChat.dart';
import 'package:healthlink/models/Patient.dart';
import 'package:http/http.dart' as http;

class ConsultationChatService {
  String ConsultationChatURL = API.baseURL + API.consultationChatEndpoint;
  String deleteConsultationChatURL =
      API.baseURL + API.consultationChatEndpoint + '/deleteTempChat';

  Future<Map<String, dynamic>> saveConsultationChat(
      String doctorPatientId, String patientId) async {
    Map<String, dynamic> result = {};
    try {
      final String? jwtToken = await AuthService().getToken();
      final response = await http.post(
        Uri.parse('$ConsultationChatURL/addTempChat'),
        headers: <String, String>{
          'Authorization': 'Bearer $jwtToken',
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          "patientEntity": {"patientId": patientId},
          "docPatientEntity": {"patientId": doctorPatientId}
        }),
      );

      if (response.statusCode == 200) {
        result['success'] = true;
        result['data'] = jsonDecode(response.body);
      } else {
        // Request failed, store error message in the result map
        result['success'] = false;
        result['error'] =
            'Failed to save ConsultationChat: ${response.reasonPhrase}';
      }
    } catch (error) {
      // Handle other errors like network issues
      result['success'] = false;
      result['error'] = 'Error occurred: $error';
    }

    return result;
  }

  Future<List<ConsultationChat>> getConsultationChatByDoctorIdAndPatientId(
      String doctorId, String patientId) async {
    try {
      final String? jwtToken = await AuthService().getToken();
      final response =
          await http.post(Uri.parse('${ConsultationChatURL}/getTempChat'),
              headers: {
                'Content-Type': 'application/json',
                'Authorization': 'Bearer $jwtToken',
              },
              body: jsonEncode({
                "patientEntity": {"patientId": patientId},
                "docPatientEntity": {"patientId": doctorId}
              }));

      if (response.statusCode == 200) {
        final List<dynamic> jsonResponse = json.decode(response.body);
        List<ConsultationChat> consultationChats = jsonResponse
            .map((json) => ConsultationChat.fromJson(json))
            .toList();
        return consultationChats;
      } else {
        print('why');
        return [];
        // throw Exception('Failed to fetch ConsultationChats');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<List<ConsultationChat>> getConsultationChatByDoctorId(
      String doctorPatientId) async {
    try {
      final String? jwtToken = await AuthService().getToken();
      final response = await http.get(
        Uri.parse('${ConsultationChatURL}/docpatientid/$doctorPatientId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $jwtToken',
        },
      );

      // print(response.body);
      if (response.statusCode == 200) {
        final List<dynamic> jsonResponse = json.decode(response.body);
        List<ConsultationChat> consultationChats = jsonResponse
            .map((json) => ConsultationChat.fromJson(json))
            .toList();
        return consultationChats;
      } else {
        // print('why');
        throw Exception('Failed to fetch ConsultationChats');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<List<ConsultationChat>> getConsultationChatByPatientId(
      String patientId) async {
    try {
      final String? jwtToken = await AuthService().getToken();
      final response = await http.get(
        Uri.parse('${ConsultationChatURL}/patientid/$patientId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $jwtToken',
        },
      );

      // print(response.body);
      if (response.statusCode == 200) {
        final List<dynamic> jsonResponse = json.decode(response.body);
        List<ConsultationChat> consultationChats = jsonResponse
            .map((json) => ConsultationChat.fromJson(json))
            .toList();
        return consultationChats;
      } else {
        // print('why');
        throw Exception('Failed to fetch ConsultationChats');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<Map<String, dynamic>> deleteConsultationChat(
      String patientId, String doctorPatientId) async {
    try {
      final String? jwtToken = await AuthService().getToken();
      final response = await http.delete(
          Uri.parse(
              '$deleteConsultationChatURL'), // Replace with your appropriate URL
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $jwtToken',
          },
          body: jsonEncode({
            "patientEntity": {"patientId": patientId},
            "docPatientEntity": {"patientId": doctorPatientId}
          }));

      if (response.statusCode == 200) {
        // If the delete operation was successful
        print(
            'Consultation chat with doctorId: $doctorPatientId and patientId: $patientId deleted successfully');
        return {
          'success': true,
          'message':
              'Consultation chat with doctorId: $doctorPatientId and patientId: $patientId deleted successfully'
        };
      } else {
        // If there was an issue with the delete operation
        print(
            'Failed to delete consultation chat with doctorId: $doctorPatientId and patientId: $patientId. Status code: ${response.statusCode}');
        return {
          'success': false,
          'message':
              'Failed to delete consultation chat with  doctorId: $doctorPatientId and patientId: $patientId'
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
