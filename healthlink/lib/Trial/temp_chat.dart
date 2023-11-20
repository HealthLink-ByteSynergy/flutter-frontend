import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: TemporaryChatScreen(
        doctorId: 'doctor123', // Replace with actual doctor ID
        patientId: 'patient456', // Replace with actual patient ID
        isDoctor: true, // Replace with actual user role (true if doctor)
      ),
    );
  }
}

class TemporaryChatScreen extends StatelessWidget {
  final String doctorId;
  final String patientId;
  final bool isDoctor;

  TemporaryChatScreen({
    required this.doctorId,
    required this.patientId,
    required this.isDoctor,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat'),
        actions: [
          IconButton(
            icon: Icon(Icons.call),
            onPressed: () {
              _makeCall();
            },
          ),
          // ... other icons and menu
        ],
      ),
      body: Center(
        child: Text('Chat Screen Content'),
      ),
    );
  }

  void _makeCall() {
    final recipientId = isDoctor ? patientId : doctorId;
    print('Calling $recipientId...');
    // Implement the calling functionality using the recipient ID
  }
}
