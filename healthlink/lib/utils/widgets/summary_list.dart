import 'package:flutter/material.dart';
import 'package:healthlink/models/Summary.dart';
import 'package:healthlink/sumtodetail.dart';
import 'package:healthlink/utils/colors.dart';
import 'package:healthlink/utils/widgets/summary_description.dart';

class SummaryListWidget extends StatelessWidget {
  final List<Summary> summaries;

  const SummaryListWidget({super.key, required this.summaries});

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
            title: Text('Doctor ID: ${summary.doctorId}'),
            subtitle: Text('Timestamp: ${summary.timestamp}'),
            onTap: () {
              // Navigate to a new screen to display detailed summary information
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SummaryDetailsScreen(
                      summary: generateDetailedSummary(summary)),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
