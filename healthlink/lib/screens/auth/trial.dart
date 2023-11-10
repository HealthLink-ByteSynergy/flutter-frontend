import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyForm(),
    );
  }
}

class MyForm extends StatefulWidget {
  @override
  _MyFormState createState() => _MyFormState();
}

class _MyFormState extends State<MyForm> {
  String? selectedOption; // Change here

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Yes/No Question'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('Is this a Yes/No question?'),
          ),
          Row(
            children: [
              Radio(
                value: 'Yes',
                groupValue: selectedOption,
                onChanged: (value) {
                  setState(() {
                    selectedOption = value as String?; // Add as String?
                  });
                },
              ),
              Text('Yes'),
              SizedBox(width: 20),
              Radio(
                value: 'No',
                groupValue: selectedOption,
                onChanged: (value) {
                  setState(() {
                    selectedOption = value as String?; // Add as String?
                  });
                },
              ),
              Text('No'),
            ],
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              // Handle form submission or further actions
              print('Selected option: $selectedOption');
            },
            child: Text('Submit'),
          ),
        ],
      ),
    );
  }
}
