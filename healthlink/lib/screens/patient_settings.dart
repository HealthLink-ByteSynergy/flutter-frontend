import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:healthlink/models/patient_details.dart';
import 'package:healthlink/screens/patient_details_screen.dart';
import 'package:healthlink/utils/colors.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Settings Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SettingsScreen(),
    );
  }
}

class SettingsScreen extends StatelessWidget {
  CustomForm dummyUser = CustomForm()
    ..setName = 'John Doe'
    ..setAge = 25
    ..setNumber = '1234567890'
    ..setGender = 'Male'
    ..setHeight = 175.0
    ..setWeight = 70.0
    ..setMedicalConditions = 'None'
    ..setMedications = 'Aspirin'
    ..setRecentSurgeryOrProcedure = 'Appendectomy'
    ..setAllergies = 'Pollen'
    ..setSmokingFrequency = 'Occasional'
    ..setDrinkingFrequency = 'Socially'
    ..setDoesUseDrugs = true
    ..setDrugsUsedAndFrequency = 'Marijuana - Occasionally';

  SettingsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: collaborateAppBarBgColor,
        title: Text(
          'Settings',
          style:
              GoogleFonts.raleway(color: color4, fontWeight: FontWeight.bold),
        ),
      ),
      backgroundColor: color3,
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          ListTile(
            title: Text('Patient Name',
                style: GoogleFonts.raleway(
                    color: collaborateAppBarBgColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 20)),
          ),
          const SizedBox(height: 10.0),
          _buildSubheading('Main Account'),
          ListTile(
            leading: const Icon(
              Icons.email_outlined,
              color: collaborateAppBarBgColor,
            ),
            title: Text(
              'Email',
              style: GoogleFonts.raleway(
                  color: collaborateAppBarBgColor, fontWeight: FontWeight.bold),
            ),
            subtitle: const Text(
                'koushikpolisetty@gmail.com'), // Replace '...' with actual email
          ),
          const SizedBox(height: 10.0),
          _buildSubheading('Patient Info'),
          ListTile(
            title: const Text('View User Details'),
            onTap: () {
              // Handle the click on 'View User Details'
              // For example, navigate to another screen or show a dialog
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => UserDetailsScreen(user: dummyUser),
                ),
              );
            },
          ),
          const SizedBox(height: 10.0),
          _buildSubheading('Account Actions'),
          ListTile(
            title: const Text('Sign Out'),
            onTap: () {
              // Handle the sign-out action
              // For example, show a confirmation dialog and sign out on confirmation
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Sign Out'),
                    content: const Text('Are you sure you want to sign out?'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () {
                          // Perform sign-out logic here
                          Navigator.of(context).pop(); // Close the dialog
                          // You can navigate to the login screen or perform any other necessary actions
                        },
                        child: const Text('Sign Out'),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSubheading(String text) {
    return Text(
      text,
      style: GoogleFonts.raleway(
        fontSize: 18.0,
        fontWeight: FontWeight.bold,
        color: collaborateAppBarBgColor,
      ),
    );
  }
}
