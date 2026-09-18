import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'login.dart';
import 'edit_profile.dart';

class ProfileMenuButton extends StatefulWidget {
  const ProfileMenuButton({super.key});

  @override
  State<ProfileMenuButton> createState() => _ProfileMenuButtonState();
}

class _ProfileMenuButtonState extends State<ProfileMenuButton> {
  String userName = 'User Name';
  String userEmail = 'user@example.com';
  String age = '';
  String gender = '';

  @override
  void initState() {
    super.initState();
    userEmail = FirebaseAuth.instance.currentUser?.email ?? userEmail;
    loadUserData();
  }

  void loadUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();

    if (!mounted || !doc.exists) return;

    final data = doc.data()!;
    setState(() {
      userName = data['name'] ?? userName;
      age = data['age'] ?? '';
      gender = data['gender'] ?? '';
    });
  }

  void showAboutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFFFDF7FF),
        title: const Text('About Ikigai'),
        content: const Text(
          'Version 1.0.0\n\nA Flutter based productivity application.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void onSelected(String value) async {
    if (value == 'edit') {
      await Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const EditProfilePage()),
      );
      loadUserData();
    } else if (value == 'about') {
      showAboutDialog();
    } else if (value == 'logout') {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const LoggingOutScreen()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      color: Colors.white,
      constraints: const BoxConstraints(minWidth: 270, maxWidth: 270),
      tooltip: 'Profile menu',
      onSelected: onSelected,
      icon: const CircleAvatar(
        radius: 18,
        backgroundColor: Colors.black,
        backgroundImage: AssetImage('assets/ikigai_logo.png'),
      ),
      itemBuilder: (context) => [
        PopupMenuItem<String>(
          enabled: false,
          height: 170,
          padding: EdgeInsets.zero,
          child: SizedBox(
            width: double.infinity,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircleAvatar(
                  radius: 32,
                  backgroundColor: Colors.black,
                  backgroundImage: AssetImage('assets/ikigai_logo.png'),
                ),
                const SizedBox(height: 8),
                Text(
                  userName,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF362E4B),
                  ),
                ),
                Text(
                  userEmail,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF645A7A),
                  ),
                ),
                if (age.isNotEmpty)
                  Text(
                    'Age: $age',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF645A7A),
                    ),
                  ),
                if (gender.isNotEmpty)
                  Text(
                    'Gender: $gender',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF645A7A),
                    ),
                  ),
              ],
            ),
          ),
        ),
        const PopupMenuDivider(),
        const PopupMenuItem<String>(
          value: 'edit',
          child: Row(
            children: [
              Icon(Icons.edit_outlined, color: Color(0xFF645887)),
              SizedBox(width: 12),
              Text('Edit Profile'),
            ],
          ),
        ),
        const PopupMenuItem<String>(
          value: 'about',
          child: Row(
            children: [
              Icon(Icons.info_outline, color: Color(0xFF645887)),
              SizedBox(width: 12),
              Text('About'),
            ],
          ),
        ),
        const PopupMenuItem<String>(
          value: 'logout',
          child: Row(
            children: [
              Icon(Icons.logout, color: Colors.redAccent),
              SizedBox(width: 12),
              Text('Logout'),
            ],
          ),
        ),
      ],
    );
  }
}

class LoggingOutScreen extends StatefulWidget {
  const LoggingOutScreen({super.key});

  @override
  State<LoggingOutScreen> createState() => _LoggingOutScreenState();
}

class _LoggingOutScreenState extends State<LoggingOutScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 1500), () async {
      await FirebaseAuth.instance.signOut();
      if (mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const LoginPage()),
          (route) => false,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFFF4EAFF),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(color: Color(0xFF645887)),
            SizedBox(height: 24),
            Text(
              'Logging out...',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: Color(0xFF645A7A),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
