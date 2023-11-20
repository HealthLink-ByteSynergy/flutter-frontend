// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:healthlink/Service/auth_service.dart';
import 'package:healthlink/Service/doctor_service.dart';
import 'package:healthlink/Service/user_service.dart';
import 'package:healthlink/models/Doctor.dart';
import 'package:healthlink/screens/Doctor/DoctorScreen.dart';
import 'package:healthlink/screens/auth/login.dart';
import 'package:healthlink/screens/home.dart';

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
                                  doctorId: doctorDetails.doctorId);
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

  // @override
  // Widget build(BuildContext context) {
  //   return FutureBuilder(
  //     future: AuthService().getToken(),
  //     builder: (context, snapshot) {
  //       if (snapshot.connectionState == ConnectionState.waiting) {
  //         return CircularProgressIndicator(); // Loading indicator while fetching token
  //       } else {
  //         String? token = snapshot.data as String?;
  //         if (token != null && token.isNotEmpty) {
  //           return FutureBuilder(
  //             future: UserService()
  //                 .getUserDetails(), // Fetch user details based on token
  //             builder: (context, userSnapshot) {
  //               if (userSnapshot.connectionState == ConnectionState.waiting) {
  //                 return CircularProgressIndicator(); // Loading indicator while fetching user details
  //               } else {
  //                 Map<String, dynamic>? userDetails = userSnapshot.data;
  //                 if (userDetails != null) {
  //                   // Check the role of the user and conditionally render the screen
  //                   if (userDetails['role'] == 'DOCTOR') {

  //                     return DoctorScreen(
  //                         doctorId: userDetails[
  //                             'id']); // Render DoctorScreen for doctor role
  //                   } else {
  //                     return HomeBody(); // Render UserScreen for other roles
  //                   }
  //                 } else {
  //                   return LoginScreen(); // Navigate to LoginScreen if userDetails is null
  //                 }
  //               }
  //             },
  //           );
  //         } else {
  //           return LoginScreen(); // Navigate to LoginScreen if token is not present
  //         }
  //       }
  //     },
  //   );
  // }
}

// class AuthenticationWrapper extends StatelessWidget {
//   const AuthenticationWrapper({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder(
//       future: AuthService().getToken(),
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return CircularProgressIndicator(); // Loading indicator while fetching token
//         } else {
//           String? token = snapshot.data as String?;
//           if (token != null && token.isNotEmpty) {
//             return HomeBody(); // Navigate to HomeScreen if token is present
//           } else {
//             return LoginScreen(); // Navigate to LoginScreen if token is not present
//           }
//         }
//       },
//     );
//   }
// }
