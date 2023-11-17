import 'package:healthlink/models/Prescription.dart';

class DetailedSummary {
  final String doctorName;
  final String patientName;
  final Prescription prescription;
  final String summaryText;
  final DateTime timestamp;

  DetailedSummary({
    required this.doctorName,
    required this.patientName,
    required this.prescription,
    required this.summaryText,
    required this.timestamp,
  });
}
