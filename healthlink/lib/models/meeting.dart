class Message {
  String messageId;
  String receiverId;
  String senderId;
  String text;
  String messageType;
  String date;
  String summary;

  Message({
    required this.messageId,
    required this.receiverId,
    required this.senderId,
    required this.text,
    required this.messageType,
    required this.date,
    required this.summary,
  });
}
