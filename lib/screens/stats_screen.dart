import 'package:flutter/material.dart';
import '../theme/app_text_styles.dart';
import '../widgets/neon_card.dart';
import '../theme/app_colors.dart';

class StatsScreen extends StatelessWidget {
  const StatsScreen({super.key});

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
                const Positioned.fill(child: _StatsBackground()),
                SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(18, 14, 18, 130),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      _StatsHeader(),
                      SizedBox(height: 16),
                      _WeeklyActivityCard(),
                      SizedBox(height: 14),
                      _TodaySummaryGrid(),
                      SizedBox(height: 14),
                      _HeartRateZonesCard(),
                      SizedBox(height: 14),
                      _HRVScoreCard(),
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

class _StatsBackground extends StatelessWidget {
  const _StatsBackground();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.background,
        gradient: RadialGradient(
          center: Alignment(0.15, -0.9),
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

class _StatsHeader extends StatelessWidget {
  const _StatsHeader();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 135,
      padding: const EdgeInsets.all(20),
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
            child: CustomPaint(
              painter: _StatsLinePainter(),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'STATS',
                style: TextStyle(
                  color: AppColors.text,
                  fontSize: 31,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 14),
              Row(
                children: const [
                  _PeriodChip(label: '7D', active: true),
                  SizedBox(width: 8),
                  _PeriodChip(label: '30D'),
                  SizedBox(width: 8),
                  _PeriodChip(label: '3M'),
                  SizedBox(width: 8),
                  _PeriodChip(label: 'YTD'),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PeriodChip extends StatelessWidget {
  final String label;
  final bool active;

  const _PeriodChip({
    required this.label,
    this.active = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 8),
      decoration: BoxDecoration(
        color: active ? AppColors.primaryNeon : const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: active ? AppColors.primaryNeon : AppColors.border,
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: active ? Colors.black : AppColors.secondaryText,
          fontSize: 10,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}

class _WeeklyActivityCard extends StatelessWidget {
  const _WeeklyActivityCard();

  @override
  Widget build(BuildContext context) {
    return NeonCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text('WEEKLY ACTIVITY', style: AppTextStyles.smallTitle),
          SizedBox(height: 18),
          _BarChart(),
          SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _DayLabel('M'),
              _DayLabel('T'),
              _DayLabel('W'),
              _DayLabel('T'),
              _DayLabel('F'),
              _DayLabel('S'),
              _DayLabel('S'),
            ],
          ),
        ],
      ),
    );
  }
}

class _BarChart extends StatelessWidget {
  const _BarChart();

  static const List<double> values = [
    0.45,
    0.72,
    0.20,
    0.58,
    0.68,
    0.82,
    0.50,
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 150,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: List.generate(values.length, (index) {
          final value = values[index];

          return Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6),
              child: Container(
                height: 130 * value,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  gradient: const LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      Color(0xFF6F9400),
                      AppColors.primaryNeon,
                      Color(0xFFFFFFFF),
                    ],
                  ),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x77CCFF00),
                      blurRadius: 16,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}

class _DayLabel extends StatelessWidget {
  final String label;

  const _DayLabel(this.label);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Center(
        child: Text(
          label,
          style: const TextStyle(
            color: AppColors.mutedText,
            fontSize: 10,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
    );
  }
}

class _TodaySummaryGrid extends StatelessWidget {
  const _TodaySummaryGrid();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: const [
        Expanded(
          child: _MiniMetricCard(
            title: 'TODAY KJ',
            value: '847',
            subtitle: 'daily goal',
            icon: Icons.local_fire_department,
          ),
        ),
        SizedBox(width: 12),
        Expanded(
          child: _MiniMetricCard(
            title: 'PEAK HR',
            value: '168',
            subtitle: 'max recorded',
            icon: Icons.favorite,
          ),
        ),
      ],
    );
  }
}

class _MiniMetricCard extends StatelessWidget {
  final String title;
  final String value;
  final String subtitle;
  final IconData icon;

  const _MiniMetricCard({
    required this.title,
    required this.value,
    required this.subtitle,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return NeonCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColors.primaryNeon, size: 20),
          const SizedBox(height: 12),
          Text(title, style: AppTextStyles.smallTitle),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                value,
                style: const TextStyle(
                  color: AppColors.primaryNeon,
                  fontSize: 31,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(width: 5),
              Padding(
                padding: const EdgeInsets.only(bottom: 5),
                child: Text(
                  title.contains('HR') ? 'bpm' : 'kcal',
                  style: const TextStyle(
                    color: AppColors.secondaryText,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 5),
          Text(
            subtitle,
            style: const TextStyle(
              color: AppColors.secondaryText,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: const Color(0xFF263A00),
              borderRadius: BorderRadius.circular(999),
            ),
            child: const Text(
              'Zone 4 cardio',
              style: TextStyle(
                color: AppColors.primaryNeon,
                fontSize: 9,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HeartRateZonesCard extends StatelessWidget {
  const _HeartRateZonesCard();

  @override
  Widget build(BuildContext context) {
    return NeonCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text('HEART RATE ZONES — TODAY', style: AppTextStyles.smallTitle),
          SizedBox(height: 16),
          _ZoneRow(label: 'PEAK', value: 0.18, percent: '18%'),
          SizedBox(height: 10),
          _ZoneRow(label: 'CARDIO', value: 0.35, percent: '35%'),
          SizedBox(height: 10),
          _ZoneRow(label: 'AEROBIC', value: 0.28, percent: '28%'),
          SizedBox(height: 10),
          _ZoneRow(label: 'FAT BURN', value: 0.19, percent: '19%'),
        ],
      ),
    );
  }
}

class _ZoneRow extends StatelessWidget {
  final String label;
  final double value;
  final String percent;

  const _ZoneRow({
    required this.label,
    required this.value,
    required this.percent,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 72,
          child: Text(
            label,
            style: const TextStyle(
              color: AppColors.secondaryText,
              fontSize: 10,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              value: value,
              minHeight: 6,
              backgroundColor: const Color(0xFF2D2D2D),
              valueColor:
              const AlwaysStoppedAnimation(AppColors.primaryNeon),
            ),
          ),
        ),
        const SizedBox(width: 10),
        SizedBox(
          width: 34,
          child: Text(
            percent,
            textAlign: TextAlign.right,
            style: const TextStyle(
              color: AppColors.mutedText,
              fontSize: 10,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
      ],
    );
  }
}

class _HRVScoreCard extends StatelessWidget {
  const _HRVScoreCard();

  @override
  Widget build(BuildContext context) {
    return NeonCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('HRV SCORE', style: AppTextStyles.smallTitle),
          const SizedBox(height: 16),
          const Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '68',
                style: TextStyle(
                  color: AppColors.primaryNeon,
                  fontSize: 48,
                  fontWeight: FontWeight.w900,
                ),
              ),
              SizedBox(width: 8),
              Padding(
                padding: EdgeInsets.only(bottom: 10),
                child: Text(
                  '+4 pts this week · Optimal Recovery Zone',
                  style: TextStyle(
                    color: AppColors.primaryNeon,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: const LinearProgressIndicator(
              value: 0.68,
              minHeight: 8,
              backgroundColor: Color(0xFF2D2D2D),
              valueColor: AlwaysStoppedAnimation(AppColors.primaryNeon),
            ),
          ),
          const SizedBox(height: 12),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('LOW', style: AppTextStyles.axisLabel),
              Text('MID', style: AppTextStyles.axisLabel),
              Text('OPT', style: AppTextStyles.axisLabel),
              Text('PEAK', style: AppTextStyles.axisLabel),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatsLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final glowPaint = Paint()
      ..color = const Color(0x66CCFF00)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);

    final thinPaint = Paint()
      ..color = const Color(0x44ABE600)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.1;

    final path = Path()
      ..moveTo(size.width * 0.02, size.height * 0.50)
      ..lineTo(size.width * 0.14, size.height * 0.46)
      ..lineTo(size.width * 0.22, size.height * 0.66)
      ..lineTo(size.width * 0.32, size.height * 0.28)
      ..lineTo(size.width * 0.43, size.height * 0.56)
      ..lineTo(size.width * 0.55, size.height * 0.18)
      ..lineTo(size.width * 0.68, size.height * 0.48)
      ..lineTo(size.width * 0.80, size.height * 0.30)
      ..lineTo(size.width * 0.95, size.height * 0.40);

    canvas.drawPath(path, glowPaint);
    canvas.drawPath(path, thinPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}