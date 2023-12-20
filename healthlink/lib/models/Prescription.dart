// ignore_for_file: non_constant_identifier_names

import 'package:healthlink/models/Medicine.dart';

class Prescription {
  String prescriptionId;
  String doctorId;
  String patientId;
  List<Medicine> medicines;
  String generalHabits;

  Prescription({
    required this.prescriptionId,
    required this.doctorId,
    required this.patientId,
    required this.medicines,
    required this.generalHabits,
  });

  Map<String, dynamic> toJson() {
    return {
      'prescriptionId': '',
      'genralHabits': generalHabits ?? 'No general habits mentioned',
      'medicines': ''
    };
  }

  factory Prescription.fromJson(Map<String, dynamic> json_pre,
      Map<String, dynamic> json_doc, Map<String, dynamic> json_pat) {
    return Prescription(
        prescriptionId: json_pre['prescriptionId'],
        doctorId: json_doc['doctorId'],
        patientId: json_pat['patientId'],
        medicines: json_pre['medicineId'],
        generalHabits: json_pre['generalHabbits']);
  }

  @override
  String toString() {
    return 'Prescription{doctorId: $doctorId, patientId: $patientId, medicines: $medicines, generalHabits: $generalHabits}';
  }
}
