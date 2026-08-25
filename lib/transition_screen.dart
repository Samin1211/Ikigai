import 'package:flutter/material.dart';

class TransitionScreen extends StatefulWidget {
  const TransitionScreen({super.key});

  @override
  State<TransitionScreen> createState() => _TransitionScreenState();
}

class _TransitionScreenState extends State<TransitionScreen>
    with TickerProviderStateMixin {
  static const Color lightPurple = Color(0xFFF4EAFF);
  static const Color purple = Color(0xFF645887);
  static const Color grayPurple = Color(0xFF645A7A);

  late final List<AnimationController> rippleControllers;
  late final AnimationController textController;

  @override
  void initState() {
    super.initState();

    rippleControllers = List.generate(
      4,
      (_) => AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 1600),
      ),
    );

    for (int i = 0; i < 4; i++) {
      Future.delayed(Duration(milliseconds: i * 320), () {
        if (mounted) rippleControllers[i].repeat();
      });
    }

    textController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    )..forward();

    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted) {
        Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
      }
    });
  }

  @override
  void dispose() {
    for (final c in rippleControllers) {
      c.dispose();
    }
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightPurple,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 120,
              height: 120,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  for (int i = 0; i < 4; i++) buildRipple(i),
                  Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: purple.withValues(alpha: 0.7),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            AnimatedBuilder(
              animation: textController,
              builder: (_, child) {
                return Opacity(
                  opacity: textController.value,
                  child: Transform.translate(
                    offset: Offset(0, 6 * (1 - textController.value)),
                    child: child,
                  ),
                );
              },
              child: const Text(
                'Logging in\u2026',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.52,
                  color: grayPurple,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildRipple(int index) {
    final curved = CurvedAnimation(
      parent: rippleControllers[index],
      curve: const Cubic(0.2, 0.6, 0.4, 1.0),
    );
    return AnimatedBuilder(
      animation: curved,
      builder: (_, _) {
        return Opacity(
          opacity: 0.55 * (1.0 - curved.value),
          child: Transform.scale(
            scale: curved.value,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: purple, width: 1.5),
              ),
            ),
          ),
        );
      },
    );
  }
}
