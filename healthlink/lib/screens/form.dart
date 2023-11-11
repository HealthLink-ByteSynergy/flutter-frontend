// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:healthlink/models/custom_form.dart';
import 'package:healthlink/screens/main_chat.dart';
import 'package:healthlink/utils/colors.dart';
import 'package:healthlink/widgets/custom_text_field.dart';

class MedicalInfoForm extends StatefulWidget {
  CustomForm customForm;

  MedicalInfoForm({required this.customForm});

  @override
  _MedicalInfoFormState createState() => _MedicalInfoFormState();
}

class _MedicalInfoFormState extends State<MedicalInfoForm> {
  late TextEditingController nameController;
  late TextEditingController ageController;
  late TextEditingController genderController;
  late TextEditingController heightController;
  late TextEditingController weightController;
  late TextEditingController medicalConditionsController;
  late TextEditingController medicationsController;
  late TextEditingController recentSurgeryController;
  late TextEditingController allergiesController;
  late TextEditingController smokingFrequencyController;
  late TextEditingController drinkingFrequencyController;
  late TextEditingController drugUseAndFrequencyController;
  late CustomForm customForm;

  @override
  void initState() {
    super.initState();
    customForm = widget.customForm;
    nameController = TextEditingController(text: widget.customForm.name);
    ageController =
        TextEditingController(text: widget.customForm.age?.toString());
    genderController = TextEditingController(text: widget.customForm.gender);
    heightController =
        TextEditingController(text: widget.customForm.height?.toString());
    weightController =
        TextEditingController(text: widget.customForm.weight?.toString());
    medicalConditionsController =
        TextEditingController(text: widget.customForm.getMedicalConditions);
    medicationsController =
        TextEditingController(text: widget.customForm.getMedications);
    recentSurgeryController = TextEditingController(
        text: widget.customForm.getRecentSurgeryOrProcedure);
    allergiesController =
        TextEditingController(text: widget.customForm.getAllergies);
    smokingFrequencyController =
        TextEditingController(text: widget.customForm.getSmokingFrequency);
    drinkingFrequencyController =
        TextEditingController(text: widget.customForm.getDrinkingFrequency);
    drugUseAndFrequencyController =
        TextEditingController(text: widget.customForm.drugsUsedAndFrequency);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: collaborateAppBarBgColor,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              SizedBox(height: 50.0),
              Container(
                child: Text(
                  'Please fill all the details in the form',
                  style: GoogleFonts.raleway(
                      color: color4, fontSize: 30, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 25.0),
              buildTextField(
                controller: nameController,
                prefixIcon: Icons.person_outline,
                labelText: 'Your Name',
                maxLength: 25,
                keyboardType: TextInputType.text,
              ),
              SizedBox(height: 16.0),
              buildTextField(
                  controller: ageController,
                  prefixIcon: Icons.calendar_today_outlined,
                  labelText: 'Your Age',
                  maxLength: 3,
                  keyboardType: TextInputType.number),
              SizedBox(height: 16.0),
              // Gender Dropdown
              DropdownButtonFormField<String>(
                dropdownColor: color2,
                value: customForm.getGender,
                hint: Text('Select Gender',
                    style: GoogleFonts.raleway(
                        color: color4, fontWeight: FontWeight.bold)),
                items: ['Male', 'Female', 'Other'].map((String gender) {
                  return DropdownMenuItem<String>(
                    value: gender,
                    child: Text(
                      gender,
                      style: GoogleFonts.raleway(
                          color: color4, fontWeight: FontWeight.bold),
                    ),
                  );
                }).toList(),
                onChanged: (String? value) {
                  // Update the gender when selected
                  customForm.setGender = value;
                },
                decoration: InputDecoration(
                  filled: true,
                  fillColor:
                      Colors.white.withOpacity(0.3), // Set the background color
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    borderSide: BorderSide(
                      color: collaborateAppBarBgColor, // Set the border color
                      width: 0, // Set the border width
                    ), // Set rounded corners
                  ),
                ),
                style: GoogleFonts.raleway(color: color4),
              ),
              SizedBox(height: 20.0),
              buildTextField(
                controller: heightController,
                prefixIcon: Icons.height,
                labelText: 'Your Height(in cms)',
                maxLength: 3,
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 16.0),
              buildTextField(
                  controller: weightController,
                  prefixIcon: Icons.line_weight,
                  labelText: 'Your Weight(in kgs)',
                  maxLength: 3,
                  keyboardType: TextInputType.number),
              SizedBox(height: 20.0),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Do you have any medical conditions?',
                  style: GoogleFonts.raleway(
                      color: color4, fontWeight: FontWeight.bold, fontSize: 20),
                ),
              ),
              Center(
                child:
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Radio(
                    value: true,
                    groupValue: customForm.getHasMedicalConditions,
                    onChanged: (value) {
                      setState(() {
                        customForm.setHasMedicalConditions = value as bool?;
                      });
                    },
                  ),
                  Text('Yes',
                      style: GoogleFonts.raleway(
                          color: color4,
                          fontWeight: FontWeight.bold,
                          fontSize: 20)),
                  SizedBox(width: 20),
                  Radio(
                    value: false,
                    groupValue: customForm.getHasMedicalConditions,
                    onChanged: (value) {
                      setState(() {
                        customForm.setHasMedicalConditions =
                            value as bool?; // Add as String?
                      });
                    },
                  ),
                  Text('No',
                      style: GoogleFonts.raleway(
                          color: color4,
                          fontWeight: FontWeight.bold,
                          fontSize: 20)),
                ]),
              ),
              customForm.getHasMedicalConditions != null &&
                      customForm.getHasMedicalConditions == true
                  ? Column(
                      children: [
                        buildTextField(
                            controller: medicalConditionsController,
                            prefixIcon: Icons.abc,
                            labelText: 'Specify Medical Conditions',
                            maxLength: 400,
                            keyboardType: TextInputType.text),
                        buildTextField(
                            controller: medicationsController,
                            prefixIcon: Icons.line_weight,
                            labelText: 'Specify Medications',
                            maxLength: 400,
                            keyboardType: TextInputType.text),
                      ],
                    )
                  : Container(),
              SizedBox(height: 20.0),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Have you had any recent surgeries or procedures?',
                  style: GoogleFonts.raleway(
                      color: color4, fontWeight: FontWeight.bold, fontSize: 20),
                ),
              ),
              Center(
                child:
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Radio(
                    value: true,
                    groupValue: customForm.getHasHadRecentSurgeryOrProcedure,
                    onChanged: (value) {
                      setState(() {
                        customForm.setHasHadRecentSurgeryOrProcedure =
                            value as bool?;
                        // print(customForm.getHasHadRecentSurgeryOrProcedure);
                      });
                    },
                  ),
                  Text('Yes',
                      style: GoogleFonts.raleway(
                          color: color4,
                          fontWeight: FontWeight.bold,
                          fontSize: 20)),
                  SizedBox(width: 20),
                  Radio(
                    value: false,
                    groupValue: customForm.getHasHadRecentSurgeryOrProcedure,
                    onChanged: (value) {
                      setState(() {
                        customForm.setHasHadRecentSurgeryOrProcedure =
                            value as bool?; // Add as String?
                      });
                    },
                  ),
                  Text('No',
                      style: GoogleFonts.raleway(
                          color: color4,
                          fontWeight: FontWeight.bold,
                          fontSize: 20)),
                ]),
              ),
              customForm.getHasHadRecentSurgeryOrProcedure != null &&
                      customForm.getHasHadRecentSurgeryOrProcedure == true
                  ? Column(
                      children: [
                        buildTextField(
                            controller: recentSurgeryController,
                            prefixIcon: Icons.abc,
                            labelText: 'Specify recent surgeries/procedures',
                            maxLength: 400,
                            keyboardType: TextInputType.text),
                      ],
                    )
                  : Container(),
              SizedBox(height: 20.0),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Are you allergic to any medications?',
                  style: GoogleFonts.raleway(
                      color: color4, fontWeight: FontWeight.bold, fontSize: 20),
                ),
              ),
              Center(
                child:
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Radio(
                    value: true,
                    groupValue: customForm.getIsAllergicToAnyMedications,
                    onChanged: (value) {
                      setState(() {
                        customForm.setIsAllergicToAnyMedications =
                            value as bool?;
                        // print(customForm.getHasHadRecentSurgeryOrProcedure);
                      });
                    },
                  ),
                  Text('Yes',
                      style: GoogleFonts.raleway(
                          color: color4,
                          fontWeight: FontWeight.bold,
                          fontSize: 20)),
                  SizedBox(width: 20),
                  Radio(
                    value: false,
                    groupValue: customForm.getIsAllergicToAnyMedications,
                    onChanged: (value) {
                      setState(() {
                        customForm.setIsAllergicToAnyMedications =
                            value as bool?; // Add as String?
                      });
                    },
                  ),
                  Text('No',
                      style: GoogleFonts.raleway(
                          color: color4,
                          fontWeight: FontWeight.bold,
                          fontSize: 20)),
                ]),
              ),
              customForm.getIsAllergicToAnyMedications != null &&
                      customForm.getIsAllergicToAnyMedications == true
                  ? Column(
                      children: [
                        buildTextField(
                            controller: allergiesController,
                            prefixIcon: Icons.abc,
                            labelText:
                                'Specify medicines/food you are alergic to',
                            maxLength: 400,
                            keyboardType: TextInputType.text),
                      ],
                    )
                  : Container(),
              SizedBox(height: 20.0),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Do you smoke cigarettes?',
                  style: GoogleFonts.raleway(
                      color: color4, fontWeight: FontWeight.bold, fontSize: 20),
                ),
              ),
              Center(
                child:
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Radio(
                    value: true,
                    groupValue: customForm.getDoesSmokeCigarettes,
                    onChanged: (value) {
                      setState(() {
                        customForm.setDoesSmokeCigarettes = value as bool?;
                        // print(customForm.getHasHadRecentSurgeryOrProcedure);
                      });
                    },
                  ),
                  Text('Yes',
                      style: GoogleFonts.raleway(
                          color: color4,
                          fontWeight: FontWeight.bold,
                          fontSize: 20)),
                  SizedBox(width: 20),
                  Radio(
                    value: false,
                    groupValue: customForm.getDoesSmokeCigarettes,
                    onChanged: (value) {
                      setState(() {
                        customForm.setDoesSmokeCigarettes =
                            value as bool?; // Add as String?
                      });
                    },
                  ),
                  Text('No',
                      style: GoogleFonts.raleway(
                          color: color4,
                          fontWeight: FontWeight.bold,
                          fontSize: 20)),
                ]),
              ),
              customForm.getDoesSmokeCigarettes != null &&
                      customForm.getDoesSmokeCigarettes == true
                  ? Column(
                      children: [
                        buildTextField(
                            controller: smokingFrequencyController,
                            prefixIcon: Icons.abc,
                            labelText: "Specify smoking frequency",
                            maxLength: 400,
                            keyboardType: TextInputType.text),
                      ],
                    )
                  : Container(),
              SizedBox(height: 20.0),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Do you drink alcohol?',
                  style: GoogleFonts.raleway(
                      color: color4, fontWeight: FontWeight.bold, fontSize: 20),
                ),
              ),
              Center(
                child:
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Radio(
                    value: true,
                    groupValue: customForm.getDoesDrinkAlcohol,
                    onChanged: (value) {
                      setState(() {
                        customForm.setDoesDrinkAlcohol = value as bool?;
                        // print(customForm.getHasHadRecentSurgeryOrProcedure);
                      });
                    },
                  ),
                  Text('Yes',
                      style: GoogleFonts.raleway(
                          color: color4,
                          fontWeight: FontWeight.bold,
                          fontSize: 20)),
                  SizedBox(width: 20),
                  Radio(
                    value: false,
                    groupValue: customForm.getDoesDrinkAlcohol,
                    onChanged: (value) {
                      setState(() {
                        customForm.setDoesDrinkAlcohol =
                            value as bool?; // Add as String?
                      });
                    },
                  ),
                  Text('No',
                      style: GoogleFonts.raleway(
                          color: color4,
                          fontWeight: FontWeight.bold,
                          fontSize: 20)),
                ]),
              ),
              customForm.getDoesDrinkAlcohol != null &&
                      customForm.getDoesDrinkAlcohol == true
                  ? Column(
                      children: [
                        buildTextField(
                            controller: drinkingFrequencyController,
                            prefixIcon: Icons.abc,
                            labelText: "Specify drinking frequency",
                            maxLength: 400,
                            keyboardType: TextInputType.text),
                      ],
                    )
                  : Container(),
              SizedBox(height: 20.0),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Do you take any drugs?',
                  style: GoogleFonts.raleway(
                      color: color4, fontWeight: FontWeight.bold, fontSize: 20),
                ),
              ),
              Center(
                child:
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Radio(
                    value: true,
                    groupValue: customForm.getDoesUseDrugs,
                    onChanged: (value) {
                      setState(() {
                        customForm.setDoesUseDrugs = value as bool?;
                        // print(customForm.getHasHadRecentSurgeryOrProcedure);
                      });
                    },
                  ),
                  Text('Yes',
                      style: GoogleFonts.raleway(
                          color: color4,
                          fontWeight: FontWeight.bold,
                          fontSize: 20)),
                  SizedBox(width: 20),
                  Radio(
                    value: false,
                    groupValue: customForm.getDoesUseDrugs,
                    onChanged: (value) {
                      setState(() {
                        customForm.setDoesUseDrugs =
                            value as bool?; // Add as String?
                      });
                    },
                  ),
                  Text('No',
                      style: GoogleFonts.raleway(
                          color: color4,
                          fontWeight: FontWeight.bold,
                          fontSize: 20)),
                ]),
              ),
              customForm.getDoesUseDrugs != null &&
                      customForm.getDoesUseDrugs == true
                  ? Column(
                      children: [
                        buildTextField(
                            controller: drugUseAndFrequencyController,
                            prefixIcon: Icons.abc,
                            labelText: "Specify drug usage and it's frequency",
                            maxLength: 400,
                            keyboardType: TextInputType.text),
                      ],
                    )
                  : Container(),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    style:
                        ElevatedButton.styleFrom(backgroundColor: blackColor),
                    onPressed: () {}, // Submit button
                    child: Text('Cancel',
                        style: GoogleFonts.raleway(
                            color: color4,
                            fontWeight: FontWeight.w500,
                            fontSize: 18)),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: orange),
                    onPressed: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => ChatScreen(),
                        ),
                      );
                    }, // Submit button
                    child: Text('Submit',
                        style: GoogleFonts.raleway(
                            color: blackColor,
                            fontWeight: FontWeight.w500,
                            fontSize: 18)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
