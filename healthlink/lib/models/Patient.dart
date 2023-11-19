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
      'name': form?.getName,
      'age': form?.getAge,
      'gender': form?.getGender,
      'phoneNumber': form?.getNumber,
      'height': form?.getHeight,
      'weight': form?.getWeight,
      'medicalCondition': form?.getMedicalConditions,
      'medication': form?.getMedications,
      'surgeries': form?.getRecentSurgeryOrProcedure,
      'smokingFrequency': form?.getSmokingFrequency,
      'drinkingFrequency': form?.getDrinkingFrequency,
      'drugsUseFrequency': form?.getDrugsUsedAndFrequency,
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
