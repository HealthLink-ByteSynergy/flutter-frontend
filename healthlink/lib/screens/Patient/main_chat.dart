import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:healthlink/models/summary.dart';
import 'package:healthlink/screens/Patient/doctor_summaries_screen.dart';
import 'package:healthlink/screens/Patient/patient_settings.dart';
import 'package:healthlink/utils/colors.dart';
import 'package:healthlink/utils/widgets/summary_list.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  bool _isInputEmpty = true;
  DateTime _lastUserMessageTime = DateTime.now();
  bool _botReplied = true; // Flag to track whether the bot has replied

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: color3,
      // ... (unchanged code)
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
      ),
      drawer: _buildDrawer(),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(8.0),
              children: [
                _buildChatMessage(
                    'Hello, how can I help?, Hello, how can I help?, Hello, how can I help?, Hello, how can I help?',
                    false,
                    DateTime.now()),
                _buildChatMessage('Hi there!', true, DateTime.now()),
                _buildChatMessage('Another user message', true,
                    DateTime.now().subtract(const Duration(days: 1))),
                // Add more messages as needed
              ],
            ),
          ),
          _buildInputField(),
        ],
      ),
    );
  }

  // ... (unchanged code)

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
          alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            margin: const EdgeInsets.all(8.0),
            padding: const EdgeInsets.all(12.0),
            constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.75),
            decoration: BoxDecoration(
              color: isUser ? collaborateAppBarBgColor : blackColor,
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

  Widget _buildDrawer() {
    return Drawer(
      backgroundColor: color3,
      child: Column(
        children: [
          DrawerHeader(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    'Ramsai Koushik Polisetti',
                    style: GoogleFonts.raleway(
                      color: collaborateAppBarBgColor,
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                GestureDetector(
                  child: const Icon(Icons.more_horiz),
                  onTap: () => Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => SettingsScreen(),
                  )),
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
                  builder: (context) =>
                      SearchScreen(summaries: getDummySummaries()),
                ),
              );
            },
            child: Container(
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
            child: SummaryListWidget(summaries: getDummySummaries()),
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

  void _sendMessage(String text) {
    setState(() {
      _isInputEmpty = true;
      _botReplied = false; // User has sent a message, waiting for bot reply
    });
    _messageController.clear();

    // Simulate bot's reply after a delay (you can replace this with actual logic)
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _botReplied = true; // Bot has replied, enable input and send button
      });
      // Simulate displaying bot's reply
      _buildChatMessage('Bot reply', false, DateTime.now());
    });
  }
}

void main() {
  runApp(const MaterialApp(
    home: ChatScreen(),
  ));
}
