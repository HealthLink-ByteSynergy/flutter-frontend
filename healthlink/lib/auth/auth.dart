// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';

// void main() {
//   runApp(const MyApp());
// }

// class AuthService {
//   static const String baseURL = 'http://10.0.2.2:5000/api/v1';
//   static const String loginURL = '$baseURL/user/login';
//   static const String signupURL = '$baseURL/user/signup';
//   static const String logoutURL = '$baseURL/user/logout';

//   Future<void> storeToken(String token) async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setString('token', token);
//   }

//   Future<String?> getToken() async {
//     final prefs = await SharedPreferences.getInstance();
//     return prefs.getString('token');
//   }

//   Future<void> removeToken() async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.remove('token');
//   }

//   Future<Map<String, dynamic>> login(String email, String password) async {
//     try {
//       final response = await http.post(
//         Uri.parse(loginURL),
//         body: jsonEncode({'email': email, 'password': password}),
//         headers: {'Content-Type': 'application/json'},
//       );

//       if (response.statusCode == 200) {
//         // final Map<String, dynamic> responseData = json.decode(response.body);
//         // final token = responseData['token'];

//         final token = response.body;

//         await storeToken(token);

//         return {'success': true, 'token': token};
//       } else {
//         return {'success': false, 'message': 'Login failed'};
//       }
//     } catch (e) {
//       return {'success': false, 'message': 'Exception: $e'};
//     }
//   }

//   Future<Map<String, dynamic>> signUp(
//       String name, String email, String password) async {
//     try {
//       final response = await http.post(
//         Uri.parse('http://10.0.2.2:5000/api/v1/user/signup'),
//         body: jsonEncode(
//             {"username": name, "email": email, "password": password}),
//         headers: {'Content-Type': 'application/json'},
//       );

//       if (response.statusCode == 200) {
//         // final Map<String, dynamic> responseData = json.decode(response.body);
//         // final token = responseData['token'];
//         // print(token);
//         final token = response.body;

//         await storeToken(token);

//         return {'success': true, 'token': token};
//       } else {
//         return {'success': false, 'message': 'Sign up failed'};
//       }
//     } catch (e) {
//       return {'success': false, 'message': 'Exception: $e'};
//     }
//   }

//   Future<Map<String, dynamic>> logout(String token) async {
//     try {
//       final response = await http.get(
//         Uri.parse(logoutURL),
//         headers: {
//           'Content-Type': 'application/json',
//           'Authorization': 'Bearer $token',
//         },
//       );

//       print(response.body);
//       if (response.statusCode == 200) {
//         await removeToken();
//         return {'success': true};
//       } else {
//         return {'success': false, 'message': 'Logout failed'};
//       }
//     } catch (e) {
//       return {'success': false, 'message': 'Exception: $e'};
//     }
//   }
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Token Storage Example',
//       home: FutureBuilder<String?>(
//         future: AuthService().getToken(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const CircularProgressIndicator();
//           } else {
//             final token = snapshot.data;

//             // Replace with your logic for routing to login or home screen
//             return token == null ? LoginScreen() : const HomeScreen();
//           }
//         },
//       ),
//     );
//   }
// }

// class LoginScreen extends StatelessWidget {
//   final TextEditingController emailController = TextEditingController();
//   final TextEditingController passwordController = TextEditingController();

//   LoginScreen({super.key});

//   void _login(BuildContext context) async {
//     final email = emailController.text;
//     final password = passwordController.text;

//     if (email.isNotEmpty && password.isNotEmpty) {
//       final result = await AuthService().login(email, password);
//       if (result['success'] == true) {
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(builder: (context) => const HomeScreen()),
//         );
//       } else {
//         // Handle login failure, show error message
//         showDialog(
//           context: context,
//           builder: (context) => AlertDialog(
//             title: const Text('Login Failed'),
//             content: Text(result['message']),
//             actions: [
//               TextButton(
//                 onPressed: () => Navigator.pop(context),
//                 child: const Text('OK'),
//               ),
//             ],
//           ),
//         );
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Login')),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             TextField(
//               controller: emailController,
//               decoration: const InputDecoration(labelText: 'Email'),
//             ),
//             const SizedBox(height: 20),
//             TextField(
//               controller: passwordController,
//               decoration: const InputDecoration(labelText: 'Password'),
//               obscureText: true,
//             ),
//             const SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: () => _login(context),
//               child: const Text('Login'),
//             ),
//             ElevatedButton(
//               onPressed: () => Navigator.pushReplacement(
//                 context,
//                 MaterialPageRoute(builder: (context) => SignUpScreen()),
//               ),
//               child: const Text('Signup'),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }

// class SignUpScreen extends StatelessWidget {
//   final TextEditingController nameController = TextEditingController();
//   final TextEditingController emailController = TextEditingController();
//   final TextEditingController passwordController = TextEditingController();

//   SignUpScreen({super.key});

//   void _signUp(BuildContext context) async {
//     final name = nameController.text;
//     final email = emailController.text;
//     final password = passwordController.text;

//     if (name.isNotEmpty && email.isNotEmpty && password.isNotEmpty) {
//       final result = await AuthService().signUp(name, email, password);
//       if (result['success'] == true) {
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(builder: (context) => const HomeScreen()),
//         );
//       } else {
//         // Handle sign-up failure, show error message
//         showDialog(
//           context: context,
//           builder: (context) => AlertDialog(
//             title: const Text('Sign Up Failed'),
//             content: Text(result['message']),
//             actions: [
//               TextButton(
//                 onPressed: () => Navigator.pop(context),
//                 child: const Text('OK'),
//               ),
//             ],
//           ),
//         );
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Sign Up')),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             TextField(
//               controller: nameController,
//               decoration: const InputDecoration(labelText: 'Name'),
//             ),
//             const SizedBox(height: 20),
//             TextField(
//               controller: emailController,
//               decoration: const InputDecoration(labelText: 'Email'),
//             ),
//             const SizedBox(height: 20),
//             TextField(
//               controller: passwordController,
//               decoration: const InputDecoration(labelText: 'Password'),
//               obscureText: true,
//             ),
//             const SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: () => _signUp(context),
//               child: const Text('Sign Up'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class HomeScreen extends StatelessWidget {
//   const HomeScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Home')),
//       body: Center(
//         child: ElevatedButton(
//           onPressed: () async {
//             final AuthService authService = AuthService();
//             final String? token = await authService.getToken();

//             if (token != null) {
//               final result = await authService.logout(token);
//               if (result['success'] == true) {
//                 Navigator.pushReplacement(
//                   context,
//                   MaterialPageRoute(builder: (context) => LoginScreen()),
//                 );
//               } else {
//                 // Handle logout failure
//                 showDialog(
//                   context: context,
//                   builder: (context) => AlertDialog(
//                     title: const Text('Logout Failed'),
//                     content: Text(result['message']),
//                     actions: [
//                       TextButton(
//                         onPressed: () => Navigator.pop(context),
//                         child: const Text('OK'),
//                       ),
//                     ],
//                   ),
//                 );
//               }
//             }
//           },
//           child: const Text('Logout'),
//         ),
//       ),
//     );
//   }
// }
