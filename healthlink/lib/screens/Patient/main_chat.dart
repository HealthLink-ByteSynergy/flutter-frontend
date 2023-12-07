import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:healthlink/Service/message_service.dart';
import 'package:healthlink/Service/patient_service.dart';
import 'package:healthlink/models/Message.dart';
import 'package:healthlink/models/Patient.dart';
import 'package:healthlink/models/Summary.dart';
import 'package:healthlink/screens/Patient/search_summaries_screen.dart';
import 'package:healthlink/screens/Patient/patient_settings.dart';
import 'package:healthlink/utils/colors.dart';
import 'package:healthlink/utils/widgets/summary_list.dart';

class ChatScreen extends StatefulWidget {
  final String patientId;

  const ChatScreen({Key? key, required this.patientId}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  List<Message> messages = [];
  final MessageService _messageService = MessageService();
  bool _isInputEmpty = true;
  DateTime _lastUserMessageTime = DateTime.now();
  bool _botReplied = true; // Flag to track whether the bot has replied
  bool isDoctorButtonVisible = true;

  @override
  void initState() {
    super.initState();
    _fetchMessages();
  }

  // void _fetchPatientDetails() async {
  //   try {
  //     // String? userId = await AuthService().getUserId();
  //     Patient? fetchedDoctor = await PatientService().getPatientByUserId();

  //     if (fetchedDoctor != null) {
  //       setState(() {
  //         doctor = fetchedDoctor;
  //       });
  //     }
  //   } catch (e) {
  //     print('Error fetching doctor details: $e');
  //   }
  // }

  void _fetchMessages() async {
    try {
      List<Message>? fetchedMessages =
          await _messageService.getMessagesFromBot(widget.patientId);

      if (fetchedMessages != null) {
        setState(() {
          messages = fetchedMessages;
          _botReplied = true;
        });
      }
    } catch (e) {
      print('Error fetching messages: $e');
    }
  }

  void _sendMessage(String text) async {
    setState(() {
      _isInputEmpty = true;
      _botReplied = false; // User has sent a message, waiting for bot reply
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

    // print(
    //     'patientId and sender id- ${newMessage.senderId == widget.patientId}}');

    setState(() {
      messages.add(newMessage);
      // print('sender id and patient id');
      // print(newMessage.senderId);
      // print('patientId');
      // print(widget.patientId);
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
        backgroundColor: collaborateAppBarBgColor,
        title: const Text('HealthLink'),
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu), // Icon that opens the drawer
            onPressed: () {
              // Open the drawer
              Scaffold.of(context).openDrawer();
            },
          ),
        ),
        actions: <Widget>[
          IconButton(
              onPressed: () => Navigator.pop(context),
              icon: Icon(Icons.home_filled)),
          Visibility(
            visible: true,
            child: TextButton(
              onPressed: () {
                // Perform actions when the doctor button is pressed
                // For example, change the color or toggle visibility
                setState(() {
                  isDoctorButtonVisible = false;
                });
                // Change visibility of the button
                // You can add more actions here
              },
              child: Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: isDoctorButtonVisible ? color4 : Colors.grey,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'Doctor', // Text for the doctor button
                  style: TextStyle(
                      color: isDoctorButtonVisible
                          ? collaborateAppBarBgColor
                          : color4,
                      fontSize: 20), // Adjust text color as needed
                ),
              ),
            ),
          ),
        ],
      ),
      drawer: _buildDrawer(),
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
                // print('pat-${widget.patientId}, mes-${message.senderId}');
                return _buildChatMessage(message.text,
                    message.senderId != widget.patientId, timestamp);
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
              // enabled: _botReplied, // Disable input if the bot hasn't replied
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

