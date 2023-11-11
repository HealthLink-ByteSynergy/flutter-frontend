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
}
