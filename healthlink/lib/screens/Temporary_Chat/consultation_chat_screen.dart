// ignore_for_file: prefer_const_constructors
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:healthlink/Service/auth_service.dart';
import 'package:healthlink/Service/consultation_service.dart';
import 'package:healthlink/Service/doctor_service.dart';
import 'package:healthlink/Service/message_service.dart';
import 'package:healthlink/Service/patient_service.dart';
import 'package:healthlink/models/ConsultationChat.dart';
import 'package:healthlink/models/Doctor.dart';
import 'package:healthlink/models/Message.dart';
import 'package:healthlink/models/Patient.dart';
import 'package:healthlink/models/Prescription.dart';
import 'package:healthlink/screens/Doctor/DoctorScreen.dart';
import 'package:healthlink/screens/Patient/main_chat.dart';
import 'package:healthlink/screens/Temporary_Chat/doctor_info.dart';
import 'package:healthlink/screens/Temporary_Chat/patient_info.dart';
import 'package:healthlink/screens/Temporary_Chat/prescription_screen.dart';
import 'package:healthlink/utils/colors.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';

class ConsultationChatScreen extends StatefulWidget {
  final bool isDoctor;
  final String patientId;
  final String doctorId;
  final String doctorPatientId;

  const ConsultationChatScreen(
      {Key? key,
      required this.isDoctor,
      required this.patientId,
      required this.doctorId,
      required this.doctorPatientId})
      : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _ConsultationChatScreenState createState() => _ConsultationChatScreenState();
}

class _ConsultationChatScreenState extends State<ConsultationChatScreen> {
  late Prescription prescriptionTosave = Prescription(
    doctorId: this.widget.doctorId, // Default values or empty strings
    patientId: this.widget.patientId,
    medicines: [],
    generalHabits: '',
  );

