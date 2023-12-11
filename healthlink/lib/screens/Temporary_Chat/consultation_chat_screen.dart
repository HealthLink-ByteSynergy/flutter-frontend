// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:healthlink/Service/auth_service.dart';
import 'package:healthlink/Service/doctor_service.dart';
import 'package:healthlink/Service/message_service.dart';
import 'package:healthlink/Service/patient_service.dart';
import 'package:healthlink/models/Doctor.dart';
import 'package:healthlink/models/Message.dart';
import 'package:healthlink/models/Patient.dart';
import 'package:healthlink/models/Prescription.dart';
import 'package:healthlink/screens/Temporary_Chat/doctor_info.dart';
import 'package:healthlink/screens/Temporary_Chat/patient_info.dart';
import 'package:healthlink/screens/Temporary_Chat/prescription_screen.dart';
import 'package:healthlink/utils/colors.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';

class ConsultationChatScreen extends StatefulWidget {
  final bool isDoctor;
  final String patientId;
  final String doctorId;

  const ConsultationChatScreen(
      {Key? key,
      required this.isDoctor,
      required this.patientId,
      required this.doctorId})
      : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _ConsultationChatScreenState createState() => _ConsultationChatScreenState();
}

class _ConsultationChatScreenState extends State<ConsultationChatScreen> {
  late Prescription prescriptionTosave = Prescription(
    doctorId: '', // Default values or empty strings
    patientId: '',
    medicines: [],
    generalHabits: '',
  );

  final TextEditingController _messageController = TextEditingController();
  List<Message> messages = [];
  final MessageService _messageService = MessageService();
  bool _isInputEmpty = true;
  DateTime _lastUserMessageTime = DateTime.now();
  bool _botReplied = true; // Flag to track whether the bot has replied
  String currentUserId = "";
  Patient? patient;
  Doctor? doctor;

  @override
  void initState() {
    super.initState();
    setState(() {
      prescriptionTosave.doctorId = widget.doctorId;
      prescriptionTosave.medicines = [];
      prescriptionTosave.generalHabits = '';
      prescriptionTosave.patientId = widget.patientId;
    });
    _setCurrentUserId();
    _fetchPatientDetails();
    _fetchDoctorDetails();
    // _fetchMessages();
  }

  void _setCurrentUserId() async {
    try {
      String? userId = await AuthService().getUserId();
      setState(() {
        if (userId != null) {
          currentUserId = userId;
        }
        // print('entered');
      });
    } catch (e) {
      // Handle exceptions during data fetch
      // print('Error fetching patient data: $e');
    }
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
    String id =
        this.widget.isDoctor ? this.widget.doctorId : this.widget.patientId;
    try {
      List<Message>? fetchedMessages =
          await _messageService.getMessagesFromBot(id);

      if (fetchedMessages != null) {
        setState(() {
          messages = fetchedMessages;
        });
      }
    } catch (e) {
      print('Error fetching messages: $e');
    }
  }

  void _sendMessage(String text) async {
    String senId = this.widget.isDoctor
        ? this.widget.doctorId ?? 'n/a'
        : this.widget.patientId ?? 'n/a';
    String recId = !this.widget.isDoctor
        ? this.widget.doctorId ?? 'n/a'
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
                  // Perform exit chat action
                  // For example, pop back to previous screens or close the chat
                  // _exitChat()
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
              itemCount: messages.length, // Use the messages list length
              itemBuilder: (BuildContext context, int index) {
                Message message =
                    messages[index]; // Get the message at this index
                String timestampString = message.timestamp;

                DateTime timestamp = DateTime.parse(timestampString);
                // Build the chat message using the actual message object
                // print(DateTime.now());
                return _buildChatMessage(message.text,
                    message.senderId == widget.patientId, timestamp);
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

  // void _sendMessage(String text) {
  //   setState(() {
  //     _isInputEmpty = true;
  //     _botReplied = false; // User has sent a message, waiting for bot reply
  //   });
  //   _messageController.clear();

  //   // Simulate bot's reply after a delay (you can replace this with actual logic)
  //   Future.delayed(const Duration(seconds: 2), () {
  //     setState(() {
  //       _botReplied = true; // Bot has replied, enable input and send button
  //     });
  //     // Simulate displaying bot's reply
  //     _buildChatMessage('Bot reply', false, DateTime.now());
  //   });
  // }
}

void main() {
  runApp(const MaterialApp(
    home: ConsultationChatScreen(
      isDoctor: true,
      patientId: "018c536f-fc98-71cc-bd79-b58ca17ffa35",
      doctorId: "018c54de-8da5-744f-93ce-f4aef174df08",
    ),
  ));
}
