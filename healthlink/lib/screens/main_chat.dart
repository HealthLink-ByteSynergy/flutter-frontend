import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:healthlink/utils/colors.dart';

class ChatScreen extends StatefulWidget {
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
        title: Text('HealthLink'),
        leading: IconButton(
          icon: Icon(Icons.menu), // Stylish looking icon for sidebar
          onPressed: () {
            // Handle sidebar button pressed
          },
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: EdgeInsets.all(8.0),
              children: [
                _buildChatMessage(
                    'Hello, how can I help?, Hello, how can I help?, Hello, how can I help?, Hello, how can I help?',
                    false,
                    DateTime.now()),
                _buildChatMessage('Hi there!', true, DateTime.now()),
                _buildChatMessage('Another user message', true,
                    DateTime.now().subtract(Duration(days: 1))),
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
            margin: EdgeInsets.all(8.0),
            padding: EdgeInsets.all(12.0),
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
                counterStyle: TextStyle(color: color4),
                labelStyle:
                    TextStyle(color: color4), // Change to your preferred color
                filled: true,
                floatingLabelBehavior: FloatingLabelBehavior.never,
                fillColor: collaborateAppBarBgColor,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: BorderSide(width: 0, style: BorderStyle.none),
                ),
              ),
              style: GoogleFonts.raleway(
                  color: color4, fontWeight: FontWeight.w500),
              keyboardType: TextInputType.text,
              enabled: _botReplied, // Disable input if the bot hasn't replied
            ),
          ),
          SizedBox(width: 8.0),
          _buildSendButton(),
        ],
      ),
    );
  }

  Widget _buildDateSeparator(DateTime messageTime) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        '${messageTime.day}/${messageTime.month}/${messageTime.year}',
        style: TextStyle(color: blackColor),
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
        padding: EdgeInsets.all(8.0),
        child: Icon(
          Icons.send,
          color: _isInputEmpty || !_botReplied ? color4 : color4,
          size: 35.0,
        ),
      ),
    );
  }

  void _sendMessage(String text) {
    setState(() {
      _isInputEmpty = true;
      _botReplied = false; // User has sent a message, waiting for bot reply
    });
    _messageController.clear();

    // Simulate bot's reply after a delay (you can replace this with actual logic)
    Future.delayed(Duration(seconds: 2), () {
      setState(() {
        _botReplied = true; // Bot has replied, enable input and send button
      });
      // Simulate displaying bot's reply
      _buildChatMessage('Bot reply', false, DateTime.now());
    });
  }
}
