import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:healthlink/Service/doctor_service.dart';
import 'package:healthlink/models/Doctor.dart';
import 'package:healthlink/utils/colors.dart';

class DoctorDetailsScreen extends StatelessWidget {
  final String doctorId;

  const DoctorDetailsScreen({Key? key, required this.doctorId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final DoctorService doctorService = DoctorService();

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: collaborateAppBarBgColor,
        title: Text(
          'Doctor Details',
          style: GoogleFonts.raleway(color: color4),
        ),
      ),
      backgroundColor: color3,
      body: FutureBuilder<Doctor?>(
        future: doctorService.getDoctorById(doctorId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            Doctor? doctor = snapshot.data;
            return buildDoctorDetails(doctor);
          } else {
            return Center(child: Text('No data available'));
          }
        },
      ),
    );
  }

  Widget buildDoctorDetails(Doctor? doctor) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetail('Username', doctor?.username),
            _buildDetail('Email', doctor?.email),
            _buildDetail('Phone Number', doctor?.phoneNumber),
            _buildDetail('Specializations', doctor?.specializations.toString()),
            _buildDetail('License Number', doctor?.licenseNumber),
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
