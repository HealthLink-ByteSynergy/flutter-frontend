import 'package:healthlink/models/Doctor.dart';
import 'package:healthlink/models/Patient.dart';
import 'package:healthlink/models/Prescription.dart';

class DetailedSummary {
  final Doctor doctor;
  final Patient patient;
  final Prescription prescription;
  final String text;
  final String timestamp;

  DetailedSummary({
    required this.doctor,
    required this.patient,
    required this.prescription,
    required this.text,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() {
    return {
      'doctor': doctor.toJson(),
      'patient': patient.toJson(),
      'prescription': prescription.toJson(),
      'text': text,
      'timestamp': timestamp,
    };
  }

  factory DetailedSummary.fromJson(Map<String, dynamic> json) {
    return DetailedSummary(
      doctor: Doctor.fromJson(json['doctor']),
      patient: Patient.fromJson(json['patient']),
      prescription: Prescription.fromJson(
          json['prescription'], json['doctor'], json['patient']),
      text: json['text'],
      timestamp: json['timestamp'],
    );
  }
}
