import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:healthlink/utils/colors.dart';

//this shows a dialog box with list of users, search on users is implemented
class MemberSelectionDialog extends StatefulWidget {
  List selectedSpecializations;
  Map<String, String> available;
  Map<String, String> displayMembers;

  // ignore: use_key_in_widget_constructors
  MemberSelectionDialog(
      {required this.selectedSpecializations,
      required this.available,
      required this.displayMembers});

  @override
  _MemberSelectionDialogState createState() => _MemberSelectionDialogState();
}

class _MemberSelectionDialogState extends State<MemberSelectionDialog> {
  late List initial_specializations;

  @override
  void initState() {
    super.initState();
    initial_specializations = widget.selectedSpecializations;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: collaborateAppBarBgColor,
      title: Text(
        'Select Members',
        style: GoogleFonts.raleway(color: color4),
      ),
      content: StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: TextField(
                    onChanged: filterMembers,
                    decoration: const InputDecoration(
                      labelText: 'Search Members',
                      prefixIcon: Icon(Icons.search),
                    ),
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: widget.displayMembers.keys.map((userId) {
                    String userName = widget.displayMembers[userId]!;

                    return CheckboxListTile(
                      value: widget.selectedSpecializations.contains(userName),
                      controlAffinity: ListTileControlAffinity.leading,
                      title: Text(userName,
                          style: GoogleFonts.raleway(color: color4)),
                      onChanged: (value) {
                        setState(() {
                          if (widget.selectedSpecializations
                              .contains(userName)) {
                            widget.selectedSpecializations.remove(userName);
                          } else {
                            widget.selectedSpecializations.add(userName);
                          }
                        });
                      },
                      activeColor: color4,
                      checkColor: collaborateAppBarBgColor,
                    );
                  }).toList(),
                ),
              ],
            ),
          );
        },
      ),
      actions: <Widget>[
        ElevatedButton(
          onPressed: () {
            widget.selectedSpecializations
                .removeWhere((spec) => !initial_specializations.contains(spec));
            print(initial_specializations);
            // print(widget.selectedSpecializations);

            Navigator.pop(context);
          },
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
          onPressed: () {
            Navigator.pop(context, widget.selectedSpecializations);
          },
          child: Text(
            'Submit',
            style: GoogleFonts.raleway(color: blackColor),
          ),
        ),
      ],
    );
  }

  void filterMembers(String query) {
    Map<String, String> filteredMembers = {};

    widget.available.forEach((userId, userName) {
      if (userName.toLowerCase().contains(query.toLowerCase())) {
        filteredMembers[userId] = userName;
      }
    });

    setState(() {
      widget.displayMembers = filteredMembers;
    });
  }
}
