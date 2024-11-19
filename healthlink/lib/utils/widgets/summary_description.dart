// ignore_for_file: prefer_const_constructors

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:healthlink/models/DetailedSummary.dart';
import 'package:healthlink/Service/summary_service.dart'; // Import your service class here
import 'package:healthlink/models/Medicine.dart';
import 'package:healthlink/utils/colors.dart';
import 'package:intl/intl.dart';

class SummaryDetailsScreen extends StatefulWidget {
  final DetailedSummary summary;

  const SummaryDetailsScreen({Key? key, required this.summary})
      : super(key: key);

  @override
  _SummaryDetailsScreenState createState() => _SummaryDetailsScreenState();
}

class _SummaryDetailsScreenState extends State<SummaryDetailsScreen> {
  late List<Medicine> medicines = [];
  DetailedSummaryService _detailedSummaryService = new DetailedSummaryService();

  @override
  void initState() {
    super.initState();
    loadMedicines();
  }

  Future<void> loadMedicines() async {
    // Assume a function in SummaryService to fetch medicines based on the summary
    List<Medicine>? medicinesLoaded = await _detailedSummaryService
        .getMedicinesByMedicineId(widget.summary.prescription.medicineId);

    setState(() {
      if (medicinesLoaded != null) {
        medicines = medicinesLoaded;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: collaborateAppBarBgColor,
        title: Text(
          'Summary Details',
          style:
              GoogleFonts.raleway(color: color4, fontWeight: FontWeight.bold),
        ),
      ),
      backgroundColor: color3,
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Doctor: ${widget.summary.doctor.username}',
                style: GoogleFonts.raleway(
                    color: collaborateAppBarBgColor,
                    fontSize: 18,
                    fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Text(
                'Patient: ${widget.summary.patient.form?.name ?? widget.summary.patient.patientId}',
                style: GoogleFonts.raleway(
                    color: collaborateAppBarBgColor,
                    fontSize: 18,
                    fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Text(
                'Date: ${_formatDate(DateTime.parse(widget.summary.timestamp))}',
                style: GoogleFonts.raleway(
                    color: collaborateAppBarBgColor,
                    fontSize: 16,
                    fontWeight: FontWeight.bold)),
            SizedBox(height: 20),
            Text('Summary',
                style: GoogleFonts.raleway(
                    color: collaborateAppBarBgColor,
                    fontSize: 18,
                    fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Text(widget.summary.text,
                style: GoogleFonts.raleway(
                    color: collaborateAppBarBgColor, fontSize: 16)),
            SizedBox(height: 20),
            ...[
              Text('Prescription',
                  style: GoogleFonts.raleway(
                      color: collaborateAppBarBgColor,
                      fontSize: 18,
                      fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
            ],
            // Existing code remains the same
            if (medicines.isNotEmpty) ...[
              Text('Medicine',
                  style: GoogleFonts.raleway(
                      color: collaborateAppBarBgColor,
                      fontSize: 16,
                      fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
              ListView.builder(
                shrinkWrap: true,
                itemCount: medicines.length,
                itemBuilder: (context, index) {
                  final medicine = medicines[index];
                  return ListTile(
                    title: Text('${medicine.name} - ${medicine.dosage}'),
                    subtitle: Text('Frequency: ${medicine.frequency}'),
                  );
                },
              ),
              SizedBox(height: 20),
            ],
            if (widget.summary.prescription.generalHabits != "N/A") ...[
              Text('General Habits',
                  style: GoogleFonts.raleway(
                      color: collaborateAppBarBgColor,
                      fontSize: 16,
                      fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
              Text(widget.summary.prescription.generalHabits,
                  style: GoogleFonts.raleway(
                      color: collaborateAppBarBgColor, fontSize: 16)),
              SizedBox(height: 20),
            ],
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime timestamp) {
    // Format the timestamp to display the date
    final formatter = DateFormat('dd MMMM yyyy');
    return formatter.format(timestamp);
  }
}


// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:healthlink/models/DetailedSummary.dart';
// import 'package:healthlink/utils/colors.dart';
// import 'package:intl/intl.dart';

// class SummaryDetailsScreen extends StatelessWidget {
//   final DetailedSummary summary;

//   const SummaryDetailsScreen({super.key, required this.summary});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: collaborateAppBarBgColor,
//         title: Text(
//           'Summary Details',
//           style:
//               GoogleFonts.raleway(color: color4, fontWeight: FontWeight.bold),
//         ),
//       ),
//       backgroundColor: color3,
//       body: SingleChildScrollView(
//         padding: EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text('Doctor: ${summary.doctor}',
//                 style: GoogleFonts.raleway(
//                     color: collaborateAppBarBgColor,
//                     fontSize: 18,
//                     fontWeight: FontWeight.bold)),
//             SizedBox(height: 10),
//             Text('Patient: ${summary.patient}',
//                 style: GoogleFonts.raleway(
//                     color: collaborateAppBarBgColor,
//                     fontSize: 18,
//                     fontWeight: FontWeight.bold)),
//             SizedBox(height: 10),
//             Text('Date: ${_formatDate(DateTime.parse(summary.timestamp))}',
//                 style: GoogleFonts.raleway(
//                     color: collaborateAppBarBgColor,
//                     fontSize: 16,
//                     fontWeight: FontWeight.bold)),
//             SizedBox(height: 20),
//             Text('Summary',
//                 style: GoogleFonts.raleway(
//                     color: collaborateAppBarBgColor,
//                     fontSize: 18,
//                     fontWeight: FontWeight.bold)),
//             SizedBox(height: 10),
//             Text(summary.text,
//                 style: GoogleFonts.raleway(
//                     color: collaborateAppBarBgColor, fontSize: 16)),
//             SizedBox(height: 20),
//             ...[
//               Text('Prescription',
//                   style: GoogleFonts.raleway(
//                       color: collaborateAppBarBgColor,
//                       fontSize: 18,
//                       fontWeight: FontWeight.bold)),
//               SizedBox(height: 10),
//               if (summary.prescription.medicines.isNotEmpty) ...[
//                 Text('Medicine',
//                     style: GoogleFonts.raleway(
//                         color: collaborateAppBarBgColor,
//                         fontSize: 16,
//                         fontWeight: FontWeight.bold)),
//                 SizedBox(height: 10),
//                 ListView.builder(
//                   shrinkWrap: true,
//                   itemCount: summary.prescription.medicines.length,
//                   itemBuilder: (context, index) {
//                     final medicine = summary.prescription.medicines[index];
//                     return ListTile(
//                       title: Text('${medicine.name} - ${medicine.dosage}'),
//                       subtitle: Text('Frequency: ${medicine.frequency}'),
//                     );
//                   },
//                 ),
//                 SizedBox(height: 20),
//               ],
//               if (summary.prescription.generalHabits.isNotEmpty) ...[
//                 Text('General Habits',
//                     style: GoogleFonts.raleway(
//                         color: collaborateAppBarBgColor,
//                         fontSize: 16,
//                         fontWeight: FontWeight.bold)),
//                 SizedBox(height: 10),
//                 Text(summary.prescription.generalHabits,
//                     style: GoogleFonts.raleway(
//                         color: collaborateAppBarBgColor, fontSize: 16)),
//                 SizedBox(height: 20),
//               ],
//             ],
//           ],
//         ),
//       ),
//     );
//   }

  // String _formatDate(DateTime timestamp) {
  //   // Format the timestamp to display the date
  //   final formatter = DateFormat('dd MMMM yyyy');
  //   return formatter.format(timestamp);
  // }
// }
