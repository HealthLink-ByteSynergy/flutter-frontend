// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:healthlink/utils/colors.dart';

class HelpMessageWidget extends StatelessWidget {
  HelpMessageWidget({Key? key}) : super(key: key);

  void accept() {
    print('Accepted the help message!');
  }

  void reject() {
    print('Rejected the help message!');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 40),
      child: Card(
        color: collaborateAppBarBgColor,
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Container(
          padding: const EdgeInsets.all(16.0),
          // width: double.infinity,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'A patient needs your help...',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18.0,
                ),
              ),
              const SizedBox(height: 20.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: accept,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    child: Text('Accept'),
                  ),
                  ElevatedButton(
                    onPressed: reject,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    child: Text('Reject'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
