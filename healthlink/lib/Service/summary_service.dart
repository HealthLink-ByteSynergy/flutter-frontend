import 'dart:convert';
import 'package:healthlink/APIs.dart';
import 'package:healthlink/Service/auth_service.dart';
import 'package:healthlink/models/Detailed_Summary.dart';
import 'package:healthlink/models/Medicine.dart';
import 'package:healthlink/models/Prescription.dart';
import 'package:http/http.dart' as http;

class DetailedSummaryService {
  String summaryURL = API.baseURL + API.summaryEndpoint;
  String prescriptionURL = API.baseURL + API.prescriptionEndpoint;
  String medicineURL = API.baseURL + API.medicineEndpoint;

  void saveSummary(DetailedSummary summary) async {
    Map<String, dynamic>? medicineIds =
        await savePrescription(summary.prescription);

    if (medicineIds != null) {
      String medicineId = medicineIds['medicineId'];

      // Iterate through the list of medicines and save each one
      for (Medicine medicine in summary.prescription.medicines) {
        await saveMedicine(medicine, medicineId);
      }

      await saveSummaryObject(summary);
    }
    return;
  }

  Future<Map<String, dynamic>?> savePrescription(
      Prescription prescription) async {
    Map<String, dynamic> result = {};
    try {
      final String? jwtToken = await AuthService().getToken();
      final response = await http.post(Uri.parse('$prescriptionURL/save'),
          headers: <String, String>{
            'Authorization': 'Bearer $jwtToken',
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: json.encode(prescription.toJson()));

      // print(response.body);
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        result['medicineId'] = jsonResponse['medicineId'];
      } else {
        print('error in prescripition save');
        // Request failed, store error message in the result map
      }
    } catch (error) {
      print(error);
      // Handle other errors like network issues
    }
    return result;
  }

  Future<void> saveMedicine(Medicine medicine, String medicineId) async {
    // Map<String, dynamic> result = {};
    try {
      final String? jwtToken = await AuthService().getToken();
      final response = await http.post(Uri.parse('$medicineURL/save'),
          headers: <String, String>{
            'Authorization': 'Bearer $jwtToken',
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: json.encode({
            'id': " ",
            'medicineId': medicineId,
            'name': medicine.name,
            'dosage': medicine.dosage,
            'frequency': medicine.frequency
          }));

      // print(response.body);
      if (response.statusCode == 200) {
        // final Map<String, dynamic> jsonResponse = json.decode(response.body);
        // result['medicineId'] = jsonResponse['medicineId'];
      } else {
        print('error in prescripition save');
        print(response.body);
        // Request failed, store error message in the result map
      }
    } catch (error) {
      print(error);
      // Handle other errors like network issues
    }
    return;
  }

// Function to save the summary object
  Future<void> saveSummaryObject(DetailedSummary summary) async {
    // Map<String, dynamic> result = {};
    try {
      final String? jwtToken = await AuthService().getToken();
      final response = await http.post(Uri.parse('$prescriptionURL/save'),
          headers: <String, String>{
            'Authorization': 'Bearer $jwtToken',
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: json.encode({
            'summaryId': '',
            'doctorEntity': {
              'doctorId': summary.doctor.doctorId,
            },
            'patientEntity': {
              'patientId': summary.patient.patientId,
            },
            'text': summary.text,
            'date': '',
          }));

      // print(response.body);
      if (response.statusCode == 200) {
        // print(response.body);
        // final Map<String, dynamic> jsonResponse = json.decode(response.body);
        // result['medicineId'] = jsonResponse['medicineId'];
      } else {
        print(response.body);
        // print('error in prescripition save');
        // Request failed, store error message in the result map
      }
    } catch (error) {
      print(error);
      // print(error);
      // Handle other errors like network issues
    }
  }

  Future<List<DetailedSummary>?> getDetailedSummariesByPatientId(
      String patientId) async {
    List<DetailedSummary> summaries = [];
    try {
      final String? jwtToken = await AuthService().getToken();
      final response = await http.get(
        Uri.parse(
            '$summaryURL/getAllPatientSummaries/$patientId'), // Assuming the endpoint structure
        headers: {
          'Authorization': 'Bearer $jwtToken',
          'Content-Type': 'application/json',
          // Add other necessary headers here if required by your API
        },
      );

      // print(response.body);
      if (response.statusCode == 200) {
        final List<dynamic> jsonResponse = json.decode(response.body);
        // print(jsonResponse);
        summaries =
            jsonResponse.map((json) => DetailedSummary.fromJson(json)).toList();

        return summaries;
      } else {
        throw Exception('Failed to fetch DetailedSummarys');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<List<DetailedSummary>?> getDetailedSummariesByDoctorId(
      String doctorId) async {
    List<DetailedSummary> summaries = [];
    try {
      final String? jwtToken = await AuthService().getToken();
      final response = await http.get(
        Uri.parse(
            '$summaryURL/getAllDoctorSummaries/$doctorId'), // Assuming the endpoint structure
        headers: {
          'Authorization': 'Bearer $jwtToken',
          'Content-Type': 'application/json',
          // Add other necessary headers here if required by your API
        },
      );

      // print(response.body);
      if (response.statusCode == 200) {
        final List<dynamic> jsonResponse = json.decode(response.body);
        // print(jsonResponse);
        // summaries =
        // jsonResponse.map((json) => DetailedSummary.fromJson(json)).toList();
        return summaries;
      } else {
        throw Exception('Failed to fetch DetailedSummarys');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}
