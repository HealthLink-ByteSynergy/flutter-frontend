// import 'package:flutter/material.dart';
// import 'package:healthlink/auth/auth_methods.dart'; // Import your AuthMethods class
// import 'package:healthlink/utils/colors.dart'; // Import your color utils file
// import 'package:google_fonts/google_fonts.dart';

// class ResetPassword extends StatefulWidget {
//   const ResetPassword({Key? key}) : super(key: key);

//   @override
//   _ResetPasswordState createState() => _ResetPasswordState();
// }

// class _ResetPasswordState extends State<ResetPassword> {
//   final TextEditingController _emailTextController = TextEditingController();

//   // ignore: unused_element
//   Future<void> _resetPassword() async {
//     try {
//       await AuthMethods()
//           .resetPassword(email: _emailTextController.text.trim());
//       // Password reset successful, show a success message to the user.
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text('Password reset successful!'), // Success message
//           duration: Duration(
//               seconds: 2), // Duration for which the message will be visible
//         ),
//       );
//       Navigator.of(context).pop(); // Close the reset password screen
//     } catch (error) {
//       // Handle reset password errors, show error message to the user.
//       print("Error during password reset: $error");
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content:
//               Text('Password reset failed. Please try again.'), // Error message
//           duration: Duration(
//               seconds: 2), // Duration for which the message will be visible
//         ),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final height = MediaQuery.of(context).size.height;
//     final width = MediaQuery.of(context).size.width;

//     return Scaffold(
//       resizeToAvoidBottomInset: true,
//       body: SizedBox(
//         width: MediaQuery.of(context).size.width,
//         height: MediaQuery.of(context).size.height,
//         child: Scaffold(
//           backgroundColor: collaborateAppBarBgColor,
//           body: Padding(
//             padding: const EdgeInsets.fromLTRB(20, 120, 20, 0),
//             child: Column(
//               children: [
//                 SizedBox(
//                   height: height * 0.2,
//                 ),
//                 Text(
//                   'HealthLink', // Replace with your app name
//                   style: GoogleFonts.raleway(
//                     fontSize: width * 0.12,
//                     color: collaborateAppBarTextColor,
//                     fontWeight: FontWeight.w500,
//                   ),
//                 ),
//                 SizedBox(
//                   height: height * 0.1,
//                 ),
//                 TextField(
//                   controller: _emailTextController,
//                   autocorrect: true,
//                   cursorColor: color4,
//                   style: TextStyle(color: color4),
//                   decoration: InputDecoration(
//                     prefixIcon: const Icon(
//                       Icons.email_outlined,
//                       color: color4,
//                     ),
//                     labelText: 'Your email',
//                     labelStyle: const TextStyle(color: color4),
//                     filled: true,
//                     floatingLabelBehavior: FloatingLabelBehavior.never,
//                     fillColor: Colors.white.withOpacity(0.3),
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(30.0),
//                       borderSide: const BorderSide(
//                         width: 0,
//                         style: BorderStyle.none,
//                       ),
//                     ),
//                   ),
//                   keyboardType: TextInputType.emailAddress,
//                 ),
//                 SizedBox(
//                   height: height * 0.05,
//                 ),
//                 InkWell(
//                   onTap: _resetPassword,
//                   child: Container(
//                     width: double.infinity,
//                     alignment: Alignment.center,
//                     height: height * 0.065,
//                     padding: const EdgeInsets.symmetric(vertical: 12),
//                     decoration: const ShapeDecoration(
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.all(Radius.circular(30)),
//                       ),
//                       color: Colors.black,
//                     ),
//                     child: Text(
//                       'Reset Password',
//                       style: GoogleFonts.ptSans(
//                         fontSize: height * 0.025,
//                         color: color4,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
