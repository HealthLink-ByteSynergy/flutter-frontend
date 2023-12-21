// ignore_for_file: use_build_context_synchronously, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:healthlink/Service/consultation_service.dart';
import 'package:healthlink/Service/doctor_service.dart';
import 'package:healthlink/Service/message_service.dart';
import 'package:healthlink/Service/patient_service.dart';
import 'package:healthlink/models/ConsultationChat.dart';
import 'package:healthlink/models/DetailedSummary.dart';
import 'package:healthlink/models/Doctor.dart';
import 'package:healthlink/models/Medicine.dart';
import 'package:healthlink/models/Message.dart';
import 'package:healthlink/models/Patient.dart';
import 'package:healthlink/models/Prescription.dart';
// import 'package:healthlink/models/Summary.dart';
import 'package:healthlink/models/patient_details.dart';
import 'package:healthlink/screens/Patient/search_summaries_screen.dart';
import 'package:healthlink/screens/Patient/patient_settings.dart';
import 'package:healthlink/screens/Temporary_Chat/consultation_chat_screen.dart';
import 'package:healthlink/screens/Patient/home.dart';
import 'package:healthlink/utils/colors.dart';
import 'package:healthlink/utils/widgets/summary_list.dart';

class ChatScreen extends StatefulWidget {
  final String patientId;
  // final String patientUserId;

