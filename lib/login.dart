import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {

  static const Color lightPurple = Color(0xFFF4EAFF);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightPurple,
      body: const SafeArea(
        child: Center(
          child: SizedBox(),
        ),
      ),
    );
  }
}