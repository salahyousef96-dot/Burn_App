import 'package:flutter/material.dart';
import '../theme/app_text_styles.dart';
import '../widgets/neon_card.dart';
import '../theme/app_colors.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

class _ExerciseData {
  final String title;
  final String details;
  final int totalSets;
  int completedSets;

  _ExerciseData({
    required this.title,
    required this.details,
    required this.totalSets,
    required this.completedSets,
  });
}

class WorkoutScreen extends StatefulWidget {
  const WorkoutScreen({super.key});

  @override
  State<WorkoutScreen> createState() => _WorkoutScreenState();
}

class _WorkoutScreenState extends State<WorkoutScreen> {

  static const String completedSetsKey = 'workout_completed_sets';
  static const String elapsedSecondsKey = 'workout_elapsed_seconds';

  Timer? restTimer;
  int restSeconds = 45;

  bool get isResting => restTimer?.isActive ?? false;

  Timer? workoutTimer;
  int elapsedSeconds = 0;

  String get formattedElapsedTime {
    final minutes = elapsedSeconds ~/ 60;
    final seconds = elapsedSeconds % 60;
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }

  int get caloriesBurned {
    return 234 + completedSets * 18;
  }

  int get averageBpm {
    if (workoutFinished) return 118;
    if (isResting) return 126;
    return 144 + activeExerciseIndex * 3;
  }

  final List<_ExerciseData> exercises = [
    _ExerciseData(
      title: 'Bench Press',
      details: '80 kg · 90s rest',
      totalSets: 4,
      completedSets: 4,
    ),
    _ExerciseData(
      title: 'Incline Dumbbell Press',
      details: '30 kg × 2 · 60s rest',
      totalSets: 4,
      completedSets: 2,
    ),
    _ExerciseData(
      title: 'Cable Fly',
      details: '20 kg · 45s rest',
      totalSets: 3,
      completedSets: 0,
    ),
    _ExerciseData(
      title: 'OHP Barbell',
      details: '45 kg · 90s rest',
      totalSets: 4,
      completedSets: 0,
    ),
  ];

  int get activeExerciseIndex {
    final index = exercises.indexWhere(
          (exercise) => exercise.completedSets < exercise.totalSets,
    );

    if (index == -1) {
      return exercises.length - 1;
    }

    return index;
  }

  int get totalSets {
    return exercises.fold(0, (sum, exercise) => sum + exercise.totalSets);
  }

  int get completedSets {
    return exercises.fold(0, (sum, exercise) => sum + exercise.completedSets);
  }

  bool get workoutFinished => completedSets == totalSets;

  Future<void> saveWorkoutState() async {
    final prefs = await SharedPreferences.getInstance();

    final completedSetsList = exercises
        .map((exercise) => exercise.completedSets.toString())
        .toList();

    await prefs.setStringList(completedSetsKey, completedSetsList);
    await prefs.setInt(elapsedSecondsKey, elapsedSeconds);
  }

  Future<void> loadWorkoutState() async {
    final prefs = await SharedPreferences.getInstance();

    final savedCompletedSets = prefs.getStringList(completedSetsKey);
    final savedElapsedSeconds = prefs.getInt(elapsedSecondsKey);

    if (!mounted) return;

    setState(() {
      if (savedCompletedSets != null &&
          savedCompletedSets.length == exercises.length) {
        for (int i = 0; i < exercises.length; i++) {
          final savedValue = int.tryParse(savedCompletedSets[i]);

          if (savedValue != null) {
            exercises[i].completedSets =
                savedValue.clamp(0, exercises[i].totalSets).toInt();
          }
        }
      }

      if (savedElapsedSeconds != null) {
        elapsedSeconds = savedElapsedSeconds;
      }
    });
  }

  Future<void> resetWorkoutState() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.remove(completedSetsKey);
    await prefs.remove(elapsedSecondsKey);

    restTimer?.cancel();

    if (!mounted) return;

