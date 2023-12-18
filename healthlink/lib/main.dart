// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:healthlink/Service/auth_service.dart';
import 'package:healthlink/Service/doctor_service.dart';
import 'package:healthlink/Service/user_service.dart';
import 'package:healthlink/models/Doctor.dart';
import 'package:healthlink/screens/Doctor/DoctorScreen.dart';
import 'package:healthlink/screens/auth/login.dart';
import 'package:healthlink/screens/Patient/home.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        '/login': (context) => LoginScreen(),
        // Define other routes here
      },
      debugShowCheckedModeBanner: false,
      title: 'HealthLink',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const AuthenticationWrapper(),
    );
  }
}

class AuthenticationWrapper extends StatelessWidget {
  const AuthenticationWrapper({Key? key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: AuthService().getToken(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else {
          String? token = snapshot.data;
          if (token != null && token.isNotEmpty) {
            return FutureBuilder(
              future: UserService().getUserDetails(),
              builder: (context, userSnapshot) {
                if (userSnapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else {
                  Map<String, dynamic>? userDetails = userSnapshot.data;
                  if (userDetails != null) {
                    if (userDetails['role'] == 'DOCTOR') {
                      return FutureBuilder(
                        future: DoctorService()
                            .getDoctorByUserId(), // Query Doctor using userId
                        builder: (context, doctorSnapshot) {
                          if (doctorSnapshot.connectionState ==
                              ConnectionState.waiting) {
                            return CircularProgressIndicator();
                          } else {
                            Doctor? doctorDetails = doctorSnapshot.data;
                            if (doctorDetails != null) {
                              return DoctorScreen(
                                doctorId: doctorDetails.doctorId,
                              );
                            } else {
                              return LoginScreen();
                            }
                          }
                        },
                      );
                    } else {
                      return HomeBody();
                    }
                  } else {
                    return LoginScreen();
                  }
                }
              },
            );
          } else {
            return LoginScreen();
          }
        }
      },
    );
  }
}
