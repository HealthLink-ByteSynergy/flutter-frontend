import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:healthlink/screens/auth/signup_doctor.dart';
import 'package:healthlink/screens/auth/signup_patient.dart';
import 'package:healthlink/utils/colors.dart';

class Role extends StatelessWidget {
  const Role({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: collaborateAppBarBgColor,
      // appBar: AppBar(
      //   title: Text('Role Selection'),
      // ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(40),
                ),
                backgroundColor: blackColor,
              ),
              onPressed: () {
                // Navigate to PatientScreen
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const PatientSignupScreen()),
                );
              },
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Text(
                  'Patient',
                  style: GoogleFonts.raleway(
                      color: color4, fontWeight: FontWeight.bold, fontSize: 50),
                ),
              ),
            ),
            const SizedBox(height: 100),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: blackColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(40),
                ),
              ),
              onPressed: () {
                // Navigate to DoctorScreen
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const DoctorSignupScreen()),
                );
              },
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Text(
                  'Doctor',
                  style: GoogleFonts.raleway(
                      color: color4, fontWeight: FontWeight.bold, fontSize: 50),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