  Widget _buildDrawer() {
    return Drawer(
      backgroundColor: color3,
      child: Column(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: collaborateAppBarBgColor),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    'Koushik',
                    style: GoogleFonts.raleway(
                      color: color4,
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                GestureDetector(
                  child: const Icon(
                    Icons.more_horiz,
                    color: color4,
                  ),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) =>
                            SettingsScreen(patientId: widget.patientId),
                      ),
                    );
                  },
                )
              ],
            ),
          ),

          Center(
            child: Text(
              'Doctor Consultation Summaries',
              style: GoogleFonts.raleway(
                  color: collaborateAppBarBgColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 25),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          GestureDetector(
            onTap: () {
              // Navigate to a new screen with search functionality
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SearchScreen(
                      summaries: getDummySummaries(), role: 'PATIENT'),
                ),
              );
            },
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 8.0),
              height: 60,
              decoration: BoxDecoration(
                color: collaborateAppBarBgColor,
                borderRadius: BorderRadius.circular(30),
              ),
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.search, color: Colors.white),
                  SizedBox(width: 8.0),
                  Text(
                    'Search Doctor Summaries',
                    style: TextStyle(color: Colors.white, fontSize: 17),
                  ),
                ],
              ),
            ),
          ),

          Flexible(
            child: SummaryListWidget(
                summaries: getDummySummaries(), role: 'PATIENT'),
          )
          // Add more list items as needed
        ],
      ),
    );
  }

  List<Summary> getDummySummaries() {
    return [
      Summary(
        summaryId: '1',
        patientId: '123',
        doctorId: 'Doctor1',
        summaryText: 'This is the first summary text.',
        prescriptionId: 'Prescription1',
        timestamp: DateTime.now(),
      ),
      Summary(
        summaryId: '2',
        patientId: '123',
        doctorId: 'Doctor2',
        summaryText: 'This is the second summary text.',
        prescriptionId: 'Prescription2',
        timestamp: DateTime.now().subtract(const Duration(days: 1)),
      ),
      Summary(
        summaryId: '1',
        patientId: '123',
        doctorId: 'Doctor1',
        summaryText: 'This is the first summary text.',
        prescriptionId: 'Prescription1',
        timestamp: DateTime.now(),
      ),
      Summary(
        summaryId: '2',
        patientId: '123',
        doctorId: 'Doctor2',
        summaryText: 'This is the second summary text.',
        prescriptionId: 'Prescription2',
        timestamp: DateTime.now().subtract(const Duration(days: 1)),
      ),
      Summary(
        summaryId: '1',
        patientId: '123',
        doctorId: 'Doctor1',
        summaryText: 'This is the first summary text.',
        prescriptionId: 'Prescription1',
        timestamp: DateTime.now(),
      ),
      Summary(
        summaryId: '2',
        patientId: '123',
        doctorId: 'Doctor2',
        summaryText: 'This is the second summary text.',
        prescriptionId: 'Prescription2',
        timestamp: DateTime.now().subtract(const Duration(days: 1)),
      ),
      Summary(
        summaryId: '1',
        patientId: '123',
        doctorId: 'Doctor1',
        summaryText: 'This is the first summary text.',
        prescriptionId: 'Prescription1',
        timestamp: DateTime.now(),
      ),
      Summary(
        summaryId: '2',
        patientId: '123',
        doctorId: 'Doctor2',
        summaryText: 'This is the second summary text.',
        prescriptionId: 'Prescription2',
        timestamp: DateTime.now().subtract(const Duration(days: 1)),
      ),
      Summary(
        summaryId: '1',
        patientId: '123',
        doctorId: 'Doctor1',
        summaryText: 'This is the first summary text.',
        prescriptionId: 'Prescription1',
        timestamp: DateTime.now(),
      ),
      Summary(
        summaryId: '2',
        patientId: '123',
        doctorId: 'Doctor2',
        summaryText: 'This is the second summary text.',
        prescriptionId: 'Prescription2',
        timestamp: DateTime.now().subtract(const Duration(days: 1)),
      ),
      Summary(
        summaryId: '1',
        patientId: '123',
        doctorId: 'Doctor1',
        summaryText: 'This is the first summary text.',
        prescriptionId: 'Prescription1',
        timestamp: DateTime.now(),
      ),
      Summary(
        summaryId: '2',
        patientId: '123',
        doctorId: 'Doctor2',
        summaryText: 'This is the second summary text.',
        prescriptionId: 'Prescription2',
        timestamp: DateTime.now().subtract(const Duration(days: 1)),
      ),
      // Add more dummy summaries as needed
    ];
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

// void main() {
//   runApp(const MaterialApp(
//     home: ChatScreen(),
//   ));
// }
