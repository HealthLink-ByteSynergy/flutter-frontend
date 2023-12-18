class Message {
  String messageId;
  String previousMessageId;
  String receiverId;
  String senderId;
  String text;
  String messageType;
  String timestamp;
  String summary;

  Message({
    required this.messageId,
    required this.previousMessageId,
    required this.receiverId,
    required this.senderId,
    required this.text,
    required this.messageType,
    required this.timestamp,
    required this.summary,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      messageId: json['messageId'] ?? '',
      previousMessageId: json['previousMessageId'] ?? '',
      senderId: json["senPatientEntity"]?['patientId'] ?? '',
      receiverId: json['recPatientEntity']?['patientId'] ?? '',
      text: json['text'] ?? '',
      messageType: json['messageType'] ?? '',
      timestamp: json['date'] ?? DateTime.now().toIso8601String(),
      summary: json['summary'] ?? '',
    );
  }
}
