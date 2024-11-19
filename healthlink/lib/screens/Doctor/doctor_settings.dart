import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:healthlink/Service/auth_service.dart';
import 'package:healthlink/Service/doctor_service.dart';
import 'package:healthlink/Service/patient_service.dart';
import 'package:healthlink/models/Doctor.dart';
import 'package:healthlink/models/Patient.dart';
import 'package:healthlink/models/patient_details.dart';
import 'package:healthlink/screens/Patient/patient_details_screen.dart';
import 'package:healthlink/utils/colors.dart';

class DoctorSettingsScreen extends StatefulWidget {
  final String doctorId;

  DoctorSettingsScreen({Key? key, required this.doctorId}) : super(key: key);

  @override
  _DoctorSettingsScreenState createState() => _DoctorSettingsScreenState();
}

class _DoctorSettingsScreenState extends State<DoctorSettingsScreen> {
  bool isAvailable = false; // Initially, the doctor is not available
  Doctor? doctorDetails; // Variable to store doctor details

  @override
  void initState() {
    super.initState();
    _fetchDoctorDetails(); // Fetch doctor details when the screen initializes
  }

  Future<void> _fetchDoctorDetails() async {
    try {
      final doctorService = DoctorService();
      Doctor? doctor = await doctorService.getDoctorById(widget.doctorId);
      if (doctor != null) {
        setState(() {
          doctorDetails = doctor;
          isAvailable = doctor.availability == "AVAILABLE" ? true : false;
        });
      }
    } catch (e) {
      print('Error fetching doctor details: $e');
      // Handle error scenarios as needed
    }
  }

  @override
  Widget build(BuildContext context) {
    // print("inside build");
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: color4),
        title: Text(
          'Settings',
          style:
              GoogleFonts.raleway(color: color4, fontWeight: FontWeight.bold),
        ),
        backgroundColor: collaborateAppBarBgColor,
      ),
      body: Container(
        color: color3,
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Display doctor's details if available
            if (doctorDetails != null) ...[
              ListTile(
                title: Text(
                  doctorDetails!.username ?? 'N/A',
                  style: GoogleFonts.raleway(
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                  ),
                ),
              ),
              _buildSubheading('Availability'),
              Switch(
                activeColor: collaborateAppBarBgColor,
                value: isAvailable,
                onChanged: (newValue) {
                  setState(() {
                    isAvailable = newValue;
                    doctorDetails!.availability =
                        isAvailable ? "AVAILABLE" : "BUSY";
                  });
                  print("in update change");
                  _updateDoctorAvailability(doctorDetails!);
                },
              ),
              const SizedBox(height: 10.0),
              _buildSubheading('Account'),
              ListTile(
                leading: const Icon(
                  Icons.email_outlined,
                  color: collaborateAppBarBgColor,
                ),
                title: Text(
                  'Email',
                  style: GoogleFonts.raleway(
                      color: collaborateAppBarBgColor,
                      fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                    doctorDetails!.email), // Replace '...' with actual email
              ),
              ListTile(
                leading: const Icon(
                  Icons.phone_outlined,
                  color: collaborateAppBarBgColor,
                ),
                title: Text(
                  'Phone Number',
                  style: GoogleFonts.raleway(
                      color: collaborateAppBarBgColor,
                      fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  doctorDetails!.phoneNumber ?? 'Not available',
                  // Replace '...' with the actual attribute for the phone number
                ),
              ),
              _buildSubheading('Professional Info'),
              ListTile(
                leading: const Icon(
                  Icons.description_outlined,
                  color: collaborateAppBarBgColor,
                ),
                title: Text(
                  'License Number',
                  style: GoogleFonts.raleway(
                      color: collaborateAppBarBgColor,
                      fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  doctorDetails!.licenseNumber ?? 'Not available',
                ),
              ),
              ListView.builder(
                shrinkWrap: true,
                itemCount: doctorDetails!.specializations.length - 1,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: Icon(
                      Icons.arrow_right,
                      color: collaborateAppBarBgColor,
                    ),
                    title: Text(
                      doctorDetails!.specializations[index],
                      style: GoogleFonts.raleway(
                        color: collaborateAppBarBgColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 10.0),
              _buildSubheading('Account Actions'),
              ListTile(
                title: const Text('Sign out'),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        backgroundColor: collaborateAppBarBgColor,
                        title: const Text(
                          'Sign out',
                          style: TextStyle(color: color4),
                        ),
                        content: const Text(
                            'Are you sure you want to sign out?',
                            style: TextStyle(color: color4)),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text(
                              'Cancel',
                              style: TextStyle(color: color4),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              signOut(context);
                            },
                            child: const Text(
                              'Sign out',
                              style: TextStyle(color: color4),
                            ),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ] else
              Center(child: CircularProgressIndicator()),
          ],
        ),
      ),
    );
  }

  void _updateDoctorAvailability(Doctor doctor) {
    final doctorService = DoctorService();
    doctorService.updateDoctor(doctor);
  }

  void signOut(BuildContext context) {
    AuthService().logout();

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
}
