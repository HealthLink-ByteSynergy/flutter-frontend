import 'package:flutter/material.dart';
import 'package:healthlink/Service/auth_service.dart';
import 'package:healthlink/screens/auth/login.dart';
import 'package:healthlink/screens/home.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
  const AuthenticationWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: AuthService().getToken(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator(); // Loading indicator while fetching token
        } else {
          String? token = snapshot.data as String?;
          if (token != null && token.isNotEmpty) {
            return HomeBody(); // Navigate to HomeScreen if token is present
          } else {
            return LoginScreen(); // Navigate to LoginScreen if token is not present
          }
        }
      },
    );
  }
}
