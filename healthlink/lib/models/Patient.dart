import 'package:healthlink/models/patient_details.dart';

class Patient {
  String? patientId;
  String? userId;
  CustomForm? form;

  Map<String, dynamic> toJson() {
    return {
      'patientId': patientId,
      'userEntity': {
        'id': userId,
      },
      'name': form?.getName ?? "N/A",
      'age': form?.getAge ?? "N/A",
      'gender': form?.getGender ?? "N/A",
      'phoneNumber': form?.getNumber ?? "N/A",
      'height': form?.getHeight ?? "N/A",
      'weight': form?.getWeight ?? "N/A",
      'medicalCondition': form?.getMedicalConditions ?? "N/A",
      'medication': form?.getMedications ?? "N/A",
      'surgeries': form?.getRecentSurgeryOrProcedure ?? "N/A",
      'smokingFrequency': form?.getSmokingFrequency ?? "N/A",
      'drinkingFrequency': form?.getDrinkingFrequency ?? "N/A",
      'drugsUseFrequency': form?.getDrugsUsedAndFrequency ?? "N/A",
    };
  }

  Patient({this.patientId, this.userId, this.form});

  factory Patient.fromJson(Map<String, dynamic> json) {
    return Patient(
      patientId: json['patientId'],
      userId: json['userEntity']['id'],
      form: CustomForm.fromJson(json),
    );
  }

  Patient.empty();
}