  const ChatScreen({Key? key, required this.patientId}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  List<Message> messages = [];
  final MessageService _messageService = MessageService();
  bool _isInputEmpty = true;
  DateTime _lastUserMessageTime = DateTime.now();
  bool _botReplied = true; // Flag to track whether the bot has replied
  bool isDoctorButtonVisible = true;
  Patient? patient;

  ConsultationChatService _consultationChatService =
      new ConsultationChatService();
  DoctorService _doctorService = new DoctorService();

  @override
  void initState() {
    super.initState();
    _fetchPatientDetails();
    _fetchMessages();
  }

  void _fetchPatientDetails() async {
    try {
      // String? userId = await AuthService().getUserId();
      Patient? fetchedPatient =
          await PatientService().getPatientById(this.widget.patientId);

      if (fetchedPatient != null) {
        setState(() {
          patient = fetchedPatient;
        });
      }
    } catch (e) {
      print('Error fetching patient details: $e');
    }
  }

  void _fetchMessages() async {
    try {
      List<Message>? fetchedMessages =
          await _messageService.getMessagesFromBot(widget.patientId);

      if (fetchedMessages != null) {
        setState(() {
          messages = fetchedMessages;
          _botReplied = true;
        });
      }
    } catch (e) {
      print('Error fetching messages: $e');
    }
  }

  void _sendMessage(String text) async {
    setState(() {
      _isInputEmpty = true;
      _botReplied = false; // User has sent a message, waiting for bot reply
    });
    _messageController.clear();
    Message newMessage = Message(
        messageId: "",
        previousMessageId: "",
        receiverId: "",
        messageType: "",
        text: text,
        senderId: widget.patientId,
        timestamp: DateTime.now().toString(),
        summary: text
        // Add other necessary properties for the message
        );

    if (messages.isNotEmpty) {
      newMessage.previousMessageId = messages[messages.length - 1].messageId;
    }

    // print(
    //     'patientId and sender id- ${newMessage.senderId == widget.patientId}}');

    setState(() {
      messages.add(newMessage);
      // print('sender id and patient id');
      // print(newMessage.senderId);
      // print('patientId');
      // print(widget.patientId);
    });

    try {
      Map<String, dynamic>? result =
          await _messageService.saveMessage(newMessage);

      if (result!['data'] == 'success') {
        _fetchMessages();
      }
    } catch (e) {
      print('Error sending message: $e');
    }

    _messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: color3,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: collaborateAppBarBgColor,
        title: Text(
          'HealthLink',
          style:
              GoogleFonts.raleway(color: color4, fontWeight: FontWeight.bold),
        ),
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu), // Icon that opens the drawer
            onPressed: () {
              // Open the drawer
              Scaffold.of(context).openDrawer();
            },
          ),
        ),
        actions: <Widget>[
          IconButton(
            onPressed: () =>
                Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) => HomeBody(),
            )),
            icon: Icon(Icons.home_filled),
            color: color4,
          ),
          Visibility(
            visible: true,
            child: TextButton(
              onPressed: () {
                _checkExistingChatAndShowDialog();
              },
              child: Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color4,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'Doctor',
                  style:
                      TextStyle(color: collaborateAppBarBgColor, fontSize: 20),
                ),
              ),
            ),
          ),
        ],
      ),
      drawer: _buildDrawer(),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(8.0),
              itemCount: messages.length, // Use the messages list length
              itemBuilder: (BuildContext context, int index) {
                Message message =
                    messages[index]; // Get the message at this index
                String timestampString = message.timestamp;

                DateTime timestamp = DateTime.parse(timestampString);
                // Build the chat message using the actual message object
                // print(DateTime.now());
                // print('pat-${widget.patientId}, mes-${message.senderId}');
                return _buildChatMessage(message.text,
                    message.senderId != widget.patientId, timestamp);
              },
            ),
          ),
          _buildInputField(),
        ],
      ),
    );
  }

  Widget _buildChatMessage(String message, bool isUser, DateTime messageTime) {
    // Check if the date has changed since the last message
    bool showDate = messageTime.day != _lastUserMessageTime.day ||
        messageTime.month != _lastUserMessageTime.month ||
        messageTime.year != _lastUserMessageTime.year;

    _lastUserMessageTime = messageTime; // Update the last user message time

    return Column(
      children: [
        if (showDate) _buildDateSeparator(messageTime),
        Align(
          alignment:
              isUser == false ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            margin: const EdgeInsets.all(8.0),
            padding: const EdgeInsets.all(12.0),
            constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.75),
            decoration: BoxDecoration(
              color: isUser == false ? collaborateAppBarBgColor : blackColor,
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: Text(
              message,
              style: GoogleFonts.raleway(
                  color: color4, fontSize: 15, fontWeight: FontWeight.w500),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInputField() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              autocorrect: true,
              cursorColor: color4,
              maxLines: null,
              onChanged: (text) {
                setState(() {
                  _isInputEmpty = text.isEmpty;
                });
              },
              decoration: InputDecoration(
                labelText: 'Message',
                counterStyle: const TextStyle(color: color4),
                labelStyle: const TextStyle(
                    color: color4), // Change to your preferred color
                filled: true,
                floatingLabelBehavior: FloatingLabelBehavior.never,
                fillColor: collaborateAppBarBgColor,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide:
                      const BorderSide(width: 0, style: BorderStyle.none),
                ),
              ),
              style: GoogleFonts.raleway(
                  color: color4, fontWeight: FontWeight.w500),
              keyboardType: TextInputType.text,
              // enabled: _botReplied, // Disable input if the bot hasn't replied
            ),
          ),
          const SizedBox(width: 8.0),
          _buildSendButton(),
        ],
      ),
    );
  }

  Widget _buildDateSeparator(DateTime messageTime) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        '${messageTime.day}/${messageTime.month}/${messageTime.year}',
        style: const TextStyle(color: blackColor),
      ),
    );
  }

  Widget _buildSendButton() {
    return GestureDetector(
      onTap: _isInputEmpty || !_botReplied
          ? null
          : () {
              _sendMessage(_messageController.text);
            },
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: _isInputEmpty || !_botReplied
              ? Colors.grey
              : collaborateAppBarBgColor,
        ),
        padding: const EdgeInsets.all(8.0),
        child: Icon(
          Icons.send,
          color: _isInputEmpty || !_botReplied ? color4 : color4,
          size: 35.0,
        ),
      ),
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      backgroundColor: color3,
      child: Column(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: collaborateAppBarBgColor),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    patient?.form?.name ?? 'N/A',
                    style: GoogleFonts.raleway(
                      color: color4,
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                GestureDetector(
                  child: const Icon(
                    Icons.more_horiz,
                    color: color4,
                  ),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) =>
                            SettingsScreen(patientId: widget.patientId),
                      ),
                    );
                  },
                )
              ],
            ),
          ),

          Center(
            child: Text(
              'Consultation Summaries',
              style: GoogleFonts.raleway(
                  color: collaborateAppBarBgColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 30),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          GestureDetector(
            onTap: () {
              // Navigate to a new screen with search functionality
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      SearchScreen(id: widget.patientId, role: 'PATIENT'),
                ),
              );
            },
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 8.0),
              height: 60,
              decoration: BoxDecoration(
                color: collaborateAppBarBgColor,
                borderRadius: BorderRadius.circular(30),
              ),
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.search, color: Colors.white),
                  SizedBox(width: 8.0),
                  Text(
                    'Search Summaries',
                    style: TextStyle(color: Colors.white, fontSize: 17),
                  ),
                ],
              ),
            ),
          ),

          Flexible(
            child: SummaryListScreen(id: widget.patientId, role: 'PATIENT'),
          )
          // Add more list items as needed
        ],
      ),
    );
  }

  void _checkExistingChatAndShowDialog() async {
    List<ConsultationChat> consultationChats = await _consultationChatService
        .getConsultationChatByPatientId(widget.patientId);

    if (consultationChats.isEmpty) {
      print("hello");
      // If the list is empty, call the _showDoctorListDialog function
      _showDoctorListDialog();
    } else {
      // If the list is not empty, display the info about an existing chat
      ConsultationChat firstChat = consultationChats.first;
      Doctor? doctorDetails = await _doctorService
          .getDoctorByPatientId(firstChat.doctor.patientId ?? "N/A");
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: color3,
            title: Text('You already have an existing chat'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  title: Text(
                    // 'Vasistha',
                    '${doctorDetails?.username ?? "N/A"}',
                    style: GoogleFonts.raleway(
                      color: collaborateAppBarBgColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    doctorDetails?.specializations.toString() ?? "N/A",
                    style: GoogleFonts.raleway(
                      color: collaborateAppBarBgColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  trailing: ElevatedButton(
                    onPressed: () {
                      _navigateToChatScreenWithDoctor(
                          doctorDetails?.doctorId ?? "N/A",
                          widget.patientId,
                          doctorDetails?.docPatientId ?? "N/A",
                          false);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: color4,
                    ),
                    child: Text(
                      'Join',
                      style: GoogleFonts.raleway(
                        color: collaborateAppBarBgColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () async {
                          bool quitSuccess = true;
                          // await ServiceClass().quitChat(firstChat.chatId);
                          if (quitSuccess) {
                            Navigator.of(context)
                                .pop(); // Close the current dialog
                            _showDoctorListDialog(); // Call the main function again
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                        ),
                        child: Text(
                          'Quit Chat',
                          style: GoogleFonts.raleway(color: blackColor),
                        ),
                      ),
                    ),
                    SizedBox(width: 20),
                    Expanded(
                      child: TextButton(
                        style:
                            TextButton.styleFrom(backgroundColor: blackColor),
                        onPressed: () {
                          Navigator.of(context)
                              .pop(); // Close the current dialog
                        },
                        child: Text(
                          'Close',
                          style: TextStyle(color: color4),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      );
    }
  }

  void _navigateToChatScreenWithDoctor(String doctorId, String patientId,
      String docPatientId, bool isNewChat) async {
    Map<String, dynamic> result = {};
    if (isNewChat) {
      result = await ConsultationChatService()
          .saveConsultationChat(docPatientId, patientId);
    }
    if (!isNewChat || result['success'] == true) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => ConsultationChatScreen(
            isDoctor: false,
            doctorId: doctorId,
            patientId: patientId,
            doctorPatientId: docPatientId,
          ),
        ),
      );
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Unable to Contact Doctor'),
            content: Text(
                'Sorry, we are unable to establish contact with the doctor at the moment.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  void _showDoctorListDialog() {
    String prevMessageId =
        messages.isNotEmpty ? messages[messages.length - 1].messageId : "";

    print(prevMessageId);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return FutureBuilder<List<Doctor>?>(
          future:
              MessageService().getDoctors(prevMessageId, this.widget.patientId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (snapshot.hasData && snapshot.data != null) {
              List<Doctor> doctors = snapshot.data!;
              print(doctors);
              if (doctors.isEmpty) {
                return _buildEmptyDoctorListDialog();
              } else {
                return _buildDoctorListDialog(doctors);
              }
            } else {
              return Center(child: Text('No data available'));
            }
          },
        );
      },
    );
  }

  Widget _buildEmptyDoctorListDialog() {
    return Dialog(
      backgroundColor: color3,
      child: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'No doctors available',
              style: GoogleFonts.raleway(
                color: collaborateAppBarBgColor,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            Container(
              alignment: Alignment.bottomRight,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                ),
                child: Text(
                  'Close',
                  style: GoogleFonts.raleway(
                    color: color4,
                    fontSize: 16,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildDoctorListDialog(List<Doctor> doctors) {
    return Dialog(
      backgroundColor: color3,
      child: Container(
        width: double.minPositive,
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.7,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: EdgeInsets.all(20),
              child: Text(
                'Select a Doctor',
                style: GoogleFonts.raleway(
                  color: collaborateAppBarBgColor,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ListView.builder(
              shrinkWrap: true,
              itemCount: doctors.length,
              itemBuilder: (BuildContext context, int index) {
                Doctor doctor = doctors[index];
                return ListTile(
                  title: Text(
                    doctor.username,
                    style: GoogleFonts.raleway(
                      color: collaborateAppBarBgColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    doctor.specializations.toString(),
                    style: GoogleFonts.raleway(
                      color: collaborateAppBarBgColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  trailing: ElevatedButton(
                    onPressed: () {
                      _navigateToChatScreenWithDoctor(doctor.doctorId,
                          this.widget.patientId, doctor.docPatientId, true);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: color4,
                    ),
                    child: Text(
                      'Join',
                      style: GoogleFonts.raleway(
                        color: collaborateAppBarBgColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                );
              },
            ),
            Container(
              padding: EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                ),
                child: Text(
                  'Close',
                  style: GoogleFonts.raleway(
                    color: color4,
                    fontSize: 16,
                  ),
                ),
              ),
              alignment: Alignment.bottomRight,
            )
          ],
        ),
      ),
    );
  }

  List<DetailedSummary> generateDummySummaries() {
    List<DetailedSummary> dummySummaries = [];

    for (int i = 0; i < 10; i++) {
      Doctor dummyDoctor = Doctor(
        doctorId: 'DoctorID$i',
        userId: 'UserID$i',
        specializations: ['Specialization $i'],
        docPatientId: 'doctorPatientId $i',
        availability: 'Available',
        phoneNumber: '123456789$i',
        licenseNumber: 'License$i',
        email: 'doctor$i@example.com',
        username: 'doctor_$i',
        password: 'password$i',
      );

      CustomForm dummyForm = CustomForm();
      dummyForm.setValues(
        'Patient Name $i',
        '$i',
        '123456789$i',
        '5\'10"',
        '150 lbs',
        'Some Medical Condition $i',
        'Medication $i',
        'Recent Surgery $i',
        'Allergy $i',
        'Smoking Frequency $i',
        'Drinking Frequency $i',
        'Drugs Usage $i',
      );

      Patient dummyPatient = Patient(
        patientId: 'PatientID$i',
        userId: 'UserID$i',
        form: dummyForm,
      );

      List<Medicine> dummyMedicines = [
        Medicine(
          id: 'Medicine Id $i',
          name: 'Medicine Name $i',
          dosage: 'Dosage $i',
          frequency: 'Frequency $i',
        ),
        // Add more Medicines if needed
      ];

      Prescription dummyPrescription = Prescription(
        medicineId: "MedicineId$i",
        prescriptionId: "PrescriptionId$i",
        doctorId: 'DoctorID$i',
        patientId: 'PatientID$i',
        medicines: dummyMedicines,
        generalHabits: 'General habits $i',
      );

      DetailedSummary dummySummary = DetailedSummary(
        doctor: dummyDoctor,
        patient: dummyPatient,
        prescription: dummyPrescription,
        text: 'Dummy text $i',
        timestamp: DateTime.now().toString(),
      );

      dummySummaries.add(dummySummary);
    }

    return dummySummaries;
  }
}

// void main() {
//   runApp(const MaterialApp(
//     home: ChatScreen(),
//   ));
// }
