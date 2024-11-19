// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:healthlink/Service/auth_service.dart'; // Import your AuthMethods class
import 'package:google_fonts/google_fonts.dart';
import 'package:healthlink/Service/doctor_service.dart';
import 'package:healthlink/Service/user_service.dart';
import 'package:healthlink/screens/Doctor/DoctorScreen.dart';
import 'package:healthlink/screens/auth/role_signup.dart';
import 'package:healthlink/screens/Patient/home.dart';
import 'package:healthlink/utils/colors.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _isObscured = true;

  // Future<void> _loginUser() async {
  //   setState(() {
  //     _isLoading = true;
  //   });

  //   try {
  //     final Map<String, dynamic> result = await AuthService()
  //         .login(_emailController.text, _passwordController.text);

  //     if (result['success'] == true) {
  //       // Login successful, navigate to the home screen.
  //       Navigator.of(context).pushReplacement(MaterialPageRoute(
  //         builder: (context) => HomeBody(),
  //       ));

  //     } else {
  //       showDialog(
  //         context: context,
  //         builder: (context) => AlertDialog(
  //           title: const Text('Login Failed'),
  //           content: Text(result['message']),
  //           actions: [
  //             TextButton(
  //               onPressed: () => Navigator.pop(context),
  //               child: const Text('OK'),
  //             ),
  //           ],
  //         ),
  //       );
  //     }
  //   } catch (error) {
  //     showDialog(
  //       context: context,
  //       builder: (context) => AlertDialog(
  //         title: const Text('Login Failed'),
  //         content: Text(error.toString()),
  //         actions: [
  //           TextButton(
  //             onPressed: () => Navigator.pop(context),
  //             child: const Text('OK'),
  //           ),
  //         ],
  //       ),
  //     );
  //   } finally {
  //     setState(() {
  //       _isLoading = false;
  //     });
  //   }
  // }

  Future<void> _loginUser() async {
    setState(() {
      _isLoading = true;
    });
    print("entered login");

    try {
      final Map<String, dynamic> result = await AuthService().login(
        _emailController.text,
        _passwordController.text,
      );

      if (result['success'] == true) {
        // Login successful, fetch user details
        final userDetails = await UserService().getUserDetails();

        if (userDetails != null) {
          // Check the role of the user
          if (userDetails['role'] == 'DOCTOR') {
            // Fetch doctor details if the user is a doctor
            final doctorDetails = await DoctorService().getDoctorByUserId();
            if (doctorDetails != null) {
              // Navigate to DoctorScreen with doctor details
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) => DoctorScreen(
                  doctorId: doctorDetails.doctorId,
                ),
              ));
            }
          } else {
            // For other roles, navigate to HomeBody
            Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) => HomeBody(),
            ));
          }
        } else {
          // Handle null user details
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Error'),
              content: const Text('User details not found..null user'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('OK'),
                ),
              ],
            ),
          );
        }
      } else {
        // Handle login failure
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Error'),
            content: const Text('User details not found..login failure'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    } catch (error) {
      // Handle login error
      print(error);
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Error'),
          content: const Text('User details not found...login error'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width; // Screen width
    final height = MediaQuery.of(context).size.height; // Screen height

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: Container(
          constraints: BoxConstraints(minHeight: height),
          color: collaborateAppBarBgColor,
          padding: const EdgeInsets.symmetric(horizontal: 32),
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: height * 0.25,
              ),
              Text('HealthLink',
                  style: GoogleFonts.raleway(
                    fontSize: width * 0.12,
                    color: collaborateAppBarTextColor,
                    fontWeight: FontWeight.w500,
                  )),
              const SizedBox(
                height: 64,
              ),
              TextField(
                controller: _emailController,
                enableSuggestions: true,
                cursorColor: color4,
                style: GoogleFonts.ptSans(color: color4),
                decoration: InputDecoration(
                  prefixIcon: const Icon(
                    Icons.email_outlined,
                    color: color4,
                  ),
                  labelText: 'Enter your email',
                  labelStyle: GoogleFonts.ptSans(color: color4),
                  filled: true,
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                  fillColor: color5,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                      borderSide:
                          const BorderSide(width: 0, style: BorderStyle.none)),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(
                height: 30,
              ),
              TextField(
                controller: _passwordController,
                obscureText: _isObscured,
                enableSuggestions: false,
                autocorrect: false,
                cursorColor: Colors.white,
                style: GoogleFonts.ptSans(color: color4),
                decoration: InputDecoration(
                  prefixIcon: const Icon(
                    Icons.lock_outline,
                    color: color4,
                  ),
                  suffixIcon: IconButton(
                      icon: Icon(
                        _isObscured ? Icons.visibility_off : Icons.visibility,
                        color: color4,
                      ),
                      onPressed: () {
                        setState(() {
                          _isObscured = !_isObscured;
                        });
                      }),
                  labelText: 'Enter your password',
                  labelStyle: GoogleFonts.ptSans(color: color4),
                  filled: true,
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                  fillColor: Colors.white.withOpacity(0.3),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                      borderSide:
                          const BorderSide(width: 0, style: BorderStyle.none)),
                ),
                keyboardType: TextInputType.visiblePassword,
              ),
              // GestureDetector(
              //   onTap: () => Navigator.of(context).push(
              //     MaterialPageRoute(
              //       builder: (context) => const ResetPassword(),
              //     ),
              //   ),
              //   child: Container(
              //     alignment: Alignment.topRight,
              //     padding: const EdgeInsets.symmetric(vertical: 12),
              //     child: Text(
              //       'Reset Password?',
              //       style: GoogleFonts.ptSans(
              //           fontWeight: FontWeight.bold, color: color4),
              //     ),
              //   ),
              // ),
              const SizedBox(
                height: 30,
              ),
              InkWell(
                onTap: _loginUser,
                // Call the _loginUser method when the user taps the login button
                // onTap: () => Navigator.of(context).push(
                //   MaterialPageRoute(
                //     builder: (context) => HomeBody(jwtToken: 'ji'),
                //   ),
                // ),
                child: Container(
                  width: double.infinity,
                  alignment: Alignment.center,
                  height: height * 0.065,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: const ShapeDecoration(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                    ),
                    color: Colors.black,
                  ),
                  child: !_isLoading
                      ? Text(
                          'Log in',
                          style: GoogleFonts.ptSans(
                            fontSize: height * 0.025,
                            color: color4,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      : const CircularProgressIndicator(
                          color: Colors.blue,
                        ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Text(
                      'Dont have an account? ',
                      style: GoogleFonts.ptSans(
                          color: color4, fontWeight: FontWeight.w400),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const Role(),
                      ),
                    ),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Text(
                        ' Signup.',
                        style: GoogleFonts.ptSans(
                            fontWeight: FontWeight.bold, color: color4),
                      ),
                    ),
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
