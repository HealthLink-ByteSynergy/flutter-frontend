import 'package:healthlink/models/Medicine.dart';

class Prescription {
  String doctorId;
  String patientId;
  List<Medicine> medicines;
  String generalHabits;

  Prescription({
    required this.doctorId,
    required this.patientId,
    required this.medicines,
    required this.generalHabits,
  });

  Map<String, dynamic> toJson() {
    return {
      'prescriptionId': '',
      'genralHabits': generalHabits,
    };
  }
}
