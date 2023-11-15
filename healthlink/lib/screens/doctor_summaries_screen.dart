import 'package:flutter/material.dart';
import 'package:healthlink/models/summary.dart';
import 'package:healthlink/utils/colors.dart';
import 'package:healthlink/utils/widgets/summary_list.dart';

class SearchScreen extends StatefulWidget {
  final List<Summary> summaries;

  SearchScreen({required this.summaries});

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late List<Summary> filteredSummaries;

  @override
  void initState() {
    super.initState();
    filteredSummaries = List.from(widget.summaries);
  }

  void _filterSummaries(String searchText) {
    setState(() {
      filteredSummaries = widget.summaries
          .where((summary) =>
              summary.doctorId
                  .toLowerCase()
                  .contains(searchText.toLowerCase()) ||
              summary.timestamp
                  .toString()
                  .toLowerCase()
                  .contains(searchText.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: color3,
        appBar: AppBar(
          iconTheme: IconThemeData(color: collaborateAppBarBgColor),
          backgroundColor: color3,
          title: Container(
            decoration: BoxDecoration(
              color: color2, // Background color
              borderRadius: BorderRadius.circular(30), // Rounded corners
            ),
            child: TextField(
              onChanged: _filterSummaries,
              style: TextStyle(color: collaborateAppBarBgColor), // Text color
              decoration: InputDecoration(
                hintText: 'Search Doctor Summaries',
                hintStyle: TextStyle(
                    color: collaborateAppBarBgColor), // Hint text color
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(left: 30, top: 15),
                prefixIcon: Icon(Icons.search, color: collaborateAppBarBgColor),
                // contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
                suffixIcon: IconButton(
                  icon: Icon(Icons.clear, color: collaborateAppBarBgColor),
                  onPressed: () {
                    // Clear the search text and reset the list
                    _filterSummaries('');
                  },
                ),
              ),
            ),
          ),
        ),
        body: SummaryListWidget(summaries: filteredSummaries));
  }
}
