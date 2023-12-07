import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:healthlink/models/patient_details.dart';
import 'package:healthlink/screens/form.dart';
import 'package:healthlink/utils/colors.dart';

class UserDetailsScreen extends StatelessWidget {
  final CustomForm user;

  const UserDetailsScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: collaborateAppBarBgColor,
        title: Text('${user.name} Details',
            style: GoogleFonts.raleway(color: color4)),
      ),
      backgroundColor: color3,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDetail('Name', user.getName),
              _buildDetail('Age', user.getAge.toString()),
              _buildDetail('Number', user.getNumber),
              _buildDetail('Gender', user.getGender),
              _buildDetail('Height', user.getHeight.toString()),
              _buildDetail('Weight', user.getWeight.toString()),
              _buildDetail('Medical Conditions', user.getMedicalConditions),
              _buildDetail('Medications', user.getMedications),
              // _buildDetail('Recent Surgery or Procedure',
              // user.getRecentSurgeryOrProcedure),
              _buildDetail('Allergies', user.getAllergies),
              _buildDetail('Smoking Frequency', user.getSmokingFrequency),
              _buildDetail('Drinking Frequency', user.getDrinkingFrequency),
              _buildDetail(
                  'Drugs Used and Frequency', user.getDrugsUsedAndFrequency),
              const SizedBox(height: 30),
              // Container(
              //   alignment: Alignment.bottomCenter,
              //   child: ElevatedButton(
              //     style: ElevatedButton.styleFrom(
              //       backgroundColor: collaborateAppBarBgColor,
              //       shape: RoundedRectangleBorder(
              //         borderRadius:
              //             BorderRadius.circular(20.0), // Rounded corners
              //       ),
              //     ),
              //     onPressed: () {
              //       print(user);
              //       Navigator.push(
              //         context,
              //         MaterialPageRoute(
              //           builder: (context) => MedicalInfoForm(customForm: user),
              //         ),
              //       );
              //     },
              //     child: Padding(
              //       padding: const EdgeInsets.all(8.0),
              //       child: Text(
              //         'Edit',
              //         style: GoogleFonts.raleway(
              //             color: color4,
              //             fontWeight: FontWeight.w400,
              //             fontSize: 25),
              //       ),
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetail(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.raleway(
              color: collaborateAppBarBgColor,
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4.0),
          Text(
            value ?? 'Not provided',
            style: const TextStyle(fontSize: 16.0),
          ),
        ],
      ),
    );
  }
}
