import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:healthlink/Service/patient_service.dart';
import 'package:healthlink/models/Patient.dart';
import 'package:healthlink/models/patient_details.dart';
import 'package:healthlink/screens/Patient/form.dart';
import 'package:healthlink/utils/colors.dart';
// import 'package:healthlink/services/user_service.dart'; // Import your UserService

class UserDetailsScreen extends StatefulWidget {
  final String patientId;

  const UserDetailsScreen({Key? key, required this.patientId})
      : super(key: key);

  @override
  _UserDetailsScreenState createState() => _UserDetailsScreenState();
}

class _UserDetailsScreenState extends State<UserDetailsScreen> {
  Patient? patient;

  @override
  void initState() {
    super.initState();
    _fetchUserDetails();
  }

  Future<void> _fetchUserDetails() async {
    PatientService patientService =
        PatientService(); // Replace with your UserService instance
    // Assuming userService.getUserDetailsById returns a CustomForm
    Patient? patientDetails =
        await patientService.getPatientById(widget.patientId);
    setState(() {
      patient = patientDetails;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (patient == null) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: color4),
        backgroundColor: collaborateAppBarBgColor,
        title: Text('${patient!.form!.name} Details',
            style: GoogleFonts.raleway(color: color4)),
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MedicalInfoForm(
                    customForm: patient!.form!,
                    userId: patient!.userId!,
                    isNewPatient: false,
                  ),
                ),
              );
            },
          ),
        ],
      ),
      backgroundColor: color3,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDetail('Name', patient!.form!.name),
              _buildDetail('Age', patient!.form!.age),
              _buildDetail('Number', patient!.form!.number),
              _buildDetail('Gender', patient!.form!.gender),
              _buildDetail('Height', patient!.form!.height),
              _buildDetail('Weight', patient!.form!.weight),
              _buildDetail(
                  'Medical Conditions', patient!.form!.medicalConditions),
              _buildDetail('Medications', patient!.form!.medications),
              // _buildDetail('Recent Surgery or Procedure',
              //     patient!.form!.recentSurgeryOrProcedure),
              _buildDetail('Allergies', patient!.form!.allergies),
              _buildDetail(
                  'Smoking Frequency', patient!.form!.smokingFrequency),
              _buildDetail(
                  'Drinking Frequency', patient!.form!.drinkingFrequency),
              _buildDetail('Drugs Used and Frequency',
                  patient!.form!.drugsUsedAndFrequency),
              const SizedBox(height: 30),
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



// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:healthlink/models/patient_details.dart';
// import 'package:healthlink/screens/Patient/form.dart';
// import 'package:healthlink/utils/colors.dart';

// class UserDetailsScreen extends StatelessWidget {
//   final CustomForm user;

//   const UserDetailsScreen({super.key, required this.user});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         iconTheme: IconThemeData(color: color4),
//         backgroundColor: collaborateAppBarBgColor,
//         title: Text('${user.name} Details',
//             style: GoogleFonts.raleway(color: color4)),
//         actions: [
//           IconButton(
//             icon: Icon(Icons.edit),
//             onPressed: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => MedicalInfoForm(
//                       customForm: user,
//                       userId: "userId",
//                       isNewPatient: false), // Replace with your edit screen
//                 ),
//               );
//             },
//           ),
//         ],
//       ),
//       backgroundColor: color3,
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: SingleChildScrollView(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               _buildDetail('Name', user.getName),
//               _buildDetail('Age', user.getAge.toString()),
//               _buildDetail('Number', user.getNumber),
//               _buildDetail('Gender', user.getGender),
//               _buildDetail('Height', user.getHeight.toString()),
//               _buildDetail('Weight', user.getWeight.toString()),
//               _buildDetail('Medical Conditions', user.getMedicalConditions),
//               _buildDetail('Medications', user.getMedications),
//               // _buildDetail('Recent Surgery or Procedure',
//               // user.getRecentSurgeryOrProcedure),
//               _buildDetail('Allergies', user.getAllergies),
//               _buildDetail('Smoking Frequency', user.getSmokingFrequency),
//               _buildDetail('Drinking Frequency', user.getDrinkingFrequency),
//               _buildDetail(
//                   'Drugs Used and Frequency', user.getDrugsUsedAndFrequency),
//               const SizedBox(height: 30),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildDetail(String label, String? value) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8.0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             label,
//             style: GoogleFonts.raleway(
//               color: collaborateAppBarBgColor,
//               fontSize: 18.0,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//           const SizedBox(height: 4.0),
//           Text(
//             value ?? 'Not provided',
//             style: const TextStyle(fontSize: 16.0),
//           ),
//         ],
//       ),
//     );
//   }
// }
