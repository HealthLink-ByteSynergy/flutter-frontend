class Medicine {
  final String id;
  final String name;
  final String dosage;
  final String frequency;

  Medicine(
      {required this.id,
      required this.name,
      required this.dosage,
      required this.frequency});

  factory Medicine.fromJson(Map<String, dynamic> json) {
    return Medicine(
      id: json['id'] as String,
      name: json['name'] as String,
      dosage: json['dosage'] as String,
      frequency: json['frequency'] as String,
    );
  }
}
