import 'package:flutter/material.dart';

import '../../../routes.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GestureDetector(
          onTap: () {
            Navigator.pushReplacementNamed(context, '/home');
          },
          child: Image.asset(
            'assets/images/logo.png',
            fit: BoxFit.contain,
          ),
        ),
      ),
      actions: [
        // Notification icon
        IconButton(
          icon: Icon(Icons.notifications_outlined, color: Colors.black),
          onPressed: () {
            Navigator.pushNamed(context, AppRoutes.notification);
            print('Notifications tapped');
          },
        ),
        // Menu icon
        Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: Icon(Icons.menu, color: Colors.black),
              onPressed: () {
                Scaffold.of(context).openEndDrawer();
              },
            );
          },
        ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
