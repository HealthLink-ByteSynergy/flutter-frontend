import 'package:flutter/material.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Prescription'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Doctor: Chatgpt', // Replace with doctor's name
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10.0),
            Text(
              'Patient: Flutter', // Replace with patient's name
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20.0),
            Text(
              'Medicines:',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10.0),
            ListView.builder(
              shrinkWrap: true,
              itemCount: medicines.length,
              itemBuilder: (context, index) {
                Medicine medicine = medicines[index];
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Medicine Name: ${medicine.name}'),
                    Text('Dosage: ${medicine.dosage}'),
                    Text('Frequency: ${medicine.frequency}'),
                    Divider(),
                  ],
                );
              },
            ),
            SizedBox(height: 10.0),
            Text(
              'Add Medicine:',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10.0),
            TextFormField(
              controller: medicineNameController,
              decoration: InputDecoration(labelText: 'Medicine Name'),
            ),
            TextFormField(
              controller: dosageController,
              decoration: InputDecoration(labelText: 'Dosage'),
            ),
            TextFormField(
              controller: frequencyController,
              decoration: InputDecoration(labelText: 'Frequency'),
            ),
            SizedBox(height: 10.0),
            ElevatedButton(
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
            SizedBox(height: 20.0),
            Text(
              'General Habits or Instructions:',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10.0),
            TextFormField(
              controller: habitsController,
              maxLines: 4,
              decoration: InputDecoration(
                labelText: 'Enter general habits or instructions',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                // Handle saving prescription
              },
              child: Text('Save Prescription'),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: PrescriptionScreen(),
  ));
}
