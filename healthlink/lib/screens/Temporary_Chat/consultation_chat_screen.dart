// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:healthlink/Service/message_service.dart';
import 'package:healthlink/models/Message.dart';
import 'package:healthlink/models/Prescription.dart';
import 'package:healthlink/screens/Temporary_Chat/prescription_screen.dart';
import 'package:healthlink/utils/colors.dart';

class ConsultationChatScreen extends StatefulWidget {
  final String patientId;
  final String doctorId;

  const ConsultationChatScreen(
      {Key? key, required this.patientId, required this.doctorId})
      : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _ConsultationChatScreenState createState() => _ConsultationChatScreenState();
}

class _ConsultationChatScreenState extends State<ConsultationChatScreen> {
  late Prescription prescriptionTosave = Prescription(
    doctorId: '', // Default values or empty strings
    patientId: '',
    medicines: [],
    generalHabits: '',
  );

  final TextEditingController _messageController = TextEditingController();
  List<Message> messages = [];
  final MessageService _messageService = MessageService();
  bool _isInputEmpty = true;
  DateTime _lastUserMessageTime = DateTime.now();
  bool _botReplied = true; // Flag to track whether the bot has replied

  @override
  void initState() {
    super.initState();
    setState(() {
      prescriptionTosave.doctorId = widget.doctorId;
      prescriptionTosave.medicines = [];
      prescriptionTosave.generalHabits = '';
      prescriptionTosave.patientId = widget.patientId;
    });
    // _fetchMessages();
  }

  void _fetchMessages() async {
    try {
      List<Message>? fetchedMessages =
          await _messageService.getMessagesFromBot(widget.patientId);

      if (fetchedMessages != null) {
        setState(() {
          messages = fetchedMessages;
        });
      }
    } catch (e) {
      print('Error fetching messages: $e');
    }
  }

