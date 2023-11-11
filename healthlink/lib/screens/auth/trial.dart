// import 'package:flutter/material.dart';

// class ChatScreen extends StatefulWidget {
//   @override
//   _ChatScreenState createState() => _ChatScreenState();
// }

// class _ChatScreenState extends State<ChatScreen> {
//   // ... (unchanged code)

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Your App Name'),
//         actions: [
//           // ... (unchanged code)
//         ],
//       ),
//       drawer: _buildDrawer(), // Add the Drawer widget here
//       body: Column(
//         children: [
//           Expanded(
//             child: ListView(
//               padding: EdgeInsets.all(8.0),
//               children: [
//                 // ... (unchanged code)
//               ],
//             ),
//           ),
//           _buildInputField(),
//         ],
//       ),
//     );
//   }

//   Widget _buildDrawer() {
//     return Drawer(
//       child: Column(
//         children: [
//           DrawerHeader(
//             decoration: BoxDecoration(
//               color: Colors.blue,
//             ),
//             child: Text(
//               'User Name',
//               style: TextStyle(
//                 color: Colors.white,
//                 fontSize: 24,
//               ),
//             ),
//           ),
//           ListTile(
//             title: Text('Search'),
//             onTap: () {
//               // Handle search tap
//               Navigator.pop(context); // Close the drawer
//               // Navigate to the search screen (specifications will be added later)
//             },
//           ),
//           ListTile(
//             title: Text('Previous Summaries'),
//             onTap: () {
//               // Handle previous summaries tap
//               Navigator.pop(context); // Close the drawer
//               // Navigate to the previous summaries screen (specifications will be added later)
//             },
//           ),
//           // Add more list items as needed
//           Spacer(),
//           Container(
//             padding: EdgeInsets.all(16.0),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text('User Name'),
//                 GestureDetector(
//                   onTap: () {
//                     // Handle three dots tap
//                     Navigator.pop(context); // Close the drawer
//                     // Navigate to the screen with three dots menu (specifications will be added later)
//                   },
//                   child: Icon(Icons.more_horiz),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// void main() {
//   runApp(MaterialApp(
//     home: ChatScreen(),
//   ));
// }
