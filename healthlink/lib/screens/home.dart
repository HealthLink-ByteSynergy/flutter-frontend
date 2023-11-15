// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:healthlink/models/patient_details.dart';
import 'package:healthlink/screens/form.dart';
import 'package:healthlink/screens/auth/login.dart';
import 'package:healthlink/screens/main_chat.dart';
import 'package:healthlink/utils/colors.dart';

class ChatInfo {
  String patientName;
  String reason;

  ChatInfo({required this.patientName, required this.reason});
}

class ChatBox extends StatelessWidget {
  final ChatInfo chatInfo;

  ChatBox({required this.chatInfo});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Handle chat box click, navigate to chat screen
        // Navigator.push(context, MaterialPageRoute(builder: (context) => ChatScreen(chatInfo: chatInfo)));
      },
      child: Container(
        decoration: BoxDecoration(
          color:
              collaborateAppBarBgColor, // Fill the box with a light blue color
          border: Border.all(color: collaborateAppBarBgColor),
          borderRadius: BorderRadius.circular(25.0),
        ),
        // margin: EdgeInsets.all(2.0), // Add margin to the box
        padding: EdgeInsets.all(4.0),
        child: Center(
            child: Text(chatInfo.patientName,
                style: GoogleFonts.raleway(
                    color: color4, fontWeight: FontWeight.bold, fontSize: 25))),
      ),
    );
  }
}

class HomeBody extends StatefulWidget {
  final String jwtToken;
  HomeBody({required this.jwtToken});

  @override
  _HomeBodyState createState() => _HomeBodyState();
}

class _HomeBodyState extends State<HomeBody> {
  // ... other code ...

  ChatInfo a = ChatInfo(patientName: 'abcs', reason: 'physio');

  List<ChatInfo> chatList = []; // List to store chat information

  @override
  void initState() {
    super.initState();
    // Adding sample chat boxes to the chatList
    chatList.add(ChatInfo(patientName: 'John Doe', reason: 'Checkup'));
    chatList.add(ChatInfo(patientName: 'Jane Smith', reason: 'Prescription'));
    chatList.add(ChatInfo(patientName: 'Jane Smith', reason: 'Prescription'));
    chatList.add(ChatInfo(patientName: 'John Doe', reason: 'Checkup'));
    chatList.add(ChatInfo(patientName: 'Jane Smith', reason: 'Prescription'));
    chatList.add(ChatInfo(patientName: 'Jane Smith', reason: 'Prescription'));
    chatList.add(ChatInfo(patientName: 'John Doe', reason: 'Checkup'));
    chatList.add(ChatInfo(patientName: 'Jane Smith', reason: 'Prescription'));
    chatList.add(ChatInfo(patientName: 'Jane Smith', reason: 'Prescription'));
    chatList.add(ChatInfo(patientName: 'John Doe', reason: 'Checkup'));
    chatList.add(ChatInfo(patientName: 'Jane Smith', reason: 'Prescription'));
    chatList.add(ChatInfo(patientName: 'Jane Smith', reason: 'Prescription'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: color3,
      appBar: AppBar(
        backgroundColor: collaborateAppBarBgColor,
        title: Text('HealthLink',
            style: GoogleFonts.raleway(
                color: color4, fontWeight: FontWeight.bold, fontSize: 30)),
      ), // App name
      body: chatList.isEmpty
          ? Padding(
              padding: const EdgeInsets.all(25.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: Text(
                      'Please create a new chat window by clicking on the button below',
                      style: GoogleFonts.raleway(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 25,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(height: 20.0),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      fixedSize: Size(140, 50),
                      backgroundColor: collaborateAppBarBgColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                MedicalInfoForm(customForm: new CustomForm())),
                      );
                    },
                    child: Text(
                      'Create Chat',
                      style: GoogleFonts.raleway(
                        color: color4,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ],
              ),
            )
          : Padding(
              padding: const EdgeInsets.only(top: 10.0, left: 2.0, right: 2.0),
              child: ListView.builder(
                itemCount: chatList.length,
                itemBuilder: (context, index) {
                  return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 1.0),
                      child: Container(
                        decoration: BoxDecoration(
                            color: color2,
                            borderRadius: BorderRadius.circular(15.0)),
                        child: ListTile(
                          title: Text(
                            chatList[index].patientName,
                            style: GoogleFonts.raleway(
                                color: blackColor,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(chatList[index].reason,
                              style: GoogleFonts.raleway(
                                color: collaborateAppBarBgColor,
                                fontWeight: FontWeight.w400,
                                fontSize: 15,
                              )),
                          // Add other ListTile properties based on your ChatBox content
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ChatScreen()),
                            );
                            // Handle item tap if needed
                          },
                        ),
                      ));
                },
              ),
            ),

      floatingActionButton: chatList.isEmpty
          ? null // If chatList is empty, no FAB
          : Container(
              width: 100,
              height: 50,
              child: FloatingActionButton.extended(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            MedicalInfoForm(customForm: new CustomForm())),
                  );
                },
                label: Container(
                  padding:
                      EdgeInsets.symmetric(vertical: 12.0, horizontal: 20.0),
                  child: Text(' Create Chat ',
                      style: GoogleFonts.raleway(
                          color: color4,
                          fontWeight: FontWeight.bold,
                          fontSize: 15)),
                ),
                backgroundColor: collaborateAppBarBgColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
              ),
            ),
    );
  }
}

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Your App Title',
      theme: ThemeData(
          // Your theme settings
          ),
      home: HomeBody(jwtToken: 'yourToken'), // Use your HomeBody widget here
    );
  }
}