  void _sendMessage(String text) async {
    setState(() {
      _isInputEmpty = true;
      _botReplied = true; // User has sent a message, waiting for bot reply
    });
    _messageController.clear();
    Message newMessage = Message(
        messageId: "",
        previousMessageId: "",
        receiverId: "",
        messageType: "",
        text: text,
        senderId: widget.patientId,
        timestamp: DateTime.now().toString(),
        summary: text
        // Add other necessary properties for the message
        );

    if (messages.isNotEmpty) {
      newMessage.previousMessageId = messages[messages.length - 1].messageId;
    }

    setState(() {
      messages.add(newMessage);
    });

    try {
      Map<String, dynamic>? result =
          await _messageService.saveMessage(newMessage);

      if (result!['data'] == 'success') {
        _fetchMessages();
      }
    } catch (e) {
      print('Error sending message: $e');
    }

    _messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: color3,
      appBar: AppBar(
        backgroundColor:
            collaborateAppBarBgColor, // Replace with collaborateAppBarBgColor
        title: const Text('HealthLink'),
        actions: <Widget>[
          IconButton(
              icon: Icon(
                  Icons.description), // Replace with your add prescription icon
              onPressed: () async {
                Prescription? prescription = await showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return PrescriptionScreen(
                      doctorId: widget.doctorId,
                      patientId: widget.patientId,
                      currentPrescription: prescriptionTosave,
                    );
                  },
                );
                if (prescription != null) {
                  prescriptionTosave = prescription;
                  print(prescriptionTosave.toString());
                }
              }),
          IconButton(
            icon: Icon(Icons.phone), // Replace with your phone call icon
            onPressed: () {
              // Navigate to phone call screen
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(builder: (context) => PhoneCallScreen()),
              // );
            },
          ),
          PopupMenuButton<String>(
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              PopupMenuItem<String>(
                value: 'patientInfo',
                child: Text('Patient Info'),
              ),
              PopupMenuItem<String>(
                value: 'doctorInfo',
                child: Text('Doctor Info'),
              ),
              PopupMenuItem<String>(
                value: 'exitChat',
                child: Text('Exit Chat'),
              ),
            ],
            onSelected: (String value) {
              switch (value) {
                case 'patientInfo':
                  // Navigate to patient info screen
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //       builder: (context) => PatientInfoScreen()),
                  // );
                  break;
                case 'doctorInfo':
                  // Navigate to doctor info screen
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(builder: (context) => DoctorInfoScreen()),
                  // );
                  break;
                case 'exitChat':
                  // Perform exit chat action
                  // For example, pop back to previous screens or close the chat
                  break;
              }
            },
            offset: Offset(0, 56),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(8.0),
              itemCount: messages.length, // Use the messages list length
              itemBuilder: (BuildContext context, int index) {
                Message message =
                    messages[index]; // Get the message at this index
                String timestampString = message.timestamp;

                DateTime timestamp = DateTime.parse(timestampString);
                // Build the chat message using the actual message object
                // print(DateTime.now());
                return _buildChatMessage(message.text,
                    message.senderId == widget.patientId, timestamp);
              },
            ),
          ),
          _buildInputField(),
        ],
      ),
    );
  }

  Widget _buildChatMessage(String message, bool isUser, DateTime messageTime) {
    // Check if the date has changed since the last message
    bool showDate = messageTime.day != _lastUserMessageTime.day ||
        messageTime.month != _lastUserMessageTime.month ||
        messageTime.year != _lastUserMessageTime.year;

    _lastUserMessageTime = messageTime; // Update the last user message time

    return Column(
      children: [
        if (showDate) _buildDateSeparator(messageTime),
        Align(
          alignment:
              isUser == false ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            margin: const EdgeInsets.all(8.0),
            padding: const EdgeInsets.all(12.0),
            constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.75),
            decoration: BoxDecoration(
              color: isUser == false ? collaborateAppBarBgColor : blackColor,
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: Text(
              message,
              style: GoogleFonts.raleway(
                  color: color4, fontSize: 15, fontWeight: FontWeight.w500),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInputField() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              autocorrect: true,
              cursorColor: color4,
              maxLines: null,
              onChanged: (text) {
                setState(() {
                  _isInputEmpty = text.isEmpty;
                });
              },
              decoration: InputDecoration(
                labelText: 'Message',
                counterStyle: const TextStyle(color: color4),
                labelStyle: const TextStyle(
                    color: color4), // Change to your preferred color
                filled: true,
                floatingLabelBehavior: FloatingLabelBehavior.never,
                fillColor: collaborateAppBarBgColor,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide:
                      const BorderSide(width: 0, style: BorderStyle.none),
                ),
              ),
              style: GoogleFonts.raleway(
                  color: color4, fontWeight: FontWeight.w500),
              keyboardType: TextInputType.text,
              enabled: _botReplied, // Disable input if the bot hasn't replied
            ),
          ),
          const SizedBox(width: 8.0),
          _buildSendButton(),
        ],
      ),
    );
  }

  Widget _buildDateSeparator(DateTime messageTime) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        '${messageTime.day}/${messageTime.month}/${messageTime.year}',
        style: const TextStyle(color: blackColor),
      ),
    );
  }

  Widget _buildSendButton() {
    return GestureDetector(
      onTap: _isInputEmpty || !_botReplied
          ? null
          : () {
              _sendMessage(_messageController.text);
            },
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: _isInputEmpty || !_botReplied
              ? Colors.grey
              : collaborateAppBarBgColor,
        ),
        padding: const EdgeInsets.all(8.0),
        child: Icon(
          Icons.send,
          color: _isInputEmpty || !_botReplied ? color4 : color4,
          size: 35.0,
        ),
      ),
    );
  }

  // void _sendMessage(String text) {
  //   setState(() {
  //     _isInputEmpty = true;
  //     _botReplied = false; // User has sent a message, waiting for bot reply
  //   });
  //   _messageController.clear();

  //   // Simulate bot's reply after a delay (you can replace this with actual logic)
  //   Future.delayed(const Duration(seconds: 2), () {
  //     setState(() {
  //       _botReplied = true; // Bot has replied, enable input and send button
  //     });
  //     // Simulate displaying bot's reply
  //     _buildChatMessage('Bot reply', false, DateTime.now());
  //   });
  // }
}

void main() {
  runApp(const MaterialApp(
    home: ConsultationChatScreen(
      patientId: "hehe",
      doctorId: "hii",
    ),
  ));
}
