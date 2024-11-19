import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:healthlink/Service/auth_service.dart';
import 'package:healthlink/Service/patient_service.dart';
import 'package:healthlink/models/Patient.dart';
import 'package:healthlink/models/patient_details.dart';
import 'package:healthlink/screens/Patient/patient_details_screen.dart';
import 'package:healthlink/utils/colors.dart';

class SettingsScreen extends StatelessWidget {
  final String patientId;

  SettingsScreen({Key? key, required this.patientId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Patient?>(
      future:
          _fetchPatientDetails(patientId), // Function to fetch patient details
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            appBar: AppBar(
              iconTheme: IconThemeData(color: Colors.white),
              backgroundColor: collaborateAppBarBgColor,
              title: Text(
                'HealthLink',
                style: GoogleFonts.raleway(
                    color: color3, fontWeight: FontWeight.bold),
              ),
            ),
            body: Center(
              child:
                  CircularProgressIndicator(), // Show loading indicator while fetching data
            ),
          );
        } else if (snapshot.hasError) {
          return Scaffold(
            appBar: AppBar(
                // Your app bar configuration
                ),
            body: Center(
              child:
                  Text('Error: ${snapshot.error}'), // Show error message if any
            ),
          );
        } else if (snapshot.hasData && snapshot.data != null) {
          Patient patientDetails = snapshot.data!;

          return Scaffold(
            appBar: AppBar(
              iconTheme: IconThemeData(color: Colors.white),
              backgroundColor: collaborateAppBarBgColor,
              title: Text(
                'HealthLink',
                style: GoogleFonts.raleway(
                    color: color4, fontWeight: FontWeight.bold),
              ),
              // Your app bar configuration
            ),
            backgroundColor: color3,
            body: ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                ListTile(
                  title: Text(
                    patientDetails.form?.getName ?? "N/A",
                    style: GoogleFonts.raleway(
                      color: collaborateAppBarBgColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                    ),
                  ),
                ),
                const SizedBox(height: 10.0),
                _buildSubheading('Account'),
                ListTile(
                  leading: const Icon(
                    Icons.call_outlined,
                    color: collaborateAppBarBgColor,
                  ),
                  title: Text(
                    'Phone Numbler',
                    style: GoogleFonts.raleway(
                        color: collaborateAppBarBgColor,
                        fontWeight: FontWeight.bold),
                  ),
                  subtitle:
                      Text(patientDetails.form?.number ?? "Not availabale"),
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
                        builder: (context) =>
                            UserDetailsScreen(patientId: patientId),
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
                          content:
                              const Text('Are you sure you want to sign out?'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () {
                                signOut(context);
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
        } else {
          return Scaffold(
            appBar: AppBar(
                // Your app bar configuration
                ),
            body: Center(
              child: Text('No data available'), // Show message if no data found
            ),
          );
        }
      },
    );
  }

  void signOut(BuildContext context) {
    // Call the sign-out method from AuthService
    AuthService().logout(); // Call the sign-out function

    // Remove all screens and navigate to login
    Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
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

  Future<Patient?> _fetchPatientDetails(String patientId) async {
    try {
      final patientService = PatientService();
      Future<Patient?> patient = patientService.getPatientById(patientId);
      return patient;
    } catch (e) {
      throw Exception('Error fetching patient details: $e');
    }
  }
}
