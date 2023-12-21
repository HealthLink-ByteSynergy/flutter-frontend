import 'dart:convert';
import 'package:healthlink/APIs.dart';
import 'package:healthlink/Service/auth_service.dart';
import 'package:healthlink/models/DetailedSummary.dart';
import 'package:healthlink/models/Medicine.dart';
import 'package:healthlink/models/Prescription.dart';
import 'package:healthlink/models/Summary.dart';
import 'package:http/http.dart' as http;

class DetailedSummaryService {
  String summaryURL = API.baseURL + API.summaryEndpoint;
  String prescriptionURL = API.baseURL + API.prescriptionEndpoint;
  String medicineURL = API.baseURL + API.medicineEndpoint;

  Future<String> saveSummary(DetailedSummary summary) async {
    try {
      Map<String, dynamic>? savePrescriptionResult =
          await savePrescription(summary.prescription);
      if (savePrescriptionResult != null) {
        String medicineId = savePrescriptionResult['medicineId'];

        String? saveMedicineResult;

        // Iterate through the list of medicines and save each one
        for (Medicine medicine in summary.prescription.medicines) {
          saveMedicineResult = await saveMedicine(medicine, medicineId);
        }

        print(summary.toJson());
        summary.prescription.prescriptionId =
            savePrescriptionResult['prescriptionId'];
        print(savePrescriptionResult);

        // print(savePrescriptionResult['prescriptionId']);

        String? saveSummaryResult = await saveSummaryObject(summary);
        if (saveSummaryResult != null && saveSummaryResult == "success") {
          return "success";
        } else {
          return "success";
        }
      }
    } catch (e) {
      // print(summary.toString());
      return e.toString();
    }
    return "failure";
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
          body: json.encode({'generalHabits': prescription.generalHabits}));

      // print(response.body);
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        print(jsonResponse);
        result['medicineId'] = jsonResponse['medicineId'];
        result['prescriptionId'] = jsonResponse['prescriptionId'];
      } else {
        print('error in prescripition save');
        // Request failed, store error message in the result map
      }
    } catch (error) {
      print(error.toString());
      // Handle other errors like network issues
    }
    return result;
  }

  Future<String> saveMedicine(Medicine medicine, String medicineId) async {
    // Map<String, dynamic> result = {};
    print("entered medicine");
    try {
      final String? jwtToken = await AuthService().getToken();
      final response = await http.post(Uri.parse('$medicineURL/save'),
          headers: <String, String>{
            'Authorization': 'Bearer $jwtToken',
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: json.encode({
            // 'id': "",
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
    return "";
  }

  Future<String?> saveSummaryObject(DetailedSummary summary) async {
    // Map<String, dynamic> result = {};
    try {
      final String? jwtToken = await AuthService().getToken();
      final response = await http.post(Uri.parse('$summaryURL/save'),
          headers: <String, String>{
            'Authorization': 'Bearer $jwtToken',
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: json.encode({
            "doctorEntity": {
              "patientEntity": {"patientId": summary.doctor.docPatientId}
            },
            "patientEntity": {"patientId": summary.patient.patientId},
            "prescriptionEntity": {
              "prescriptionId": summary.prescription.prescriptionId
            }
          }));
      print({
        // 'summaryId': '',
        'doctorEntity': {
          'doctorId': summary.doctor.doctorId,
          'patientEntity': {
            'patientId': summary.doctor.docPatientId,
          }
        },
        'patientEntity': {
          'patientId': summary.patient.patientId,
        },
        "prescriptionEntity": {
          "prescriptionId": summary.prescription.prescriptionId,
          "generalHabits": summary.prescription.generalHabits,
          "medicineId": summary.prescription.medicines[0].id
        },
        // 'text': summary.text,
        // 'date': DateTime.now().toString(),
      }.toString());
      print(response.statusCode);
      print(response.body);
      if (response.statusCode == 200) {
        // print(response.body);
        // final Map<String, dynamic> jsonResponse = json.decode(response.body);
        // result['medicineId'] = jsonResponse['medicineId'];
        return "success";
      } else {
        print(response.body);
        // print('error in prescripition save');
        // Request failed, store error message in the result map
        return "failure";
      }
    } catch (error) {
      print(error);
      print(summary.toString());
      // print(error);
      // Handle other errors like network issues
      return error.toString();
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

      print(response.body);
      if (response.statusCode == 200) {
        final List<dynamic> jsonResponse = json.decode(response.body);
        print(jsonResponse);
        summaries =
            jsonResponse.map((json) => DetailedSummary.fromJson(json)).toList();

        return summaries;
      } else {
        throw Exception('Failed to fetch DetailedSummarys');
      }
    } catch (e) {
      print(e.toString());
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
        print(jsonResponse);
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

  Future<List<Medicine>?> getMedicinesByMedicineId(String medicineId) async {
    List<Medicine> medicines = [];
    try {
      final String? jwtToken = await AuthService().getToken();
      final response = await http.get(
        Uri.parse('$medicineURL/getMedicines/$medicineId'),
        headers: {
          'Authorization': 'Bearer $jwtToken',
          'Content-Type': 'application/json',
        },
      );

      // print(response.body);
      if (response.statusCode == 200) {
        final List<dynamic> jsonResponse = json.decode(response.body);
        // print(jsonResponse);
        medicines =
            jsonResponse.map((json) => Medicine.fromJson(json)).toList();
        return medicines;
      } else {
        throw Exception('Failed to fetch DetailedSummarys');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}
