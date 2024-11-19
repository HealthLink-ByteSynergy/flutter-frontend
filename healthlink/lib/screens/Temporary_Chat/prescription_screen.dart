import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:healthlink/Service/doctor_service.dart';
import 'package:healthlink/Service/patient_service.dart';
import 'package:healthlink/models/Doctor.dart';
import 'package:healthlink/models/Medicine.dart';
import 'package:healthlink/models/Patient.dart';
import 'package:healthlink/models/Prescription.dart';
import 'package:healthlink/utils/colors.dart';

class PrescriptionScreen extends StatefulWidget {
  final String patientId;
  final String doctorId;
  final Prescription currentPrescription;

  const PrescriptionScreen(
      {Key? key,
      required this.doctorId,
      required this.patientId,
      required this.currentPrescription})
      : super(key: key);
  @override
  _PrescriptionScreenState createState() => _PrescriptionScreenState();
}

class _PrescriptionScreenState extends State<PrescriptionScreen> {
  TextEditingController medicineNameController = TextEditingController();
  TextEditingController dosageController = TextEditingController();
  TextEditingController frequencyController = TextEditingController();
  TextEditingController habitsController = TextEditingController();
  Patient? patient;
  Doctor? doctor;

  List<Medicine> medicines = [];

  @override
  void initState() {
    super.initState();
    initFields();
    _fetchPatientDetails();
    _fetchDoctorDetails();
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

  void initFields() {
    medicineNameController.text = '';
    dosageController.text = '';
    frequencyController.text = '';
    habitsController.text = widget.currentPrescription.generalHabits;

    // You might need to iterate through existing medicines in the prescription
    // and update the UI accordingly
    setState(() {
      medicines = widget.currentPrescription.medicines;
    });
  }

  void _showDeleteMedicineDialog(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Medicine'),
          content: Text('Are you sure you want to delete this medicine?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  medicines.removeAt(index);
                });
                Navigator.of(context).pop();
              },
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        backgroundColor: color3,
        title: Text('Prescription'),
        // appBar: AppBar(
        //   backgroundColor: collaborateAppBarBgColor,
        //   title: Text('Prescription', style: GoogleFonts.raleway(color: color4)),
        // ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Doctor: ${doctor?.username ?? "N/A"}',
                style: GoogleFonts.raleway(
                    fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10.0),
              Text(
                'Patient: ${patient?.form!.name ?? "N/A"}',
                style: GoogleFonts.raleway(
                    fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20.0),
              Text(
                'Medicines',
                style: GoogleFonts.raleway(
                    fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10.0),
              medicines.isNotEmpty
                  ? SizedBox(
                      height: 200,
                      width: 300,
                      child: Container(
                        color: color3,
                        child: ListView.builder(
                          // shrinkWrap: true,
                          itemCount: medicines.length,
                          itemBuilder: (context, index) {
                            Medicine medicine = medicines[index];
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: collaborateAppBarBgColor,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Medicine Name',
                                              style: GoogleFonts.raleway(
                                                  color: color4,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(
                                              medicine.name,
                                              style: GoogleFonts.raleway(
                                                color: color4,
                                              ),
                                            ),
                                            Text(
                                              'Dosage',
                                              style: GoogleFonts.raleway(
                                                  color: color4,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(
                                              medicine.dosage,
                                              style: GoogleFonts.raleway(
                                                color: color4,
                                              ),
                                            ),
                                            Text(
                                              'Duration',
                                              style: GoogleFonts.raleway(
                                                  color: color4,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(
                                              medicine.frequency,
                                              style: GoogleFonts.raleway(
                                                color: color4,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      IconButton(
                                        color: color4,
                                        icon: Icon(Icons.delete),
                                        onPressed: () {
                                          _showDeleteMedicineDialog(index);
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                                Divider(),
                              ],
                            );
                          },
                        ),
                      ),
                    )
                  : Text("You have not added any medicines"),
              SizedBox(height: 50.0),
              Container(
                  child: Column(
                children: [
                  Text(
                    'Add Medicine:',
                    style: GoogleFonts.raleway(
                        fontSize: 18.0, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10.0),
                  TextFormField(
                    controller: medicineNameController,
                    decoration: InputDecoration(
                      labelText: 'Medicine Name',
                      labelStyle: TextStyle(
                          color: collaborateAppBarBgColor,
                          fontWeight: FontWeight.w500),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: collaborateAppBarBgColor),
                      ),
                    ),
                    cursorColor: collaborateAppBarBgColor,
                    style: TextStyle(
                        color:
                            collaborateAppBarBgColor), // Change text color here
                  ),
                  TextFormField(
                    controller: dosageController,
                    decoration: InputDecoration(
                      labelText: 'Dosage',
                      labelStyle: TextStyle(
                          color: collaborateAppBarBgColor,
                          fontWeight: FontWeight.w500),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: collaborateAppBarBgColor),
                      ),
                    ),
                    cursorColor: collaborateAppBarBgColor,
                    style: TextStyle(
                        color:
                            collaborateAppBarBgColor), // Change text color here
                  ),
                  TextFormField(
                    controller: frequencyController,
                    decoration: InputDecoration(
                      labelText: 'Duration',
                      labelStyle: TextStyle(
                          color: collaborateAppBarBgColor,
                          fontWeight: FontWeight.w500),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: collaborateAppBarBgColor),
                      ),
                    ),
                    cursorColor: collaborateAppBarBgColor,
                    style: TextStyle(
                        color:
                            collaborateAppBarBgColor), // Change text color here
                  ),
                  SizedBox(height: 10.0),
                ],
              )),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: collaborateAppBarBgColor),
                onPressed: () {
                  setState(() {
                    medicines.add(Medicine(
                      id: '',
                      name: medicineNameController.text,
                      dosage: dosageController.text,
                      frequency: frequencyController.text,
                    ));
                    medicineNameController.clear();
                    dosageController.clear();
                    frequencyController.clear();
                  });
                },
                child: Text(
                  'Add',
                  style: GoogleFonts.raleway(color: color4),
                ),
              ),
              SizedBox(height: 50.0),
              Text(
                'General Habits or Instructions',
                style: GoogleFonts.raleway(
                    fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10.0),
              TextFormField(
                controller: habitsController,
                maxLines: 5,
                decoration: InputDecoration(
                  labelText: 'Enter general habits or instructions',
                  labelStyle: GoogleFonts.raleway(
                      color: collaborateAppBarBgColor,
                      fontWeight: FontWeight.bold),
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 50.0),
              Row(
                mainAxisAlignment: MainAxisAlignment
                    .spaceEvenly, // Adjust the alignment as needed
                children: [
                  // ElevatedButton(
                  //   onPressed: () {
                  //     // Handle cancel action
                  //     Navigator.pop(
                  //         context); // Close the dialog without returning any data
                  //   },
                  //   style: ElevatedButton.styleFrom(
                  //       backgroundColor:
                  //           blackColor), // Change the color as needed
                  //   child: Text(
                  //     'Cancel',
                  //     style: GoogleFonts.raleway(
                  //         color: color4, fontWeight: FontWeight.bold),
                  //   ),
                  // ),
                  ElevatedButton(
                    onPressed: () {
                      // Handle saving prescription
                      Prescription prescription = Prescription(
                        medicineId: "",
                        prescriptionId: "",
                        doctorId:
                            widget.patientId, // Replace with actual doctor ID
                        patientId:
                            widget.patientId, // Replace with actual patient ID
                        medicines: medicines,
                        generalHabits: habitsController.text,
                      );

                      // Now you can send the prescription data back to the previous screen
                      Navigator.pop(context, prescription);
                    },
                    style:
                        ElevatedButton.styleFrom(backgroundColor: blackColor),
                    child: Text(
                      'Save',
                      style: GoogleFonts.raleway(
                          color: color4, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ));
  }
}

// class HomeScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Home'),
//       ),
//       body: Center(
//         child: ElevatedButton(
//           onPressed: () {
//             showDialog(
//               context: context,
//               builder: (BuildContext context) {
//                 return PrescriptionScreen();
//               },
//             );
//           },
//           child: Text('Open Prescription'),
//         ),
//       ),
//     );
//   }
// }

// Existing classes and imports remain unchanged

// class PrescriptionDialog extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return AlertDialog(
//       title: Text('Prescription'),
//       content: SizedBox(height: 600, width: 400, child: PrescriptionScreen()),
//     );
//   }
// }

// void main() {
//   runApp(MaterialApp(
//     home: HomeScreen(),
//   ));
// }
