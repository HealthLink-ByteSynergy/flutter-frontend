// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:healthlink/utils/colors.dart';

class Medicine {
  final String name;
  final String dosage;
  final String frequency;

  Medicine({required this.name, required this.dosage, required this.frequency});
}

class Prescription {
  String doctorId;
  String patientId;
  List<Medicine> medicines;
  String generalHabits;

  Prescription({
    required this.doctorId,
    required this.patientId,
    required this.medicines,
    required this.generalHabits,
  });
}

class PrescriptionScreen extends StatefulWidget {
  @override
  _PrescriptionScreenState createState() => _PrescriptionScreenState();
}

class _PrescriptionScreenState extends State<PrescriptionScreen> {
  TextEditingController medicineNameController = TextEditingController();
  TextEditingController dosageController = TextEditingController();
  TextEditingController frequencyController = TextEditingController();
  TextEditingController habitsController = TextEditingController();

  List<Medicine> medicines = [];

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
                'Doctor: DoctorName', // Replace with doctor's name
                style: GoogleFonts.raleway(
                    fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10.0),
              Text(
                'Patient: PatientName', // Replace with patient's name
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
              SizedBox(height: 30.0),
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
                      name: medicineNameController.text,
                      dosage: dosageController.text,
                      frequency: frequencyController.text,
                    ));
                    medicineNameController.clear();
                    dosageController.clear();
                    frequencyController.clear();
                  });
                },
                child: Text('Add'),
              ),
              SizedBox(height: 50.0),
              Text(
                'General Habits or Instructions:',
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
              ElevatedButton(
                onPressed: () {
                  // Handle saving prescription
                },
                style: ElevatedButton.styleFrom(backgroundColor: blackColor),
                child: Text('Save Prescription'),
              ),
            ],
          ),
        ));
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return PrescriptionScreen();
              },
            );
          },
          child: Text('Open Prescription'),
        ),
      ),
    );
  }
}

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

void main() {
  runApp(MaterialApp(
    home: HomeScreen(),
  ));
}
