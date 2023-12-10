import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:healthlink/Service/auth_service.dart';
import 'package:healthlink/Service/patient_service.dart';
import 'package:healthlink/Service/user_service.dart';
import 'package:healthlink/models/Patient.dart';
import 'package:healthlink/models/patient_details.dart';
import 'package:healthlink/screens/form.dart';
import 'package:healthlink/screens/Patient/main_chat.dart';
import 'package:healthlink/utils/colors.dart';

class HomeBody extends StatefulWidget {
  const HomeBody({super.key});

  @override
  _HomeBodyState createState() => _HomeBodyState();
}

class _HomeBodyState extends State<HomeBody> {
  final UserService _userService = UserService();
  List<Patient> chatList = []; // List to store patient information
  String patientUserId = "";

  @override
  void initState() {
    super.initState();
    fetchPatientData();
  }

  Future<void> fetchPatientData() async {
    try {
      String? userId = await AuthService().getUserId();
      List<Patient> patients =
          await PatientService().getPatientByUserId(userId!);

      setState(() {
        chatList = patients;
        patientUserId = userId;
        // print('entered');
      });
    } catch (e) {
      // Handle exceptions during data fetch
      // print('Error fetching patient data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: color3,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: collaborateAppBarBgColor,
        title: Text('HealthLink',
            style: GoogleFonts.raleway(
                color: color4, fontWeight: FontWeight.bold, fontSize: 30)),
      ), // App name
      body: chatList.isEmpty
          ? Padding(
              padding: const EdgeInsets.all(25.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  FutureBuilder<Map<String, dynamic>?>(
                    future: _userService.getUserDetails(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Text('Loading...'); // Placeholder while fetching
                      } else if (snapshot.hasData) {
                        return Text(
                          'Welcome, ${snapshot.data!["username"]}',
                          style: GoogleFonts.raleway(
                            color: collaborateAppBarBgColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 50,
                          ),
                          textAlign: TextAlign.center,
                        );
                      } else {
                        return Text(
                          'HealthLink', // Default text if username fetching fails
                          style: GoogleFonts.raleway(
                            color: color4,
                            fontWeight: FontWeight.bold,
                            fontSize: 50,
                          ),
                        );
                      }
                    },
                  ),
                  SizedBox(
                    height: 200,
                  ),
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
                            builder: (context) => MedicalInfoForm(
                                  customForm: CustomForm(),
                                  userId: patientUserId,
                                )),
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
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding:
                      const EdgeInsets.only(top: 10.0, left: 10.0, right: 2.0),
                  child: Text(
                    'Your Chats',
                    style: GoogleFonts.raleway(
                      color: blackColor,
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(
                  height: 25,
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 1.0),
                    child: ListView.builder(
                      itemCount: chatList.length,
                      itemBuilder: (context, index) {
                        return Container(
                          margin: EdgeInsets.all(10.0),
                          decoration: BoxDecoration(
                            color: color2,
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          child: ListTile(
                            title: Text(
                              chatList[index].form?.name ?? 'Loading',
                              style: GoogleFonts.raleway(
                                color: blackColor,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ChatScreen(
                                    patientId: chatList[index].patientId!,
                                    patientUserId: patientUserId,
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),

      floatingActionButton: chatList.isEmpty
          ? null // If chatList is empty, no FAB
          : SizedBox(
              width: 120,
              height: 60,
              child: FloatingActionButton.extended(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => MedicalInfoForm(
                              customForm: CustomForm(),
                              userId: patientUserId,
                            )),
                  );
                },
                label: Container(
                  padding:
                      EdgeInsets.symmetric(vertical: 12.0, horizontal: 100),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Text('Create Chat',
                        style: GoogleFonts.raleway(
                            color: color4,
                            fontWeight: FontWeight.bold,
                            fontSize: 15)),
                  ),
                ),
                backgroundColor: collaborateAppBarBgColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
              ),
            ),
    );
  }
}
