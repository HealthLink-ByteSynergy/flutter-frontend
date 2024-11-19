import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:healthlink/Service/patient_service.dart';
import 'package:healthlink/models/Patient.dart';
import 'package:healthlink/models/patient_details.dart';
import 'package:healthlink/screens/Patient/form.dart';
import 'package:healthlink/utils/colors.dart';

class PatientDetailsScreen extends StatelessWidget {
  final String patientId;

  const PatientDetailsScreen({Key? key, required this.patientId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final PatientService patientService = PatientService();

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: collaborateAppBarBgColor,
        title: Text(
          'Patient Details',
          style: GoogleFonts.raleway(color: color4),
        ),
      ),
      backgroundColor: color3,
      body: FutureBuilder<Patient?>(
        future: patientService.getPatientById(patientId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            Patient? user = snapshot.data;
            return buildUserDetails(user!.form);
          } else {
            return Center(child: Text('No data available'));
          }
        },
      ),
    );
  }

  Widget buildUserDetails(CustomForm? user) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetail('Name', user?.getName),
            _buildDetail('Age', user?.getAge.toString()),
            _buildDetail('Number', user?.getNumber),
            _buildDetail('Gender', user?.getGender),
            _buildDetail('Height', user?.getHeight.toString()),
            _buildDetail('Weight', user?.getWeight.toString()),
            _buildDetail('Medical Conditions', user?.getMedicalConditions),
            _buildDetail('Medications', user?.getMedications),
            // _buildDetail('Recent Surgery or Procedure',
            //     user?.getRecentSurgeryOrProcedure),
            _buildDetail('Allergies', user?.getAllergies),
            _buildDetail('Smoking Frequency', user?.getSmokingFrequency),
            _buildDetail('Drinking Frequency', user?.getDrinkingFrequency),
            _buildDetail(
                'Drugs Used and Frequency', user?.getDrugsUsedAndFrequency),
            const SizedBox(height: 30),
          ],
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
