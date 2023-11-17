import 'package:flutter/material.dart';
// Import your HomeScreen widget
import 'package:healthlink/screens/auth/login.dart'; // Import your LoginScreen widget
// Import your modified AuthMethods class

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
    return const LoginScreen();
    // return FutureBuilder(
    //   future: AuthMethods.fetchToken(),
    //   builder: (context, snapshot) {
    //     if (snapshot.connectionState == ConnectionState.waiting) {
    //       return CircularProgressIndicator(); // Loading indicator while fetching token
    //     } else {
    //       String? token = snapshot.data as String?;
    //       if (token != null && token.isNotEmpty) {
    //         return HomeBody(
    //             jwtToken: token); // Navigate to HomeScreen if token is present
    //       } else {
    //         return LoginScreen(); // Navigate to LoginScreen if token is not present
    //       }
    //     }
    //   },
    // );
  }
}
