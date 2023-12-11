import 'package:healthlink/models/Doctor.dart';
import 'package:healthlink/models/Patient.dart';

class ConsultationChat {
  String id;
  Patient doctor;
  Patient patient;

  ConsultationChat(
      {required this.id, required this.doctor, required this.patient});

  factory ConsultationChat.fromJson(Map<String, dynamic> map) {
    return ConsultationChat(
      id: map['id'] ?? '',
      doctor: Patient.fromJson(map['docPatientEntity']),
      patient: Patient.fromJson(map['patientEntity']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'doctors': doctor.toJson(),
      'patients': patient.toJson(),
    };
  }
}
