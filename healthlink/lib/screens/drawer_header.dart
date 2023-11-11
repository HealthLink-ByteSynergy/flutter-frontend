import 'package:flutter/material.dart';

class CustomDrawerHeader extends SliverPersistentHeaderDelegate {
  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      height: 120, // Adjust the height as needed
      color: Colors.blue,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'User Name',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
            GestureDetector(
              onTap: () {
                // Handle three dots tap in the CustomDrawerHeader
                Navigator.pop(context); // Close the drawer
                // Navigate to the screen with three dots menu (specifications will be added later)
              },
              child: Icon(Icons.more_horiz, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  @override
  double get maxExtent => 120; // Adjust the max height as needed

  @override
  double get minExtent => 120; // Adjust the min height as needed

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}
