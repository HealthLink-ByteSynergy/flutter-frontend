// ignore_for_file: prefer_const_constructors

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:healthlink/Service/auth_service.dart';
import 'package:healthlink/Service/consultation_service.dart';
import 'package:healthlink/Service/doctor_service.dart';
import 'package:healthlink/Service/message_service.dart';
import 'package:healthlink/models/ConsultationChat.dart';
import 'package:healthlink/models/DetailedSummary.dart';
import 'package:healthlink/models/Doctor.dart';
import 'package:healthlink/models/Medicine.dart';
import 'package:healthlink/models/Message.dart';
import 'package:healthlink/models/Patient.dart';
import 'package:healthlink/models/Prescription.dart';
import 'package:healthlink/models/Summary.dart';
import 'package:healthlink/models/patient_details.dart';
import 'package:healthlink/screens/Doctor/doctor_settings.dart';
import 'package:healthlink/screens/Patient/search_summaries_screen.dart';
import 'package:healthlink/screens/Patient/patient_settings.dart';
import 'package:healthlink/screens/Temporary_Chat/consultation_chat_screen.dart';
import 'package:healthlink/utils/colors.dart';
import 'package:healthlink/utils/widgets/summary_list.dart';

class DoctorScreen extends StatefulWidget {
  final String doctorId;
  // final String doctorUserId;

  const DoctorScreen({Key? key, required this.doctorId}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _DoctorScreenState createState() => _DoctorScreenState();
}

class _DoctorScreenState extends State<DoctorScreen> {
  final TextEditingController _messageController = TextEditingController();
  List<Message> messages = [];
  final MessageService _messageService = MessageService();
  bool _isInputEmpty = true;
  DateTime _lastUserMessageTime = DateTime.now();
  bool _botReplied = true; // Flag to track whether the bot has replied
  Doctor? doctor;
  List<ConsultationChat> _consultationChats = [];

  ConsultationChatService _consultationChatService =
      new ConsultationChatService();

  List<String> patients = [
    'Patient 1',
    'Patient 2',
    'Patient 3',
    'Patient 4',
    'Patient 5',
  ];
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _fetchDoctorDetails();
    _fetchMessages();
    _fetchConsultationChats();

    _timer = Timer.periodic(const Duration(seconds: 30), (Timer timer) {
      _fetchConsultationChats();
    });
  }

  void _fetchConsultationChats() async {
    try {
      List<ConsultationChat> consultationChats = await _consultationChatService
          .getConsultationChatByDoctorId(doctor?.docPatientId ?? "N/A");

      if (consultationChats != _consultationChats) {
        setState(() {
          _consultationChats = consultationChats;
        });
      }
    } catch (e) {}
  }

  void _fetchDoctorDetails() async {
    try {
      // String? userId = await AuthService().getUserId();
      Doctor? fetchedDoctor = await DoctorService().getDoctorByUserId();

      if (fetchedDoctor != null) {
        setState(() {
          doctor = fetchedDoctor;
        });
      }
    } catch (e) {
      print('Error fetching doctor details: $e');
    }
  }

  void _fetchMessages() async {
    try {
      List<Message>? fetchedMessages =
          await _messageService.getMessagesFromBot(widget.doctorId);

      if (fetchedMessages != null) {
        setState(() {
          messages = fetchedMessages;
        });
      }
    } catch (e) {
      print('Error fetching messages: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: color3,
      appBar: AppBar(
        iconTheme: IconThemeData(color: color4),
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
      ),
      drawer: _buildDrawer(),
      body: _consultationChats.isEmpty
          ? Padding(
              padding: EdgeInsets.all(20.0), // Adjust the padding as needed
              child: Center(
                child: Text(
                  "There are no consultation requests",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: blackColor, fontSize: 30),
                ),
              ),
            )
          : ListView.builder(
              itemCount: _consultationChats.length,
              itemBuilder: (context, index) {
                return _buildPatientCard(_consultationChats[index].patient);
              },
            ),
    );
  }

  Widget _buildPatientCard(Patient patient) {
    return Card(
      color: collaborateAppBarBgColor,
      margin: EdgeInsets.all(8.0),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              "${patient.form!.name} needs your help!",
              style: TextStyle(
                  fontSize: 18.0, fontWeight: FontWeight.bold, color: color4),
            ),
            SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Navigate to chat screen with the patient
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => ConsultationChatScreen(
                            isDoctor: true,
                            patientId: patient.patientId ?? "N/A",
                            doctorId: this.widget.doctorId,
                            doctorPatientId: doctor?.docPatientId ?? "N/A"),
                      ),
                    );
                  },
                  child: Text(
                    'Join',
                    style: GoogleFonts.raleway(
                        color: collaborateAppBarBgColor,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                ElevatedButton(
                  onPressed: () async {
                    Map<String, dynamic> result =
                        await _consultationChatService.deleteConsultationChat(
                            doctor?.docPatientId ?? "N/A",
                            patient.patientId ?? "N/A");
                    if (result['success']) {
                      _fetchConsultationChats();
                    }
                  },
                  child: Text(
                    'Reject',
                    style: TextStyle(color: color4),
                  ),
                  style: ElevatedButton.styleFrom(backgroundColor: blackColor),
                ),
              ],
            ),
          ],
        ),
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
                    doctor?.username ?? 'Username not available',
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
                        builder: (context) => DoctorSettingsScreen(
                            doctorId: doctor?.doctorId ?? 'N/A'),
                      ),
                    );
                  },
                )
              ],
            ),
          ),

          Center(
            child: Text(
              'Your Consultation Summaries',
              style: GoogleFonts.raleway(
                  color: collaborateAppBarBgColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 25),
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
                      SearchScreen(id: widget.doctorId, role: 'DOCTOR'),
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
                    'Search Your Consultaions',
                    style: TextStyle(color: Colors.white, fontSize: 17),
                  ),
                ],
              ),
            ),
          ),
          Flexible(
            child: SummaryListScreen(id: widget.doctorId, role: "DOCTOR"),
          )
          // Add more list items as needed
        ],
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
        docPatientId: 'DocPatientId $i',
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
        medicineId: 'Medicine Id $i',
        prescriptionId: "PrescriptionID$i",
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