  final TextEditingController _messageController = TextEditingController();
  List<Message> messages = [];
  final MessageService _messageService = MessageService();
  final ConsultationChatService _consultationChatService =
      ConsultationChatService();
  bool _isInputEmpty = true;
  DateTime prevMessageTimestamp = DateTime.now();
  bool _botReplied = true;
  Patient? patient;
  Doctor? doctor;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    setState(() {
      prescriptionTosave.doctorId = widget.doctorId;
      prescriptionTosave.medicines = [];
      prescriptionTosave.generalHabits = '';
      prescriptionTosave.patientId = widget.patientId;
    });
    _fetchPatientDetails();
    _fetchDoctorDetails();
    _timer = Timer.periodic(const Duration(seconds: 30), (Timer timer) {
      _fetchMessages();
      _fetchChatByDoctorIdAndPatientId();
    });
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
      print('Error fetching doctor details: $e');
    }
  }

  void _fetchDoctorDetails() async {
    try {
      final doctorService = DoctorService();
      // final userId = await AuthService().getUserId();
      Doctor? doctorRecieved =
          await doctorService.getDoctorById(this.widget.doctorId);
      if (doctorRecieved != null) {
        doctor = doctorRecieved;
      }
    } catch (e) {
      throw Exception('Error fetching patient details: $e');
    }
  }

  void _fetchMessages() async {
    try {
      List<Message>? fetchedMessages =
          await _messageService.getMessagesFromUser(
              this.widget.patientId, this.widget.doctorPatientId);

      print("completed");
      if (fetchedMessages != null &&
          fetchedMessages.length != messages.length) {
        setState(() {
          messages = fetchedMessages;
        });
      }
    } catch (e) {
      print('Error fetching messages: $e');
    }
  }

  void _fetchChatByDoctorIdAndPatientId() async {
    try {
      List<ConsultationChat> consultationChats = await _consultationChatService
          .getConsultationChatByDoctorIdAndPatientId(
              widget.doctorPatientId, widget.patientId);

      if (consultationChats.isEmpty) {
        String displayMessage = widget.isDoctor
            ? "${patient?.form?.name ?? "patient"} has quit the chat"
            : "${doctor?.username ?? "doctor"} has quit the chat";
        showCustomDialog(context, displayMessage);
      }
    } catch (e) {
      print('Error fetching chat: $e');
    }
  }

  void showCustomDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                widget.isDoctor
                    ? Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                DoctorScreen(doctorId: widget.doctorId)),
                      )
                    : Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                ChatScreen(patientId: widget.patientId)),
                      );
              },
              child: Text('Home'),
            ),
          ],
        );
      },
    );
  }

  void _sendMessage(String text) async {
    String senId = this.widget.isDoctor
        ? this.widget.doctorPatientId ?? 'n/a'
        : this.widget.patientId ?? 'n/a';
    String recId = !this.widget.isDoctor
        ? this.widget.doctorPatientId ?? 'n/a'
        : this.widget.patientId ?? 'n/a';
    setState(() {
      _isInputEmpty = true;
      _botReplied = true; // User has sent a message, waiting for bot reply
    });
    _messageController.clear();
    Message newMessage = Message(
        messageId: "",
        previousMessageId: "",
        receiverId: recId,
        messageType: "",
        text: text,
        senderId: senId,
        timestamp: DateTime.now().toString(),
        summary: text
        // Add other necessary properties for the message
        );

    if (messages.isNotEmpty) {
      newMessage.previousMessageId = messages[messages.length - 1].messageId;
    }

    setState(() {
      messages.add(newMessage);
    });

    try {
      Map<String, dynamic>? result =
          await _messageService.saveMessageToUser(newMessage);

      if (result!['data'] == 'success') {
        print("yes");
        _fetchMessages();
      } else {
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
        backgroundColor:
            collaborateAppBarBgColor, // Replace with collaborateAppBarBgColor
        title: Text(
          this.widget.isDoctor
              ? (patient?.form?.name ?? 'HealthLink')
              : (doctor?.username ?? 'HealthLink'),
          style: GoogleFonts.raleway(
              color: color4, fontWeight: FontWeight.bold, fontSize: 22),
        ),
        actions: <Widget>[
          this.widget.isDoctor
              ? IconButton(
                  icon: Icon(
                    Icons.description,
                    color: color4,
                  ),
                  onPressed: () async {
                    Prescription? prescription = await showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return PrescriptionScreen(
                          doctorId: widget.doctorId,
                          patientId: widget.patientId,
                          currentPrescription: prescriptionTosave,
                        );
                      },
                    );
                    if (prescription != null) {
                      prescriptionTosave = prescription;
                      print(prescriptionTosave.toString());
                    }
                  })
              : Container(),
          IconButton(
            icon: Icon(
              Icons.phone,
              color: color4,
            ),
            onPressed: () {
              String phoneNumber = this.widget.isDoctor
                  ? patient!.form!.number ?? '108'
                  : doctor!.phoneNumber ?? '108';
              FlutterPhoneDirectCaller.callNumber(phoneNumber);
            },
          ),
          PopupMenuButton<String>(
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              PopupMenuItem<String>(
                value: 'patientInfo',
                child: Text('Patient Info'),
              ),
              PopupMenuItem<String>(
                value: 'doctorInfo',
                child: Text('Doctor Info'),
              ),
              PopupMenuItem<String>(
                value: 'exitChat',
                child: Text('Exit Chat'),
              ),
            ],
            onSelected: (String value) {
              switch (value) {
                case 'patientInfo':
                  // Navigate to patient info screen
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => PatientDetailsScreen(
                              patientId: this.widget.patientId,
                            )),
                  );
                  break;
                case 'doctorInfo':
                  print("in doctorInfo case");
                  // Navigate to doctor info screen
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => DoctorDetailsScreen(
                              doctorId: this.widget.doctorId,
                            )),
                  );
                  break;
                case 'exitChat':
                  _handleExitChat();
                  break;
              }
            },
            offset: Offset(0, 56),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(8.0),
              itemCount: messages.length,
              itemBuilder: (BuildContext context, int index) {
                Message message = messages[index];
                String timestampString = message.timestamp;
                DateTime timestamp = DateTime.parse(timestampString);
                DateTime prevMessageTimestamp = DateTime.now();
                if (index != 0) {
                  prevMessageTimestamp =
                      DateTime.parse(messages[index - 1].timestamp);
                }
                return _buildChatMessage(
                    message.text,
                    message.senderId == widget.patientId && !widget.isDoctor ||
                        widget.isDoctor &&
                            message.senderId == doctor?.docPatientId,
                    timestamp,
                    index == 0,
                    prevMessageTimestamp);
              },
            ),
          ),
          _buildInputField(),
        ],
      ),
    );
  }

  Widget _buildChatMessage(String message, bool isDoctor, DateTime messageTime,
      bool isFirstMessage, DateTime prevMessageTimestamp) {
    // Check if the date has changed since the last message

    bool showDate = false;
    if (isFirstMessage) {
      showDate = true;
    } else {
      showDate = messageTime.day != prevMessageTimestamp.day ||
          messageTime.month != prevMessageTimestamp.month ||
          messageTime.year != prevMessageTimestamp.year;
    }

    return Column(
      children: [
        if (showDate) _buildDateSeparator(messageTime),
        Align(
          alignment:
              isDoctor == true ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            margin: const EdgeInsets.all(8.0),
            padding: const EdgeInsets.all(12.0),
            constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.75),
            decoration: BoxDecoration(
              color: isDoctor == false ? collaborateAppBarBgColor : blackColor,
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
              enabled: _botReplied, // Disable input if the bot hasn't replied
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

  void _handleExitChat() async {
    // Open a dialog box indicating processing
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Processing Exit Chat'),
          content: CircularProgressIndicator(), // Loading symbol
        );
      },
    );

    try {
      Map<String, dynamic>? deleteMessagesResults = await _messageService
          .deleteMessagesBetweenUsers(widget.patientId, widget.doctorPatientId);

      //pop the dialog box
      Navigator.of(context).pop();
      if (deleteMessagesResults != null &&
          deleteMessagesResults["data"] == "success") {
        !widget.isDoctor
            ? Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        ChatScreen(patientId: widget.patientId)),
              )
            : Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        DoctorScreen(doctorId: widget.doctorId)),
              );
      } else {
        // Handle unsuccessful exit process
        // Display an error message or take appropriate action
      }
    } catch (e) {
      // Handle exceptions during the exit process
      // Display an error message or take appropriate action
      print('Error during exit chat: $e');
      Navigator.of(context).pop();
    }
  }
}

void main() {
  runApp(const MaterialApp(
    home: ConsultationChatScreen(
      isDoctor: true,
      patientId: "018c7b2b-9ec6-71a8-af69-b76a0561ba6b",
      doctorId: "018c7b30-78a4-7cf2-8b0d-4dc8238f585d",
      doctorPatientId: "018c7b30-7883-7ed1-ab7c-42343d2c57df",
    ),
  ));
}
