import 'package:healthlink/models/Prescription.dart';

class Summary {
  String summaryId;
  String patientId;
  String doctorId;
  String summaryText;
  String prescriptionId;
  DateTime timestamp;

  Summary({
    required this.summaryId,
    required this.patientId,
    required this.doctorId,
    required this.summaryText,
    required this.prescriptionId,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() {
    return {
      'summaryId': summaryId,
      'doctorEntity': {
        'doctorId': doctorId,
      },
      'patientEntity': {
        'patientId': patientId,
      },
      'text': summaryText,
      'date': timestamp,
    };
  }
}
