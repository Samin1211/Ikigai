import 'package:flutter/material.dart';
import 'profile_screen.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  static const Color lightPurple = Color(0xFFF4EAFF);
  static const Color darkPurple = Color(0xFF362E4B);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightPurple,
      appBar: AppBar(
        backgroundColor: lightPurple,
        elevation: 0,
        title: const Text(
          'Hello World',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: darkPurple,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: GestureDetector(
              onTap: () => showProfileMenu(context),
              child: const CircleAvatar(
                radius: 18,
                backgroundColor: Colors.black,
                backgroundImage: AssetImage('assets/ikigai_logo.png'),
              ),
            ),
          ),
        ],
      ),
      body: const Center(
        child: Text(
          'Hello World',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w500,
            color: darkPurple,
          ),
        ),
      ),
    );
  }
}
