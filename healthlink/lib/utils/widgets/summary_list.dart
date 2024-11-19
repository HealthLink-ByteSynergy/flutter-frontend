import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:healthlink/models/DetailedSummary.dart';
import 'package:healthlink/models/Summary.dart';
import 'package:healthlink/Service/summary_service.dart'; // Import your service class here
import 'package:healthlink/utils/colors.dart';
import 'package:healthlink/utils/widgets/summary_description.dart';

class SummaryListScreen extends StatefulWidget {
  final String role;
  final String id;

  const SummaryListScreen({Key? key, required this.role, required this.id})
      : super(key: key);

  @override
  _SummaryListScreenState createState() => _SummaryListScreenState();
}

class _SummaryListScreenState extends State<SummaryListScreen> {
  List<DetailedSummary> summaries = [];
  DetailedSummaryService _detailedSummaryService = new DetailedSummaryService();

  @override
  void initState() {
    super.initState();
    loadSummaries();
  }

  Future<void> loadSummaries() async {
    List<DetailedSummary>? newSummaries;
    if (widget.role == 'PATIENT') {
      newSummaries = await _detailedSummaryService
          .getDetailedSummariesByPatientId(widget.id);
    } else if (widget.role == 'DOCTOR') {
      newSummaries = await _detailedSummaryService
          .getDetailedSummariesByDoctorId(widget.id);
    }

    setState(() {
      if (newSummaries != null) {
        summaries = newSummaries;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    String roleInText = widget.role != "DOCTOR" ? "doctors" : "patients";
    return Scaffold(
      backgroundColor: color3,
      body: summaries.isEmpty
          ? Container(
              alignment: Alignment.center,
              padding: EdgeInsets.all(20.0),
              child: Text(
                "You have not had consultations with any $roleInText",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 30),
              ))
          : ListView.builder(
              padding: const EdgeInsets.only(top: 8.0),
              itemCount: summaries.length,
              itemBuilder: (context, index) {
                DetailedSummary summary = summaries[index];

                return Container(
                  margin: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      color: color2, borderRadius: BorderRadius.circular(20.0)),
                  child: ListTile(
                    title: widget.role == 'PATIENT'
                        ? Text(
                            'Doctor: ${summary.doctor.username}',
                            style: GoogleFonts.raleway(
                                color: color4, fontWeight: FontWeight.bold),
                          )
                        : Text(
                            'Patient: ${summary.patient.form?.name ?? summary.patient.patientId}',
                            style: GoogleFonts.raleway(
                                color: color4, fontWeight: FontWeight.bold),
                          ),
                    subtitle: Text(
                      'Consultation Date: ${DateTime.parse(summary.timestamp).day}-${DateTime.parse(summary.timestamp).month}-${DateTime.parse(summary.timestamp).year}',
                      style: GoogleFonts.raleway(color: color4),
                    ),
                    onTap: () {
                      // Navigate to a new screen to display detailed summary information
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              SummaryDetailsScreen(summary: summary),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}
