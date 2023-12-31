class Doctor {
  String doctorId;
  String userId;
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
      specializations: ['j'],
      // convertCommaSeparatedStringToList(json['specialization']),
      availability: json['isAvailable'] ?? '',
      licenseNumber: json['licenseNumber'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      email: json['userEntity']['email'] ?? '',
      username: json['userEntity']['username'] ?? '',
      password: json['userEntity']['password'] ?? '',
    );
  }

  List<String> convertCommaSeparatedStringToList(String jsonString) {
    // Split the string by commas and convert it into a list
    List<String> values = jsonString.split(',');

    return values;
  }

  Map<String, dynamic> toJson() {
    return {
      'doctorId': doctorId,
      'userEntity': {
        'id': userId,
      },
      'specialization': specializations,
      'isAvailable': availability,
      'licenseNumber': licenseNumber,
      'phoneNumber': phoneNumber,
      'email': email,
      'username': username,
      'password': password,
    };
  }
}
