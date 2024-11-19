import 'dart:convert';
import 'package:healthlink/APIs.dart';
import 'package:healthlink/Service/auth_service.dart';
import 'package:healthlink/models/Doctor.dart';
import 'package:healthlink/models/Message.dart';
import 'package:healthlink/models/Patient.dart';
import 'package:healthlink/models/patient_details.dart';
import 'package:http/http.dart' as http;

class MessageService {
  String messageURL = API.baseURL + API.messageEndpoint;

  Future<Map<String, dynamic>?> saveMessage(Message message) async {
    // print('in save');
    Map<String, dynamic> result = {};
    try {
      final String? jwtToken = await AuthService().getToken();
      final response = await http.post(Uri.parse('$messageURL/saveUsertoBot'),
          headers: <String, String>{
            'Authorization': 'Bearer $jwtToken',
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: json.encode(
            {
              "previousMessageId": message.previousMessageId,
              "senPatientEntity": {"patientId": message.senderId},
              "text": message.text
            },
          ));

      print(response.body);
      if (response.statusCode == 200) {
        result['data'] = 'success';
      } else {
        // Request failed, store error message in the result map
      }
    } catch (error) {
      print(error);
      // Handle other errors like network issues
    }

    return result;
  }

  Future<Map<String, dynamic>?> saveMessageToUser(Message message) async {
    // print('in save message user');
    Map<String, dynamic> result = {};
    try {
      final String? jwtToken = await AuthService().getToken();
      final response = await http.post(Uri.parse('$messageURL/saveUsertoUser'),
          headers: <String, String>{
            'Authorization': 'Bearer $jwtToken',
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: json.encode(
            {
              // "previousMessageId": message.previousMessageId,
              "senPatientEntity": {"patientId": message.senderId},
              "recPatientEntity": {"patientId": message.receiverId},
              "text": message.text,
              "messageType": "CHAT",
            },
          ));

      print(response.body);
      if (response.statusCode == 200) {
        result['data'] = 'success';
      } else {
        // Request failed, store error message in the result map
      }
    } catch (error) {
      print(error);
    }

    return result;
  }

  Future<Map<String, dynamic>?> saveMeeting(Message message) async {
    // print('in save meeting user');
    Map<String, dynamic> result = {};
    try {
      final String? jwtToken = await AuthService().getToken();
      final response = await http.post(Uri.parse('$messageURL/saveMeetingChat'),
          headers: <String, String>{
            'Authorization': 'Bearer $jwtToken',
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: json.encode(
            {
              // "previousMessageId": message.previousMessageId,
              "senPatientEntity": {"patientId": message.senderId},
              "recPatientEntity": {"patientId": message.receiverId},
              "text": message.text,
              "messageType": "NOTIFICATION",
            },
          ));

      print(response.body);
      if (response.statusCode == 200) {
        result['data'] = 'success';
      } else {
        // Request failed, store error message in the result map
      }
    } catch (error) {
      print(error);
    }

    return result;
  }

  Future<List<Message>?> getMessagesFromBot(String patientId) async {
    List<Message> messages = [];
    try {
      final String? jwtToken = await AuthService().getToken();
      final response =
          await http.post(Uri.parse('$messageURL/getAllMessagesBot'),
              headers: {
                'Authorization': 'Bearer $jwtToken',
                'Content-Type': 'application/json',
              },
              body: json.encode({
                "senPatientEntity": {
                  "patientId": patientId,
                }
              }));

      // print(response.body);
      if (response.statusCode == 200) {
        final List<dynamic> jsonResponse = json.decode(response.body);
        print(jsonResponse);
        messages = jsonResponse.map((json) => Message.fromJson(json)).toList();

        return messages;
      } else {
        throw Exception('Failed to fetch messages');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<List<Message>?> getMessagesFromUser(
      String patientId, String doctorId) async {
    List<Message> messages = [];
    // print("entered getMessages");
    try {
      final String? jwtToken = await AuthService().getToken();
      final response = await http.post(Uri.parse('$messageURL/getAllMessages'),
          headers: {
            'Authorization': 'Bearer $jwtToken',
            'Content-Type': 'application/json',
            // Add other necessary headers here if required by your API
          },
          body: json.encode({
            "senPatientEntity": {
              "patientId": patientId,
            },
            "recPatientEntity": {"patientId": doctorId}
          }));

      // print({
      //   "senPatientEntity": {
      //     "patientId": patientId,
      //   },
      //   "recPatientEntity": {"patientId": doctorId}
      // }.toString());

      if (response.statusCode == 200) {
        final List<dynamic> jsonResponse = json.decode(response.body);
        messages = jsonResponse.map((json) => Message.fromJson(json)).toList();

        return messages;
      } else {
        throw Exception('Failed to fetch messages');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<List<Doctor>?> getDoctors(
      String prevMessageID, String patientId) async {
    List<Doctor> doctors = [];
    try {
      final String? jwtToken = await AuthService().getToken();
      final response =
          await http.post(Uri.parse('$messageURL/recommendSpecialist'),
              headers: {
                'Authorization': 'Bearer $jwtToken',
                'Content-Type': 'application/json',
              },
              body: json.encode({
                "previousMessageId": prevMessageID,
                "senPatientEntity": {
                  "patientId": patientId,
                }
              }));

      print(response.body);
      if (response.statusCode == 200) {
        final List<dynamic>? jsonResponse =
            json.decode(response.body)['doctorEntity'];
        print(jsonResponse);
        if (jsonResponse != null) {
          doctors = jsonResponse.map((json) => Doctor.fromJson(json)).toList();
        }

        return doctors;
      } else {
        throw Exception('Failed to fetch messages');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<Map<String, dynamic>?> deleteMessagesBetweenUsers(
      String patientId, String docPatientId) async {
    Map<String, dynamic> result = {};
    try {
      final String? jwtToken = await AuthService().getToken();
      final response = await http.delete(Uri.parse('$messageURL/deleteAll'),
          headers: <String, String>{
            'Authorization': 'Bearer $jwtToken',
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: json.encode(
            {
              "senPatientEntity": {"patientId": patientId},
              "recPatientEntity": {"patientId": docPatientId},
            },
          ));

      print(response.body);
      if (response.statusCode == 200) {
        result['data'] = 'success';
      } else {
        result['data'] = 'failure';
      }
    } catch (error) {
      result['data'] = error.toString();
    }
    return result;
  }
}
