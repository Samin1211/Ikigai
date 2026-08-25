import 'package:flutter/material.dart';
import 'transition_screen.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool hidePassword = true;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final emailFocusNode = FocusNode();
  final passwordFocusNode = FocusNode();
  bool emailFocused = false;
  bool passwordFocused = false;
  String? emailError;

  static const Color lightPurple = Color(0xFFF4EAFF);
  static const Color darkPurple = Color(0xFF362E4B);
  static const Color grayPurple = Color(0xFF645A7A);
  static const Color purpleBorderLight = Color(0x59645887);
  static const Color purpleBorderDark = Color(0xBF645887);
  static const Color whiteBackgroundLight = Color(0x66FEF7FF);
  static const Color whiteBackgroundDark = Color(0xD9FEF7FF);
  static const Color purple = Color(0xFF645887);
  static const Color blue = Color(0xFF5743DF);
  static const Color white = Color(0xFFFDF7FF);
  static const Color purpleShadow = Color(0x40645887);
  static const Color purpleUnderline = Color(0x4D645887);
  static const Color orange = Color(0xFFE65100);

  @override
  void initState() {
    super.initState();
    emailFocusNode.addListener(() {
      setState(() => emailFocused = emailFocusNode.hasFocus);
    });
    passwordFocusNode.addListener(() {
      setState(() => passwordFocused = passwordFocusNode.hasFocus);
    });
    emailController.addListener(() {
      if (emailError != null) setState(() => emailError = null);
    });
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    emailFocusNode.dispose();
    passwordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightPurple,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 360),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 96,
                    height: 96,
                    margin: const EdgeInsets.only(bottom: 20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      color: Colors.white,
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Image.asset(
                      'assets/ikigai_logo.png',
                      fit: BoxFit.cover,
                      filterQuality: FilterQuality.high,
                    ),
                  ),
                  const Text(
                    'Welcome Back',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w600,
                      color: darkPurple,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const SizedBox(
                    width: 260,
                    child: Text(
                      'Enter your details to access your sanctuary.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 14, color: grayPurple),
                    ),
                  ),
                  const SizedBox(height: 20),
                  buildInputField(
                    focusNode: emailFocusNode,
                    controller: emailController,
                    isFocused: emailFocused,
                    hintText: 'Email Address',
                    prefixIcon: Icons.email_outlined,
                  ),
                  if (emailError != null) buildErrorMessage(emailError!),
                  const SizedBox(height: 12),
                  buildInputField(
                    focusNode: passwordFocusNode,
                    controller: passwordController,
                    isFocused: passwordFocused,
                    hintText: 'Password',
                    prefixIcon: Icons.lock_outline,
                    obscureText: hidePassword,
                    suffixIcon: GestureDetector(
                      onTap: () {
                        setState(() => hidePassword = !hidePassword);
                      },
                      child: Icon(
                        hidePassword
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        size: 20,
                        color: grayPurple,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 4),
                      child: GestureDetector(
                        onTap: () {},
                        child: const Text(
                          'Forgot password?',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.5,
                            color: purple,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  buildLoginButton(),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'New to Ikigai? ',
                        style: TextStyle(fontSize: 13, color: grayPurple),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, '/register');
                        },
                        child: Container(
                          decoration: const BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: purpleUnderline,
                                width: 1,
                              ),
                            ),
                          ),
                          child: const Text(
                            'Start your journey',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: purple,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildLoginButton() {
    return Container(
      width: double.infinity,
      height: 48,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [purple, blue],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(9999),
        boxShadow: const [
          BoxShadow(color: purpleShadow, blurRadius: 24, offset: Offset(0, 8)),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(9999),
          onTap: () {
            if (!validateEmail()) return;
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const TransitionScreen()),
            );
          },
          child: const Stack(
            alignment: Alignment.center,
            children: [
              Text(
                'Login',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.5,
                  color: white,
                ),
              ),
              Positioned(
                right: 20,
                child: Icon(Icons.arrow_forward, size: 18, color: white),
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool validateEmail() {
    final email = emailController.text.trim();
    String? error;

    if (email.isEmpty) {
      error = 'Please enter your email address.';
    } else if (RegExp(r'^[A-Z]').hasMatch(email)) {
      error = 'Email must start with a lowercase letter.';
    } else if (!email.contains('@')) {
      error = "Please include an '@' in the email address.";
    } else {
      final parts = email.split('@');
      if (parts[0].isEmpty) {
        error = "Please enter a part before '@'.";
      } else if (parts[1].isEmpty) {
        error = "Please enter a part followed by '@'. Email is incomplete.";
      } else if (!parts[1].contains('.') ||
          parts[1].endsWith('.') ||
          parts[1].startsWith('.')) {
        error = "Email after '@' is incomplete.";
      }
    }

    if (error != null) {
      setState(() => emailError = error);
      return false;
    }
    return true;
  }

  Widget buildErrorMessage(String message) {
    return Padding(
      padding: const EdgeInsets.only(top: 6, left: 16, right: 16),
      child: Row(
        children: [
          Container(
            width: 18,
            height: 18,
            decoration: BoxDecoration(
              color: orange,
              borderRadius: BorderRadius.circular(4),
            ),
            child: const Center(
              child: Text(
                '!',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              message,
              style: const TextStyle(fontSize: 12, color: darkPurple),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildInputField({
    required FocusNode focusNode,
    required TextEditingController controller,
    required bool isFocused,
    required String hintText,
    required IconData prefixIcon,
    bool obscureText = false,
    Widget? suffixIcon,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOut,
      height: 48,
      decoration: BoxDecoration(
        color: isFocused ? whiteBackgroundDark : whiteBackgroundLight,
        borderRadius: BorderRadius.circular(9999),
        border: Border.all(
          color: isFocused ? purpleBorderDark : purpleBorderLight,
          width: isFocused ? 2.0 : 1.5,
        ),
      ),
      child: Row(
        children: [
          const SizedBox(width: 20),
          Icon(prefixIcon, size: 20, color: grayPurple),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              focusNode: focusNode,
              controller: controller,
              obscureText: obscureText,
              keyboardType: keyboardType,
              style: const TextStyle(fontSize: 15, color: darkPurple),
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: const TextStyle(fontSize: 15, color: grayPurple),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
          if (suffixIcon != null)
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [const SizedBox(width: 8), suffixIcon],
            ),
          const SizedBox(width: 20),
        ],
      ),
    );
  }
}