    setState(() {
      elapsedSeconds = 0;

      for (final exercise in exercises) {
        exercise.completedSets = 0;
      }

      restSeconds = 45;
    });
  }

  void startRestTimer() {
    restTimer?.cancel();

    setState(() {
      restSeconds = 45;
    });

    restTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (restSeconds <= 1) {
        timer.cancel();

        setState(() {
          restSeconds = 45;
        });
      } else {
        setState(() {
          restSeconds--;
        });
      }
    });
  }

  void completeSet() {
    if (workoutFinished || isResting) return;

    setState(() {
      final exercise = exercises[activeExerciseIndex];

      if (exercise.completedSets < exercise.totalSets) {
        exercise.completedSets++;
      }
    });

    saveWorkoutState();

    if (workoutFinished) {
      restTimer?.cancel();
      workoutTimer?.cancel();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: AppColors.primaryNeon,
          content: Text(
            'Workout completed successfully!',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
      );
    } else {
      startRestTimer();
    }
  }

  @override
  void initState() {
    super.initState();

    loadWorkoutState();

    workoutTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (workoutFinished) {
        timer.cancel();
        return;
      }

      setState(() {
        elapsedSeconds++;
      });

      if (elapsedSeconds % 5 == 0) {
        saveWorkoutState();
      }
    });
  }

  @override
  void dispose() {
    restTimer?.cancel();
    workoutTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 430),
            child: Stack(
              children: [
                const Positioned.fill(child: _WorkoutBackground()),
                SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(18, 14, 18, 130),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _WorkoutHero(
                        onReset: resetWorkoutState,
                      ),
                      SizedBox(height: 16),
                      _WorkoutSummaryCards(
                        calories: caloriesBurned,
                        averageBpm: averageBpm,
                        elapsedTime: formattedElapsedTime,
                        completedSets: completedSets,
                        totalSets: totalSets,
                      ),
                      SizedBox(height: 18),
                      _SectionHeader(title: 'EXERCISES', action: 'Edit'),
                      SizedBox(height: 10),
                      for (int i = 0; i < exercises.length; i++) ...[
                        _ExerciseCard(
                          number: '${i + 1}',
                          title: exercises[i].title,
                          details: exercises[i].details,
                          completedSets: exercises[i].completedSets,
                          totalSets: exercises[i].totalSets,
                          active: i == activeExerciseIndex && !workoutFinished,
                        ),
                        if (i != exercises.length - 1) const SizedBox(height: 10),
                      ],
                      const SizedBox(height: 16),
                      _RestAndCompleteCard(
                        onCompleteSet: completeSet,
                        workoutFinished: workoutFinished,
                        isResting: isResting,
                        restSeconds: restSeconds,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _WorkoutBackground extends StatelessWidget {
  const _WorkoutBackground();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.background,
        gradient: RadialGradient(
          center: Alignment(0.15, -0.95),
          radius: 0.9,
          colors: [
            Color(0x33284A00),
            Color(0x11000000),
            AppColors.background,
          ],
        ),
      ),
    );
  }
}

class _WorkoutHero extends StatelessWidget {
  final VoidCallback onReset;

