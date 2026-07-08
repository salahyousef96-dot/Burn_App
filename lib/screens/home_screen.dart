import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../widgets/neon_card.dart';


class BurnHomeScreen extends StatelessWidget {
  const BurnHomeScreen({super.key});

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
                const Positioned.fill(
                  child: _BackgroundGlow(),
                ),
                SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(18, 14, 18, 130),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      _HeroHeader(),
                      SizedBox(height: 18),
                      _GoalCard(),
                      SizedBox(height: 14),
                      _StreakCard(),
                      SizedBox(height: 14),
                      _TodayNumbersGrid(),
                      SizedBox(height: 14),
                      _UpNextCard(),
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

class _BackgroundGlow extends StatelessWidget {
  const _BackgroundGlow();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.background,
        gradient: RadialGradient(
          center: Alignment(-0.25, -1.0),
          radius: 0.85,
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

class _HeroHeader extends StatelessWidget {
  const _HeroHeader();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 185,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: AppColors.surface,
        border: Border.all(color: AppColors.border),
        boxShadow: const [
          BoxShadow(
            color: Color(0x332CFF00),
            blurRadius: 30,
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
                painter: _NeonLinesPainter(),
              ),
            ),
          ),
          Positioned(
            top: 18,
            left: 18,
            child: Text(
              'BURN',
              style: TextStyle(
                color: AppColors.primaryNeon,
                fontSize: 18,
                fontWeight: FontWeight.w900,
                letterSpacing: 1.2,
              ),
            ),
          ),
          Positioned(
            top: 18,
            right: 18,
            child: Row(
              children: [
                _CircleIcon(icon: Icons.notifications_none),
                SizedBox(width: 10),
                _CircleIcon(icon: Icons.person_outline),
              ],
            ),
          ),
          Positioned(
            left: 18,
            bottom: 26,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'GOOD MORNING',
                  style: TextStyle(
                    color: AppColors.primaryNeon,
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 2,
                  ),
                ),
                SizedBox(height: 7),
                Text(
                  'Alex Rivera',
                  style: TextStyle(
                    color: AppColors.text,
                    fontSize: 26,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Thursday, July 10 · Week 28',
                  style: TextStyle(
                    color: AppColors.secondaryText,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _GoalCard extends StatelessWidget {
  const _GoalCard();

  @override
  Widget build(BuildContext context) {
    return NeonCard(
      child: Row(
        children: [
          const _ProgressRing(progress: 0.74),
          const SizedBox(width: 22),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  "TODAY'S GOAL",
                  style: AppTextStyles.smallTitle,
                ),
                SizedBox(height: 12),
                _MetricLine(
                  color: AppColors.primaryNeon,
                  value: '487',
                  label: 'kcal / 660',
                ),
                SizedBox(height: 8),
                _MetricLine(
                  color: AppColors.blue,
                  value: '148',
                  label: 'bpm avg',
                ),
                SizedBox(height: 8),
                _MetricLine(
                  color: AppColors.orange,
                  value: '38',
                  label: 'min active',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ProgressRing extends StatelessWidget {
  final double progress;

  const _ProgressRing({required this.progress});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 118,
      height: 118,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: 105,
            height: 105,
            child: CircularProgressIndicator(
              value: progress,
              strokeWidth: 10,
              backgroundColor: const Color(0xFF242424),
              valueColor: const AlwaysStoppedAnimation(AppColors.primaryNeon),
              strokeCap: StrokeCap.round,
            ),
          ),
          SizedBox(
            width: 82,
            height: 82,
            child: CircularProgressIndicator(
              value: 0.88,
              strokeWidth: 7,
              backgroundColor: const Color(0xFF242424),
              valueColor: const AlwaysStoppedAnimation(AppColors.blue),
              strokeCap: StrokeCap.round,
            ),
          ),
          SizedBox(
            width: 62,
            height: 62,
            child: CircularProgressIndicator(
              value: 0.45,
              strokeWidth: 6,
              backgroundColor: const Color(0xFF242424),
              valueColor: const AlwaysStoppedAnimation(AppColors.orange),
              strokeCap: StrokeCap.round,
            ),
          ),
          Text(
            '${(progress * 100).round()}%',
            style: const TextStyle(
              color: AppColors.primaryNeon,
              fontSize: 25,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}

class _MetricLine extends StatelessWidget {
  final Color color;
  final String value;
  final String label;

  const _MetricLine({
    required this.color,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 7,
          height: 7,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: color,
                blurRadius: 10,
              ),
            ],
          ),
        ),
        const SizedBox(width: 9),
        Text(
          value,
          style: TextStyle(
            color: color,
            fontSize: 18,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            label,
            style: const TextStyle(
              color: AppColors.secondaryText,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}

class _StreakCard extends StatelessWidget {
  const _StreakCard();

  @override
  Widget build(BuildContext context) {
    final days = ['MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT', 'SUN'];

    return NeonCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('CHECK-IN STREAK', style: AppTextStyles.smallTitle),
          const SizedBox(height: 12),
          Row(
            children: [
              const Text(
                '23',
                style: TextStyle(
                  color: AppColors.primaryNeon,
                  fontSize: 38,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(width: 8),
              const Expanded(
                child: Text(
                  'days streak 🔥',
                  style: TextStyle(
                    color: AppColors.secondaryText,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 13, vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFF365000),
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(color: AppColors.primaryNeon),
                ),
                child: const Text(
                  'PERSONAL BEST',
                  style: TextStyle(
                    color: AppColors.primaryNeon,
                    fontSize: 10,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(days.length, (index) {
              final active = index < 5;
              return Column(
                children: [
                  Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      color: active
                          ? AppColors.primaryNeon
                          : const Color(0xFF252525),
                      shape: BoxShape.circle,
                      boxShadow: active
                          ? const [
                        BoxShadow(
                          color: Color(0x66CCFF00),
                          blurRadius: 12,
                        ),
                      ]
                          : null,
                    ),
                    child: Icon(
                      Icons.check,
                      size: 16,
                      color: active ? Colors.black : AppColors.mutedText,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    days[index],
                    style: TextStyle(
                      color: active
                          ? AppColors.secondaryText
                          : AppColors.mutedText,
                      fontSize: 9,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }
}

class _TodayNumbersGrid extends StatelessWidget {
  const _TodayNumbersGrid();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Text("TODAY'S NUMBERS", style: AppTextStyles.smallTitle),
        SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: _StatCard(
                title: 'CALORIES',
                value: '487',
                subtitle: 'of 660 kcal',
                progress: 0.74,
                color: AppColors.primaryNeon,
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: _StatCard(
                title: 'HEART RATE',
                value: '148',
                subtitle: 'bpm · Zone 4',
                progress: 0.72,
                color: AppColors.orange,
              ),
            ),
          ],
        ),
        SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _StatCard(
                title: 'VOLUME',
                value: '12k',
                subtitle: 'kg lifted',
                progress: 0.82,
                color: AppColors.primaryNeon,
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: _StatCard(
                title: 'RECOVERY',
                value: '82',
                subtitle: 'HRV score',
                progress: 0.68,
                color: AppColors.primaryNeon,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final String subtitle;
  final double progress;
  final Color color;

  const _StatCard({
    required this.title,
    required this.value,
    required this.subtitle,
    required this.progress,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return NeonCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AppTextStyles.smallTitle),
          const SizedBox(height: 10),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 30,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            subtitle,
            style: const TextStyle(
              color: AppColors.secondaryText,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 4,
              backgroundColor: const Color(0xFF2D2D2D),
              valueColor: AlwaysStoppedAnimation(color),
            ),
          ),
        ],
      ),
    );
  }
}

class _UpNextCard extends StatelessWidget {
  const _UpNextCard();

  @override
  Widget build(BuildContext context) {
    return NeonCard(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: const Color(0xFF263A00),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.primaryNeon),
            ),
            child: const Icon(
              Icons.fitness_center,
              color: AppColors.primaryNeon,
            ),
          ),
          const SizedBox(width: 14),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('UP NEXT', style: AppTextStyles.smallTitle),
                SizedBox(height: 6),
                Text(
                  'Upper Body Strength',
                  style: TextStyle(
                    color: AppColors.text,
                    fontSize: 15,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  '55 min · 5 exercises · 18 sets',
                  style: TextStyle(
                    color: AppColors.secondaryText,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: AppColors.primaryNeon,
              borderRadius: BorderRadius.circular(999),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x77CCFF00),
                  blurRadius: 18,
                ),
              ],
            ),
            child: const Text(
              'START',
              style: TextStyle(
                color: Colors.black,
                fontSize: 12,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ],
      ),
    );
  }
}




class _CircleIcon extends StatelessWidget {
  final IconData icon;

  const _CircleIcon({required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 34,
      height: 34,
      decoration: BoxDecoration(
        color: const Color(0x88141414),
        shape: BoxShape.circle,
        border: Border.all(color: const Color(0x443CFF00)),
      ),
      child: Icon(
        icon,
        color: AppColors.secondaryText,
        size: 18,
      ),
    );
  }
}

class _NeonLinesPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final neonPaint = Paint()
      ..color = const Color(0x77CCFF00)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.2
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);

    final thinPaint = Paint()
      ..color = const Color(0x44ABE600)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.1;

    final path = Path()
      ..moveTo(size.width * 0.10, size.height * 0.25)
      ..cubicTo(
        size.width * 0.30,
        size.height * 0.02,
        size.width * 0.53,
        size.height * 0.62,
        size.width * 0.82,
        size.height * 0.12,
      )
      ..cubicTo(
        size.width * 0.95,
        size.height * 0.02,
        size.width * 0.98,
        size.height * 0.20,
        size.width * 0.70,
        size.height * 0.42,
      );

    final secondPath = Path()
      ..moveTo(size.width * 0.04, size.height * 0.52)
      ..cubicTo(
        size.width * 0.22,
        size.height * 0.38,
        size.width * 0.43,
        size.height * 0.80,
        size.width * 0.62,
        size.height * 0.36,
      )
      ..cubicTo(
        size.width * 0.76,
        size.height * 0.05,
        size.width * 0.94,
        size.height * 0.47,
        size.width,
        size.height * 0.28,
      );

    canvas.drawPath(path, neonPaint);
    canvas.drawPath(path, thinPaint);
    canvas.drawPath(secondPath, neonPaint);
    canvas.drawPath(secondPath, thinPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}