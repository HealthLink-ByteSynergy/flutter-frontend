import 'package:flutter/material.dart';
import 'package:healthlink/utils/colors.dart';

Widget buildTextField({
  required TextEditingController controller,
  required IconData prefixIcon,
  required String labelText,
  required int maxLength,
  required TextInputType? keyboardType,
}) {
  return TextField(
    controller: controller,
    autocorrect: true,
    cursorColor: color4, // Change to your preferred color
    maxLength: maxLength,
    maxLines: null,
    style: TextStyle(color: color4), // Change to your preferred color
    decoration: InputDecoration(
      prefixIcon: Icon(
        prefixIcon,
        color: color4, // Change to your preferred color
      ),
      labelText: labelText,
      counterStyle: TextStyle(color: color4),
      labelStyle: TextStyle(color: color4), // Change to your preferred color
      filled: true,
      floatingLabelBehavior: FloatingLabelBehavior.never,
      fillColor: Colors.white.withOpacity(0.3),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30.0),
        borderSide: BorderSide(width: 0, style: BorderStyle.none),
      ),
    ),
    keyboardType: keyboardType,
  );
}
