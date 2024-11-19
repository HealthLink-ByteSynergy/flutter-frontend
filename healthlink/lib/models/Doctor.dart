class Doctor {
  String doctorId;
  String userId;
  String docPatientId;
  List specializations;
  String availability;
  String licenseNumber;
  String phoneNumber;
  String email;
  String username;
  String password;

  Doctor(
      {required this.doctorId,
      required this.userId,
      required this.docPatientId,
      required this.specializations,
      required this.availability,
      required this.phoneNumber,
      required this.licenseNumber,
      required this.email,
      required this.username,
      required this.password});

  bool validate() {
    bool val;
    val =
        specializations.isNotEmpty && licenseNumber != '' && phoneNumber != '';
    return val;
  }

  factory Doctor.fromJson(Map<String, dynamic> json) {
    return Doctor(
      doctorId: json['doctorId'] ?? '',
      userId: json['userEntity']['id'] ?? '',
      specializations: json['specialization'].split(','),
      docPatientId: json["patientEntity"]["patientId"],
      // convertCommaSeparatedStringToList(json['specialization']),
      availability: json['isAvailable'] ?? '',
      licenseNumber: json['licenseNumber'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      email: json['userEntity']['email'] ?? '',
      username: json['userEntity']['user'] ?? '',
      password: json['userEntity']['password'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'doctorId': doctorId,
      'userEntity': {
        'id': userId,
      },
      'patientEntity': {'patientId': docPatientId},
      'specialization': specializations,
      'isAvailable': availability,
      'licenseNumber': licenseNumber,
      'phoneNumber': phoneNumber,
      'email': email,
      'username': username,
      'password': password
    };
  }
}
