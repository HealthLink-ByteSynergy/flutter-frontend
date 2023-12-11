import 'dart:convert';
import 'package:healthlink/APIs.dart';
import 'package:healthlink/Service/auth_service.dart';
import 'package:healthlink/models/ConsultationChat.dart';
import 'package:healthlink/models/Patient.dart';
import 'package:http/http.dart' as http;

class ConsultationChatService {
  String ConsultationChatURL = API.consultationChatEndpoint;

  Future<Map<String, dynamic>> saveConsultationChat(
      ConsultationChat consultationChat) async {
    Map<String, dynamic> result = {};
    try {
      final String? jwtToken = await AuthService().getToken();
      final response = await http.post(
        Uri.parse('$ConsultationChatURL/addtempchat'),
        headers: <String, String>{
          'Authorization': 'Bearer $jwtToken',
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(consultationChat.toJson()),
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

  Future<List<ConsultationChat>> getConsultationChatByDoctorId(
      String doctorId) async {
    try {
      final String? jwtToken = await AuthService().getToken();
      final response = await http.get(
        Uri.parse('${ConsultationChatURL}/id/$doctorId'),
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
        print('why');
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
        Uri.parse('${ConsultationChatURL}/id/$patientId'),
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
        print('why');
        throw Exception('Failed to fetch ConsultationChats');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<void> deleteConsultationChat(String id) async {}
}