  const _WorkoutHero({
    required this.onReset,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 190,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.border),
        boxShadow: const [
          BoxShadow(
            color: Color(0x332CFF00),
            blurRadius: 28,
            offset: Offset(0, 12),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: CustomPaint(
                painter: _WorkoutLinesPainter(),
              ),
            ),
          ),
          GestureDetector(
            onTap: onReset,
            child: Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: const Color(0x88141414),
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0x443CFF00)),
              ),
              child: const Icon(
                Icons.restart_alt,
                color: AppColors.secondaryText,
                size: 18,
              ),
            ),
          ),
          Positioned(
            top: 18,
            right: 18,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
              decoration: BoxDecoration(
                color: AppColors.primaryNeon,
                borderRadius: BorderRadius.circular(999),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x77CCFF00),
                    blurRadius: 16,
                  ),
                ],
              ),
              child: const Text(
                'LIVE',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 11,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ),
          const Positioned(
            left: 18,
            bottom: 24,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'DAY 4 — PUSH DAY',
                  style: TextStyle(
                    color: AppColors.primaryNeon,
                    fontSize: 11,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.5,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Upper Body Strength',
                  style: TextStyle(
                    color: AppColors.text,
                    fontSize: 25,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    _MiniInfo(icon: Icons.timer_outlined, text: '55 min'),
                    SizedBox(width: 12),
                    _MiniInfo(icon: Icons.fitness_center, text: '5 exercises'),
                    SizedBox(width: 12),
                    _MiniInfo(icon: Icons.favorite_border, text: '144 bpm avg'),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MiniInfo extends StatelessWidget {
  final IconData icon;
  final String text;

  const _MiniInfo({
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: AppColors.mutedText, size: 14),
        const SizedBox(width: 4),
        Text(
          text,
          style: const TextStyle(
            color: AppColors.secondaryText,
            fontSize: 11,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class _WorkoutSummaryCards extends StatelessWidget {
  final int calories;
  final int averageBpm;
  final String elapsedTime;
  final int completedSets;
  final int totalSets;

  const _WorkoutSummaryCards({
    required this.calories,
    required this.averageBpm,
    required this.elapsedTime,
    required this.completedSets,
    required this.totalSets,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _SummaryCard(
            title: 'CALORIES',
            value: '$calories',
            subtitle: '$completedSets of $totalSets sets',
            icon: Icons.local_fire_department,
            highlighted: true,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _SummaryCard(
            title: 'BPM',
            value: '$averageBpm',
            subtitle: 'Heart Rate',
            icon: Icons.monitor_heart_outlined,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _SummaryCard(
            title: 'TIME',
            value: elapsedTime,
            subtitle: 'Elapsed',
            icon: Icons.timer_outlined,
          ),
        ),
      ],
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final String title;
  final String value;
  final String subtitle;
  final IconData icon;
  final bool highlighted;

  const _SummaryCard({
    required this.title,
    required this.value,
    required this.subtitle,
    required this.icon,
    this.highlighted = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 126,
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: highlighted ? AppColors.primaryNeon : AppColors.border,
          width: highlighted ? 1.5 : 1,
        ),
        boxShadow: highlighted
            ? const [
          BoxShadow(
            color: Color(0x44CCFF00),
            blurRadius: 18,
            offset: Offset(0, 8),
          ),
        ]
            : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColors.primaryNeon, size: 20),
          const Spacer(),
          Text(
            title,
            style: const TextStyle(
              color: AppColors.mutedText,
              fontSize: 9,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.1,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            value,
            style: const TextStyle(
              color: AppColors.primaryNeon,
              fontSize: 24,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            subtitle,
            style: const TextStyle(
              color: AppColors.secondaryText,
              fontSize: 10,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final String action;

  const _SectionHeader({
    required this.title,
    required this.action,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(title, style: AppTextStyles.sectionTitle),
        const Spacer(),
        Text(
          action,
          style: const TextStyle(
            color: AppColors.primaryNeon,
            fontSize: 11,
            fontWeight: FontWeight.w900,
          ),
        ),
      ],
    );
  }
}

class _ExerciseCard extends StatelessWidget {
  final String number;
  final String title;
  final String details;
  final int completedSets;
  final int totalSets;
  final bool active;

  const _ExerciseCard({
    required this.number,
    required this.title,
    required this.details,
    required this.completedSets,
    required this.totalSets,
    required this.active,
  });

  @override
  Widget build(BuildContext context) {
    final isComplete = completedSets == totalSets;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: active ? AppColors.primaryNeon : AppColors.border,
          width: active ? 1.5 : 1,
        ),
        boxShadow: active
            ? const [
          BoxShadow(
            color: Color(0x33CCFF00),
            blurRadius: 18,
            offset: Offset(0, 8),
          ),
        ]
            : null,
      ),
      child: Row(
        children: [
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: active ? AppColors.primaryNeon : const Color(0xFF263A00),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                number,
                style: TextStyle(
                  color: active ? Colors.black : AppColors.primaryNeon,
                  fontSize: 13,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: AppColors.text,
                    fontSize: 14,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  details,
                  style: const TextStyle(
                    color: AppColors.secondaryText,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: List.generate(totalSets, (index) {
                    final isDone = index < completedSets;

                    return Container(
                      width: 7,
                      height: 7,
                      margin: const EdgeInsets.only(right: 5),
                      decoration: BoxDecoration(
                        color: isDone
                            ? AppColors.primaryNeon
                            : const Color(0xFF2D2D2D),
                        shape: BoxShape.circle,
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '$completedSets/$totalSets',
                style: const TextStyle(
                  color: AppColors.primaryNeon,
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 5),
              Icon(
                isComplete
                    ? Icons.check_circle
                    : active
                    ? Icons.play_circle_fill
                    : Icons.radio_button_unchecked,
                color: isComplete || active
                    ? AppColors.primaryNeon
                    : AppColors.mutedText,
                size: 20,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _RestAndCompleteCard extends StatelessWidget {
  final VoidCallback onCompleteSet;
  final bool workoutFinished;
  final bool isResting;
  final int restSeconds;

  const _RestAndCompleteCard({
    required this.onCompleteSet,
    required this.workoutFinished,
    required this.isResting,
    required this.restSeconds,
  });

  String get formattedRestTime {
    final minutes = restSeconds ~/ 60;
    final seconds = restSeconds % 60;
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final buttonDisabled = workoutFinished || isResting;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            width: 62,
            height: 50,
            decoration: BoxDecoration(
              color: const Color(0xFF1D2607),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  workoutFinished
                      ? 'DONE'
                      : isResting
                      ? 'REST'
                      : 'READY',
                  style: const TextStyle(
                    color: AppColors.mutedText,
                    fontSize: 9,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  workoutFinished
                      ? '✓'
                      : isResting
                      ? formattedRestTime
                      : 'GO',
                  style: const TextStyle(
                    color: AppColors.primaryNeon,
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: GestureDetector(
              onTap: buttonDisabled ? null : onCompleteSet,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                height: 50,
                decoration: BoxDecoration(
                  color: buttonDisabled
                      ? const Color(0xFF2D2D2D)
                      : AppColors.primaryNeon,
                  borderRadius: BorderRadius.circular(999),
                  boxShadow: buttonDisabled
                      ? null
                      : const [
                    BoxShadow(
                      color: Color(0x77CCFF00),
                      blurRadius: 18,
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    workoutFinished
                        ? 'WORKOUT COMPLETE'
                        : isResting
                        ? 'RESTING...'
                        : '✓ COMPLETE SET',
                    style: TextStyle(
                      color: buttonDisabled
                          ? AppColors.secondaryText
                          : Colors.black,
                      fontSize: 13,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _WorkoutLinesPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final neonPaint = Paint()
      ..color = const Color(0x66CCFF00)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);

    final thinPaint = Paint()
      ..color = const Color(0x44ABE600)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    final path = Path()
      ..moveTo(size.width * 0.05, size.height * 0.70)
      ..cubicTo(
        size.width * 0.22,
        size.height * 0.20,
        size.width * 0.42,
        size.height * 0.95,
        size.width * 0.63,
        size.height * 0.30,
      )
      ..cubicTo(
        size.width * 0.74,
        size.height * 0.02,
        size.width * 0.94,
        size.height * 0.18,
        size.width * 0.98,
        size.height * 0.08,
      );

    final secondPath = Path()
      ..moveTo(size.width * 0.15, size.height * 0.18)
      ..cubicTo(
        size.width * 0.30,
        size.height * 0.40,
        size.width * 0.48,
        size.height * 0.08,
        size.width * 0.75,
        size.height * 0.48,
      );

    canvas.drawPath(path, neonPaint);
    canvas.drawPath(path, thinPaint);
    canvas.drawPath(secondPath, neonPaint);
    canvas.drawPath(secondPath, thinPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}