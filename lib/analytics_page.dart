import 'package:flutter/material.dart';
import 'dart:math' as math;

class InsightsColors {
  static const Color lightpurple = Color(0xFF645887);
  static const Color white = Color(0xFFFDF7FF);
  static const Color lightpurple2 = Color(0xFFD3C4FA);
  static const Color darkpurple = Color(0xFF483D69);

  static const Color lightblue = Color(0xFF5743DF);
  static const Color containerbg = Color(0xFFE4DFFF);
  static const Color darkblue = Color(0xFF4932D1);

  static const Color offwhite = Color(0xFFF4EAFF);
  static const Color offwhite2 = Color(0xFFF9F1FF);
  static const Color surface = Color(0xFFEADDFF);
}

class InsightsPage extends StatefulWidget {
  const InsightsPage({super.key});

  @override
  State<InsightsPage> createState() => InsightsPageState();
}

class InsightsPageState extends State<InsightsPage> {

  double dailyGoalHours = 6.0;
  bool showStreakToast = false;

  final List<double> weeklyHours = [
    3.5,
    4.2,
    3.0,
    5.0,
    6.5,
    4.0,
    5.8,
  ];

  final List<String> weekDays = [
    'Mon',
    'Tue',
    'Wed',
    'Thu',
    'Fri',
    'Sat',
    'Sun',
  ];

  final double focusedHoursToday = 4.56;
  final int streakDays = 3;
  final double previousWeekTotal = 30.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: InsightsColors.white,

