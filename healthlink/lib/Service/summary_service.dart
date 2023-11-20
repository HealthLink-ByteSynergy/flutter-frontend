import 'dart:convert';
import 'package:healthlink/APIs.dart';
import 'package:healthlink/Service/auth_service.dart';
import 'package:healthlink/models/Detailed_Summary.dart';
import 'package:http/http.dart' as http;

class DetailedSummaryService {
  String summaryURL = API.baseURL + API.summaryEndpoint;

  Future<Map<String, dynamic>?> saveDetailedSummary(
      DetailedSummary DetailedSummary) async {
    print('in save');
    Map<String, dynamic> result = {};
    try {
      final String? jwtToken = await AuthService().getToken();
      final response = await http.post(
        Uri.parse('$summaryURL/saveUsertoBot'),
        headers: <String, String>{
          'Authorization': 'Bearer $jwtToken',
          'Content-Type': 'application/json; charset=UTF-8',
        },
        // body: json.encode(
        //   {
        //     "previousDetailedSummaryId": DetailedSummary.previousDetailedSummaryId,
        //     "senPatientEntity": {"patientId": DetailedSummary.senderId},
        //     "text": DetailedSummary.text
        //   },
        // )
      );

      print(response.body);
      if (response.statusCode == 200) {
        result['data'] = 'success';
      } else {
        // Request failed, store error DetailedSummary in the result map
      }
    } catch (error) {
      print(error);
      // Handle other errors like network issues
    }

    return result;
  }

  Future<List<DetailedSummary>?> getDetailedSummarysByPatientId(
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
}
