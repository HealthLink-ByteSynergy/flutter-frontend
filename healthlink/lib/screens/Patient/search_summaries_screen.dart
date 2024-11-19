import 'package:flutter/material.dart';
import 'package:healthlink/Service/summary_service.dart';
import 'package:healthlink/models/DetailedSummary.dart';
import 'package:healthlink/models/Summary.dart'; // Import your service class here
import 'package:healthlink/utils/colors.dart';
import 'package:healthlink/utils/widgets/summary_list.dart';
import 'package:healthlink/utils/widgets/summary_list_screen.dart';

class SearchScreen extends StatefulWidget {
  final String role;
  final String id; // Add this line for the ID

  const SearchScreen({Key? key, required this.role, required this.id})
      : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late List<DetailedSummary> filteredSummaries;
  late List<DetailedSummary> allSummaries;
  late TextEditingController searchController;
  DetailedSummaryService _detailedSummaryService = new DetailedSummaryService();

  @override
  void initState() {
    super.initState();
    filteredSummaries = [];
    searchController = TextEditingController();
    loadSummaries();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
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
        filteredSummaries = newSummaries;
        allSummaries = newSummaries;
      }
    });
  }

  void _filterSummaries(String searchText) {
    if (widget.role == "DOCTOR") {
      setState(() {
        filteredSummaries = allSummaries
            .where((summary) =>
                summary.patient.form!.name!
                    .toLowerCase()
                    .contains(searchText.toLowerCase()) ||
                summary.timestamp
                    .toString()
                    .toLowerCase()
                    .contains(searchText.toLowerCase()))
            .toList();
      });
    } else {
      setState(() {
        filteredSummaries = allSummaries
            .where((summary) =>
                summary.doctor.username
                    .toLowerCase()
                    .contains(searchText.toLowerCase()) ||
                summary.timestamp
                    .toString()
                    .toLowerCase()
                    .contains(searchText.toLowerCase()))
            .toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: color3,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: collaborateAppBarBgColor),
        backgroundColor: color3,
        title: Container(
          decoration: BoxDecoration(
            color: collaborateAppBarBgColor,
            borderRadius: BorderRadius.circular(30),
          ),
          child: TextField(
            controller: searchController,
            onChanged: _filterSummaries,
            style: const TextStyle(color: color2),
            decoration: InputDecoration(
              hintText: 'Search Summaries',
              hintStyle: const TextStyle(
                color: color4,
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.only(left: 30, top: 15),
              prefixIcon: const Icon(Icons.search, color: color4),
              suffixIcon: IconButton(
                icon: const Icon(Icons.clear, color: color4),
                onPressed: () {
                  searchController.clear();
                  _filterSummaries('');
                },
              ),
            ),
          ),
        ),
      ),
      body: SummaryListWidget(summaries: filteredSummaries, role: widget.role),
    );
  }
}



// import 'package:flutter/material.dart';
// import 'package:healthlink/models/DetailedSummary.dart';
// import 'package:healthlink/models/Summary.dart';
// import 'package:healthlink/utils/colors.dart';
// import 'package:healthlink/utils/widgets/summary_list.dart';

// class SearchScreen extends StatefulWidget {
//   final List<DetailedSummary> summaries;
//   final String role;

//   const SearchScreen({super.key, required this.summaries, required this.role});

//   @override
//   _SearchScreenState createState() => _SearchScreenState();
// }

// class _SearchScreenState extends State<SearchScreen> {
//   late List<DetailedSummary> filteredSummaries;
//   late TextEditingController searchController; // Add this line

//   @override
//   void initState() {
//     super.initState();
//     filteredSummaries = List.from(widget.summaries);
//     searchController = TextEditingController();
//   }

//   @override
//   void dispose() {
//     searchController.dispose(); // Dispose of the controller when done
//     super.dispose();
//   }

//   void _filterSummaries(String searchText) {
//     setState(() {
//       filteredSummaries = widget.summaries
//           .where((summary) =>
//               summary.doctor.doctorId
//                   .toLowerCase()
//                   .contains(searchText.toLowerCase()) ||
//               summary.timestamp
//                   .toString()
//                   .toLowerCase()
//                   .contains(searchText.toLowerCase()))
//           .toList();
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         backgroundColor: color3,
//         appBar: AppBar(
//           iconTheme: const IconThemeData(color: collaborateAppBarBgColor),
//           backgroundColor: color3,
//           title: Container(
//             decoration: BoxDecoration(
//               color: color2, // Background color
//               borderRadius: BorderRadius.circular(30), // Rounded corners
//             ),
//             child: TextField(
//               controller: searchController,
//               onChanged: _filterSummaries,
//               style: const TextStyle(
//                   color: collaborateAppBarBgColor), // Text color
//               decoration: InputDecoration(
//                 hintText: 'Search Summaries',
//                 hintStyle: const TextStyle(
//                   color: color4,
//                 ), // Hint text color
//                 border: InputBorder.none,
//                 contentPadding: const EdgeInsets.only(left: 30, top: 15),
//                 prefixIcon:
//                     const Icon(Icons.search, color: collaborateAppBarBgColor),
//                 // contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
//                 suffixIcon: IconButton(
//                   icon:
//                       const Icon(Icons.clear, color: collaborateAppBarBgColor),
//                   onPressed: () {
//                     // Clear the search text and reset the list
//                     searchController.clear();
//                     _filterSummaries('');
//                   },
//                 ),
//               ),
//             ),
//           ),
//         ),
//         body:
//             SummaryListWidget(summaries: filteredSummaries, role: widget.role));
//   }
// }