      appBar: AppBar(
        backgroundColor: InsightsColors.offwhite,
        elevation: 0,
        titleSpacing: 24,

        title: const Text(
          'Ikigai',
          style: TextStyle(
            fontFamily: 'Epilogue',
            fontWeight: FontWeight.w800,
            fontSize: 20,
            color: InsightsColors.lightpurple,
          ),
        ),

        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 24),
            child: Icon(
              Icons.account_circle_outlined,
              color: InsightsColors.lightpurple,
              size: 30,
            ),
          ),
        ],
      ),

      body: Stack(
        children: [

          SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(
              24,
              24,
              24,
              100,
            ),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [

                const Text(
                  'Your Focus\nTrends.',
                  style: TextStyle(
                    fontFamily: 'Epilogue',
                    fontWeight: FontWeight.w800,
                    fontSize: 40,
                    color: InsightsColors.lightpurple,
                    height: 1.15,
                  ),
                ),

                const SizedBox(height: 24),

                buildPerformanceCard(),

                const SizedBox(height: 24),

                buildFocusRingCard(),

                const SizedBox(height: 24),

                buildActiveMinutesCard(),
              ],
            ),
          ),

          buildFloatingButtons(),
        ],
      ),
    );
  }

  Widget buildPerformanceCard() {
    double total = 0;

    for (double hours in weeklyHours) {
      total += hours;
    }

    double difference = total - previousWeekTotal;

    String status = 'On Pace';
    String description = 'You are matching your weekly pace exactly.';

    if (difference > 0) {
      status = 'On Track';

      description =
      'You are ${difference.toStringAsFixed(0)} hours ahead of your weekly pace.';
    }
    else if (difference < 0) {
      status = 'Behind';

      description =
      'You are ${(-difference).toStringAsFixed(0)} hours behind your weekly pace.';
    }

    return Container(
      padding: const EdgeInsets.all(24),

      decoration: BoxDecoration(
        color: InsightsColors.containerbg,
        borderRadius: BorderRadius.circular(16),
      ),

      child: Row(
        children: [

          Container(
            width: 64,
            height: 64,

            decoration: BoxDecoration(
              color: InsightsColors.white,
              borderRadius: BorderRadius.circular(16),
            ),

            child: const Icon(
              Icons.self_improvement,
              color: InsightsColors.lightblue,
              size: 30,
            ),
          ),

          const SizedBox(width: 20),

          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [

                const Text(
                  'PERFORMANCE',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                    letterSpacing: 2,
                    color: InsightsColors.darkblue,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  status,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 20,
                    color: InsightsColors.darkblue,
                  ),
                ),

                const SizedBox(height: 2),

                Text(
                  description,
                  style: TextStyle(
                    fontSize: 14,
                    color: InsightsColors.darkblue.withValues(
                      alpha: 0.8,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildFocusRingCard() {

    double progress = focusedHoursToday / dailyGoalHours;

    if (progress > 1) {
      progress = 1;
    }

    int percent = (progress * 100).round();

    String message = 'Start a focus session to build momentum.';

    if (progress >= 1) {
      message = 'Congratulations! You met your daily focus target!';
    }
    else if (progress >= 0.7) {
      message = 'You are on track to meet your daily focus target.';
    }
    else if (progress >= 0.4) {
      message = 'Keep going! You\'re making progress.';
    }

    return Container(
      padding: const EdgeInsets.all(24),

      decoration: BoxDecoration(
        color: InsightsColors.offwhite2,
        borderRadius: BorderRadius.circular(16),

        border: Border.all(
          color: InsightsColors.containerbg,
        ),
      ),

      child: Column(
        children: [

          const Align(
            alignment: Alignment.centerLeft,

            child: Text(
              'FOCUS RING',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 12,
                letterSpacing: 2,
                color: Colors.black54,
              ),
            ),
          ),

          const SizedBox(height: 4),

          Align(
            alignment: Alignment.topLeft,
            child: Text(
              '${dailyGoalHours.round()}h Goal',
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 22,
                color: InsightsColors.lightblue,
              ),
            ),
          ),

          const SizedBox(height: 16),

          SizedBox(
            width: 200,
            height: 200,

            child: CustomPaint(

              painter: FocusRingPainter(
                progress: progress,
                trackColor: InsightsColors.surface,
                progressColor: InsightsColors.lightblue,
              ),

              child: Center(

                child: Column(
                  mainAxisSize: MainAxisSize.min,

                  children: [

                    Text(
                      '$percent%',
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 24,
                        color: InsightsColors.darkpurple,
                      ),
                    ),

                    const Text(
                      'DAILY GOAL',
                      style: TextStyle(
                        fontSize: 10,
                        letterSpacing: 1,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          const SizedBox(height: 12),

          Text(
            message,
            textAlign: TextAlign.center,

            style: const TextStyle(
              fontSize: 12,
              color: Colors.black,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildActiveMinutesCard() {

    double totalHours = 0;
    double maxHours = 0;
    int peakIndex = 0;

    for (int i = 0; i < weeklyHours.length; i++) {

      totalHours += weeklyHours[i];

      if (weeklyHours[i] > maxHours) {
        maxHours = weeklyHours[i];
        peakIndex = i;
      }
    }

    double totalMinutes = totalHours * 60;
    String peakDay = weekDays[peakIndex];

    return Container(
      padding: const EdgeInsets.all(24),

      decoration: BoxDecoration(
        color: InsightsColors.offwhite2,
        borderRadius: BorderRadius.circular(16),

        border: Border.all(
          color: InsightsColors.containerbg,
        ),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [

          const Text(
            'ACTIVE MINUTES',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 12,
              letterSpacing: 2,
              color: Colors.black,
            ),
          ),

          const SizedBox(height: 4),

          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,

            children: [

              Text(
                '${totalMinutes.round()}',
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 28,
                  color: InsightsColors.lightpurple,
                ),
              ),

              const SizedBox(width: 4),

              const Text(
                'min',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),
          SizedBox(
            height: 96,

            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,

              children: List.generate(
                weeklyHours.length,
                    (i) {
                  double fraction = 0;
                  if (maxHours > 0) {
                    fraction =
                        weeklyHours[i] / maxHours;
                  }
                  bool isPeak =
                      weeklyHours[i] == maxHours;
                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 4,
                      ),
                      child: Container(
                        height: 96 * fraction,
                        decoration: BoxDecoration(
                          color: isPeak
                              ? InsightsColors.lightpurple
                              : InsightsColors.lightpurple2,
                          borderRadius:
                          BorderRadius.circular(999),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),

          const SizedBox(height: 16),

          Text(
            'Peak focus on $peakDay',

            style: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 12,
              color: InsightsColors.lightpurple,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildFloatingButtons() {
    return Positioned(
      right: 25,
      bottom: 25,

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (showStreakToast)
            Container(
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.all(16),
              width: 190,
              decoration: BoxDecoration(
                color: InsightsColors.lightpurple2,
                borderRadius: BorderRadius.circular(16),
              ),

              child: Text(
                "Congratulations!\nYou have $streakDays days streak!",
                style: const TextStyle(
                  fontSize: 14,
                  color: InsightsColors.darkpurple,
                ),
              ),
            ),

          const SizedBox(height: 16),

          GestureDetector(
            onTap: toggleStreakToast,
            child: Container(
              width: 56,
              height: 56,

              decoration: const BoxDecoration(
                color: InsightsColors.lightpurple,
                shape: BoxShape.circle,
              ),

              child: const Icon(
                Icons.trending_up,
                color: InsightsColors.white,
                size: 28,
              ),
            ),
          ),

          const SizedBox(height: 16),

          GestureDetector(

            onTap: showGoalDialog,

            child: Container(
              width: 56,
              height: 56,

              decoration: const BoxDecoration(
                color: InsightsColors.lightpurple,
                shape: BoxShape.circle,
              ),

              child: const Icon(
                Icons.add,
                color: InsightsColors.white,
                size: 28,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void toggleStreakToast() {

    setState(() {
      showStreakToast = !showStreakToast;
    });

    if (showStreakToast) {

      Future.delayed(
        const Duration(seconds: 3),
            () {
          setState(() {
            showStreakToast = false;
          });

        },
      );
    }
  }
  void showGoalDialog() {
    double tempGoal = dailyGoalHours;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),

              title: Row(
                mainAxisAlignment:
                MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Set Today's Goal",
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 22,
                      color: InsightsColors.lightpurple,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: const Icon(
                      Icons.close,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),

              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'How many hours would you like to focus today?',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  Row(
                    children: [
                      Expanded(
                        child: Slider(
                          value: tempGoal,
                          min: 1,
                          max: 12,
                          divisions: 11,
                          activeColor: InsightsColors.lightpurple,
                          inactiveColor: InsightsColors.lightpurple2,
                          onChanged: (value) {
                            setDialogState(() {
                              tempGoal = value;
                            });
                          },
                        ),
                      ),

                      Text(
                        '${tempGoal.round()}h',
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 20,
                          color: InsightsColors.lightpurple,
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              actions: [
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        dailyGoalHours = tempGoal;
                      });
                      Navigator.pop(context);
                    },

                    style: ElevatedButton.styleFrom(
                      backgroundColor: InsightsColors.lightpurple,
                      foregroundColor: InsightsColors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(999),
                      ),

                      padding:
                      const EdgeInsets.symmetric(
                        vertical: 16,
                      ),
                    ),

                    child: const Text(
                      'Save Goal',
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}

class FocusRingPainter extends CustomPainter {
  final double progress;
  final Color trackColor;
  final Color progressColor;
  FocusRingPainter({
    required this.progress,
    required this.trackColor,
    required this.progressColor,
  });

  @override
  void paint(
      Canvas canvas,
      Size size,
      ) {
    double radius = math.min(size.width, size.height) * 0.4;
    Paint track = Paint()
      ..color = trackColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8;
    Paint progressPaint = Paint()
      ..color = progressColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8
      ..strokeCap = StrokeCap.round;
    Offset center = Offset(
      size.width / 2,
      size.height / 2,
    );
    canvas.drawCircle(
      center,
      radius,
      track,
    );
    canvas.drawArc(
      Rect.fromCircle(
        center: center,
        radius: radius,
      ),
      -math.pi / 2,
      2 * math.pi * progress,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(
      FocusRingPainter old,
      ) {
    return old.progress != progress;
  }
}