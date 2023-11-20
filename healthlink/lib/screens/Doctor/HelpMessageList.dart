import 'package:flutter/material.dart';
import 'package:healthlink/screens/Doctor/HelpMessage.dart';

class HelpMessagesList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 10, // Number of help messages
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: HelpMessageWidget(),
        );
      },
    );
  }
}
