import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:healthlink/models/Summary.dart';
import 'package:healthlink/sumtodetail.dart';
import 'package:healthlink/utils/colors.dart';
import 'package:healthlink/utils/widgets/summary_description.dart';

class SummaryListWidget extends StatelessWidget {
  final List<Summary> summaries;
  final String role;

  const SummaryListWidget(
      {super.key, required this.summaries, required this.role});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.only(top: 8.0),
      itemCount: summaries.length,
      itemBuilder: (context, index) {
        Summary summary = summaries[index];

        return Container(
          margin: const EdgeInsets.all(5),
          decoration: BoxDecoration(
              color: color2, borderRadius: BorderRadius.circular(20.0)),
          child: ListTile(
            title: role == 'PATIENT'
                ? Text(
                    'Doctor: ${summary.doctorId}',
                    style: GoogleFonts.raleway(
                        color: color4, fontWeight: FontWeight.bold),
                  )
                : Text(
                    'Patient: ${summary.patientId}',
                    style: GoogleFonts.raleway(
                        color: color4, fontWeight: FontWeight.bold),
                  ),
            subtitle: Text(
              'Consultation Date: ${summary.timestamp.day}-${summary.timestamp.month}-${summary.timestamp.year}',
              style: GoogleFonts.raleway(color: color4),
            ),
            // onTap: () {
            //   // Navigate to a new screen to display detailed summary information
            //   Navigator.push(
            //     context,
            //     MaterialPageRoute(
            //       builder: (context) => SummaryDetailsScreen(
            //           summary: generateDetailedSummary(summary)),
            //     ),
            //   );
            // },
          ),
        );
      },
    );
  }
}
