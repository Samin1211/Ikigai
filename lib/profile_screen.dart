import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'login.dart';
import 'edit_profile.dart';

void showProfileMenu(BuildContext context) async {
  final user = FirebaseAuth.instance.currentUser;
  String userName = 'User Name';
  String userEmail = user?.email ?? 'user@example.com';
  String nickname = '';
  String age = '';
  String gender = '';

  if (user != null) {
    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();
    if (doc.exists) {
      final data = doc.data()!;
      userName = data['name'] ?? 'User Name';
      nickname = data['nickname'] ?? '';
      age = data['age'] ?? '';
      gender = data['gender'] ?? '';
    }
  }

  if (!context.mounted) return;

  showDialog(
    context: context,
    barrierColor: Colors.transparent,
    builder: (context) {
      return Stack(
        children: [
          // Invisible barrier to close on tap outside
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(color: Colors.transparent),
          ),
          // Profile menu card
          Positioned(
            top: 80,
            right: 16,
            child: Material(
              color: Colors.transparent,
              child: Container(
                width: 240,
                padding: const EdgeInsets.symmetric(
                  vertical: 20,
                  horizontal: 16,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFFDF7FF),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.15),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Profile image
                    CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.black,
                      backgroundImage: const AssetImage(
                        'assets/ikigai_logo.png',
                      ),
                    ),
                    const SizedBox(height: 12),
                    // User name
                    Text(
                      userName,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF362E4B),
                      ),
                    ),
                    const SizedBox(height: 4),
                    // User email
                    Text(
                      userEmail,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Color(0xFF645A7A),
                      ),
                    ),
                    // Conditional profile details
                    if (nickname.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          'Nickname: $nickname',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF645A7A),
                          ),
                        ),
                      ),
                    if (age.isNotEmpty || gender.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 2),
                        child: Text(
                          [
                            if (age.isNotEmpty) 'Age: $age',
                            if (gender.isNotEmpty) gender,
                          ].join(' · '),
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF645A7A),
                          ),
                        ),
                      ),
                    const SizedBox(height: 16),
                    // Edit Profile
                    ListTile(
                      dense: true,
                      leading: const Icon(
                        Icons.edit_outlined,
                        color: Color(0xFF645887),
                      ),
                      title: const Text(
                        'Edit Profile',
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF362E4B),
                        ),
                      ),
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const EditProfilePage(),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 8),
                    // About
                    ListTile(
                      dense: true,
                      leading: const Icon(
                        Icons.info_outline,
                        color: Color(0xFF645887),
                      ),
                      title: const Text(
                        'About',
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF362E4B),
                        ),
                      ),
                      onTap: () {
                        Navigator.pop(context);
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              backgroundColor: const Color(0xFFFDF7FF),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    width: 64,
                                    height: 64,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(16),
                                      color: Colors.white,
                                    ),
                                    clipBehavior: Clip.antiAlias,
                                    child: Image.asset(
                                      'assets/ikigai_logo.png',
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  const Text(
                                    'Ikigai',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF362E4B),
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  const Text(
                                    'Version 1.0.0',
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Color(0xFF645A7A),
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  const Text(
                                    'A flutter based productivity application.',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Color(0xFF645A7A),
                                    ),
                                  ),
                                ],
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text(
                                    'Close',
                                    style: TextStyle(color: Color(0xFF645887)),
                                  ),
                                ),
                              ],
                            );
                          },
                        );
                      },
                    ),
                    const SizedBox(height: 8),
                    // Logout
                    ListTile(
                      dense: true,
                      leading: const Icon(
                        Icons.logout,
                        color: Colors.redAccent,
                      ),
                      title: const Text(
                        'Logout',
                        style: TextStyle(fontSize: 14, color: Colors.redAccent),
                      ),
                      onTap: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const LoggingOutScreen(),
                          ),
                          (route) => false,
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      );
    },
  );
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
