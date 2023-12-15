// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:healthlink/models/DetailedSummary.dart';
import 'package:healthlink/utils/colors.dart';
import 'package:intl/intl.dart';

class SummaryDetailsScreen extends StatelessWidget {
  final DetailedSummary summary;

  const SummaryDetailsScreen({super.key, required this.summary});

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
            Text('Doctor: ${summary.doctor}',
                style: GoogleFonts.raleway(
                    color: collaborateAppBarBgColor,
                    fontSize: 18,
                    fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Text('Patient: ${summary.patient}',
                style: GoogleFonts.raleway(
                    color: collaborateAppBarBgColor,
                    fontSize: 18,
                    fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Text('Date: ${_formatDate(DateTime.parse(summary.timestamp))}',
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
            Text(summary.text,
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
              if (summary.prescription.medicines.isNotEmpty) ...[
                Text('Medicine',
                    style: GoogleFonts.raleway(
                        color: collaborateAppBarBgColor,
                        fontSize: 16,
                        fontWeight: FontWeight.bold)),
                SizedBox(height: 10),
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: summary.prescription.medicines.length,
                  itemBuilder: (context, index) {
                    final medicine = summary.prescription.medicines[index];
                    return ListTile(
                      title: Text('${medicine.name} - ${medicine.dosage}'),
                      subtitle: Text('Frequency: ${medicine.frequency}'),
                    );
                  },
                ),
                SizedBox(height: 20),
              ],
              if (summary.prescription.generalHabits.isNotEmpty) ...[
                Text('General Habits',
                    style: GoogleFonts.raleway(
                        color: collaborateAppBarBgColor,
                        fontSize: 16,
                        fontWeight: FontWeight.bold)),
                SizedBox(height: 10),
                Text(summary.prescription.generalHabits,
                    style: GoogleFonts.raleway(
                        color: collaborateAppBarBgColor, fontSize: 16)),
                SizedBox(height: 20),
              ],
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
