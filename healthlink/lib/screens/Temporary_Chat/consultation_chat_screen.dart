// ignore_for_file: prefer_const_constructors
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:healthlink/Service/auth_service.dart';
import 'package:healthlink/Service/consultation_service.dart';
import 'package:healthlink/Service/doctor_service.dart';
import 'package:healthlink/Service/message_service.dart';
import 'package:healthlink/Service/patient_service.dart';
import 'package:healthlink/Service/summary_service.dart';
import 'package:healthlink/models/ConsultationChat.dart';
import 'package:healthlink/models/DetailedSummary.dart';
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
import 'package:url_launcher/link.dart';

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
    medicineId: "",
    prescriptionId: "",
    doctorId: this.widget.doctorId, // Default values or empty strings
    patientId: this.widget.patientId,
    medicines: [],
    generalHabits: "",
  );

  final TextEditingController _messageController = TextEditingController();
  List<Message> messages = [];
  final MessageService _messageService = MessageService();
  final ConsultationChatService _consultationChatService =
      ConsultationChatService();
  final DetailedSummaryService _detailedSummaryService =
      DetailedSummaryService();

  bool _isInputEmpty = true;
  DateTime prevMessageTimestamp = DateTime.now();
  bool _botReplied = true;
  Patient? patient;
  Doctor? doctor;
  late Timer _timer;
  bool isPatientExist = true;
  bool isDoctorExist = true;

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

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
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

      // print("completed");
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

      String displayMessage = widget.isDoctor
          ? "${patient?.form?.name ?? "patient"} has quit the chat"
          : "${doctor?.username ?? "doctor"} has quit the chat";
      if (consultationChats.isEmpty) {
        if (isDoctorExist && widget.isDoctor) {
          showCustomDialog(context, displayMessage);
        } else if (isPatientExist && !widget.isDoctor) {
          showCustomDialog(context, displayMessage);
        }
      }
    } catch (e) {
      print('Error fetching chat: $e');
    }
  }

  updateExistence(bool isDoctor) {
    if (isDoctor) {
      isDoctorExist = false;
    } else {
      isPatientExist = false;
    }
  }

  void showCustomDialog(BuildContext context, String message) {
    Future.delayed(Duration.zero, () {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(message),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  updateExistence(widget.isDoctor);
                  widget.isDoctor
                      ? Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                DoctorScreen(doctorId: widget.doctorId),
                          ),
                          (route) => false,
                        )
                      : Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                ChatScreen(patientId: widget.patientId),
                          ),
                          (route) => false,
                        );
                },
                child: Text('Home'),
              ),
            ],
          );
        },
      );
    });
  }

  void _sendMessage(String text, String type) async {
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
        messageType: type,
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
      Map<String, dynamic>? result;

      if (type == "CHAT") {
        result = await _messageService.saveMessageToUser(newMessage);
      } else if (type == "NOTIFICATION") {
        result = await _messageService.saveMeeting(newMessage);
      }

      if (result!['data'] == 'success') {
        // print("yes");
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
          IconButton(
            icon: Icon(
              Icons.video_call,
              color: color4,
            ),
            onPressed: () {
              _sendMessage("", "NOTIFICATION");
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
                print(message.messageType);
                if (message.messageType == "NOTIFICATION") {
                  return _buildMeetingMessage(
                      message.text,
                      message.senderId == widget.patientId &&
                              !widget.isDoctor ||
                          widget.isDoctor &&
                              message.senderId == doctor?.docPatientId,
                      timestamp,
                      index == 0,
                      prevMessageTimestamp,
                      message.senderId == doctor?.docPatientId);
                } else {
                  return _buildChatMessage(
                      message.text,
                      message.senderId == widget.patientId &&
                              !widget.isDoctor ||
                          widget.isDoctor &&
                              message.senderId == doctor?.docPatientId,
                      timestamp,
                      index == 0,
                      prevMessageTimestamp);
                }
              },
            ),
          ),
          _buildInputField(),
        ],
      ),
    );
  }

  Widget _buildMeetingMessage(String link, bool isDoctor, DateTime messageTime,
      bool isFirstMessage, DateTime prevMessageTimestamp, bool isInviteDoctor) {
    bool showDate = false;
    String invitor = isInviteDoctor
        ? doctor?.username ?? "doctor"
        : patient?.form?.name ?? "patient";
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
                maxHeight: 100,
                maxWidth: MediaQuery.of(context).size.width * 0.75),
            decoration: BoxDecoration(
              color: isDoctor == false ? collaborateAppBarBgColor : blackColor,
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: Column(
              children: [
                Text(
                  '$invitor is inviting you to a video call.',
                  style: GoogleFonts.raleway(
                      color: color4, fontSize: 15, fontWeight: FontWeight.w500),
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: Builder(
                      builder: (context) => Link(
                        uri: Uri.parse(link),
                        builder: (context, followLink) => ElevatedButton(
                          onPressed: followLink,
                          child: Text(
                            'Join',
                            style: GoogleFonts.raleway(
                                color: blackColor,
                                fontSize: 15,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
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
              _sendMessage(_messageController.text, 'CHAT');
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
      Doctor dummyDoctor = Doctor(
          doctorId: widget.doctorId,
          userId: "",
          docPatientId: "",
          specializations: [],
          availability: "BUSY",
          phoneNumber: "",
          licenseNumber: "",
          email: "",
          username: "",
          password: "");
      Patient dummyPatient = Patient(patientId: widget.doctorId, userId: "");
      if (prescriptionTosave == null) {
        print("yes");
      }
      print(prescriptionTosave.toString());
      DetailedSummary summaryTostore = DetailedSummary(
          doctor: doctor ?? dummyDoctor,
          patient: patient ?? dummyPatient,
          prescription: prescriptionTosave,
          text: "",
          timestamp: DateTime.now().toString());

      if (widget.isDoctor) {
        String saveSummaryResult =
            await _detailedSummaryService.saveSummary(summaryTostore);

        if (saveSummaryResult == "success") {
          Map<String, dynamic>? deleteMessagesResults =
              await _messageService.deleteMessagesBetweenUsers(
                  widget.patientId, widget.doctorPatientId);

          Map<String, dynamic>? deleteConsultationChatResults =
              await _consultationChatService.deleteConsultationChat(
                  widget.patientId, widget.doctorPatientId);

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) {
                // Call a function that displays the second dialog box
                showCustomDialog(context, "Processed Exit Chat");
                // Return a placeholder widget or the screen you want to display
                return Container(); // Replace with your screen/widget
              },
            ),
          );

          // Navigator.of(context).pop();
          // print(deleteMessagesResults);
          // print(deleteConsultationChatResults);
          if (widget.isDoctor) {
            isDoctorExist = false;
          } else {
            isPatientExist = false;
          }

          if (deleteMessagesResults != null &&
              deleteMessagesResults["data"] == "success" &&
              deleteConsultationChatResults['success'] == true) {
          } else {}
        } else {
          print(saveSummaryResult);
          Navigator.of(context).pop();
        }
      } else {
        Map<String, dynamic>? deleteConsultationChatResults =
            await _consultationChatService.deleteConsultationChat(
                widget.patientId, widget.doctorPatientId);

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) {
              // Call a function that displays the second dialog box
              showCustomDialog(context, "Processed Exit Chat");
              // Return a placeholder widget or the screen you want to display
              return Container(); // Replace with your screen/widget
            },
          ),
        );
      }
    } catch (e) {
      // Handle exceptions during the exit process
      // Display an error message
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
