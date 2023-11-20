import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    home: HomeScreen(),
  ));
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue, // Replace with collaborateAppBarBgColor
        title: const Text('HealthLink'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add), // Replace with your add prescription icon
            onPressed: () {
              // Navigate to add prescription screen
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => AddPrescriptionScreen()),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.phone), // Replace with your phone call icon
            onPressed: () {
              // Navigate to phone call screen
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PhoneCallScreen()),
              );
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
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => PatientInfoScreen()),
                  );
                  break;
                case 'doctorInfo':
                  // Navigate to doctor info screen
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => DoctorInfoScreen()),
                  );
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
      body: Center(
        child: Text('Your content here'),
      ),
    );
  }
}

class AddPrescriptionScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Prescription'),
      ),
      body: Center(
        child: Text('Add Prescription Screen'),
      ),
    );
  }
}

class PhoneCallScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Phone Call'),
      ),
      body: Center(
        child: Text('Phone Call Screen'),
      ),
    );
  }
}

class PatientInfoScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Patient Info'),
      ),
      body: Center(
        child: Text('Patient Info Screen'),
      ),
    );
  }
}

class DoctorInfoScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Doctor Info'),
      ),
      body: Center(
        child: Text('Doctor Info Screen'),
      ),
    );
  }
}
