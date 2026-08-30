import 'dart:async';
import 'package:flutter/material.dart';

class PomodoroColors {
  static const Color base = Color(0xFF645887);
  static const Color base_white = Color(0xFFFDF7FF);
  static const Color base_container = Color(0xFFD3C4FA);
  static const Color base_container2 = Color(0xFF483D69);
  static const Color blue = Color(0xFF5743DF);
  static const Color white = Color(0xFFFEF7FF);
  static const Color light_white1 = Color(0xFFF4EAFF);
  static const Color light_white2 = Color(0xFFEADDFF);
  static const Color dark_purple = Color(0xFF362E4B);
  static const Color light_purple = Color(0xFF645A7A);
  static const Color border = Color(0xFF807597);
}

enum TimerState { stopped, running, paused }

class PomodoroPage extends StatefulWidget {
  const PomodoroPage({super.key});

  @override
  State<PomodoroPage> createState() => PomodoroPageState();
}

class PomodoroPageState extends State<PomodoroPage> {
  TimerState state = TimerState.stopped;

  static const int totalSeconds = 25 * 60;
  int seconds = totalSeconds;

  Timer? timer;
  Timer? holdTimer;

  bool holding = false;
  bool finishedHold = false;

  void startTimer() {
    setState(() {
      state = TimerState.running;
    });

    timer?.cancel();

    timer = Timer.periodic(
      const Duration(seconds: 1),
          (context) {
        if (seconds > 0) {
          setState(() {
            seconds--;
          });
        } else {
          stopTimer();
        }
      },
    );
  }

  void pauseTimer() {
    timer?.cancel();

    setState(() {
      state = TimerState.paused;
    });
  }

  void stopTimer() {
    timer?.cancel();

    setState(() {
      state = TimerState.stopped;
      seconds = totalSeconds;
    });
  }

  void tapDown() {
    finishedHold = false;

    if (state == TimerState.running || state == TimerState.paused) {
      setState(() {
        holding = true;
      });

      holdTimer = Timer(
        const Duration(seconds: 2),
            () {
          finishedHold = true;

          if (state == TimerState.running) {
            pauseTimer();
          } else {
            stopTimer();
          }

          setState(() {
            holding = false;
          });
        },
      );
    }
  }

  void tapUp() {
    holdTimer?.cancel();

    if (holding) {
      setState(() {
        holding = false;
      });
    }
  }

  void tap() {
    if (finishedHold) {
      finishedHold = false;
      return;
    }

    if (state == TimerState.stopped || state == TimerState.paused) {
      startTimer();
    }
  }

  String get time {
    double result = seconds/60;
    int minutes = result.toInt();
    int secs = seconds % 60;
    String showTime = "${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}";

    return showTime;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PomodoroColors.light_white1,
      appBar: AppBar(
        backgroundColor: PomodoroColors.light_white2,
        elevation: 0,
        titleSpacing: 24,
        title: const Text(
          'Ikigai',
          style: TextStyle(
            fontFamily: 'Epilogue',
            fontWeight: FontWeight.w800,
            fontSize: 20,
            color: PomodoroColors.base,
          ),
        ),
      ),

      body: Column(
        children: [
          const SizedBox(height: 32),
          const Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                'Focus\nSession.',
                style: TextStyle(
                  fontFamily: 'Epilogue',
                  fontWeight: FontWeight.w800,
                  fontSize: 40,
                  color: PomodoroColors.base,
                ),
              ),
            ),
          ),

          const SizedBox(height: 85),

          GestureDetector(
            onTap: tap,
            onTapDown: (context) => tapDown(),
            onTapUp: (context) => tapUp(),
            onTapCancel: tapUp,

            child: AnimatedScale(
              scale: holding ? 1.05 : 1.0,
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOut,

              child: Container(
                width: 280,
                height: 280,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: PomodoroColors.base_container,
                  boxShadow: [
                    BoxShadow(
                      color: PomodoroColors.base.withValues(alpha: 0.2),
                      blurRadius: 30,
                      spreadRadius: 5,
                    )
                  ],
                ),

                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    if (state == TimerState.stopped)
                      const Text(
                        'Start',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: PomodoroColors.dark_purple,
                        ),
                      )
                    else if (state == TimerState.paused)
                      const Text(
                        'Paused',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: PomodoroColors.dark_purple,
                        ),
                      )
                    else
                      Text(
                        time,
                        style: const TextStyle(
                          fontSize: 56,
                          fontWeight: FontWeight.bold,
                          color: PomodoroColors.dark_purple,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),

          const SizedBox(height: 40),

          AnimatedOpacity(
            opacity: state==TimerState.stopped? 0:1,
            duration: const Duration(milliseconds: 300),
            child: Text(
              state == TimerState.paused
                  ? 'Tap to Resume, Hold to Stop'
                  : 'Hold for 2s to Pause',
              style: const TextStyle(
                fontFamily: 'PlusJakartaSans',
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: PomodoroColors.border,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

