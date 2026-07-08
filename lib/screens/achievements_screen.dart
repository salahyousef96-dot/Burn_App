import 'package:flutter/material.dart';
import '../theme/app_text_styles.dart';
import '../widgets/neon_card.dart';
import '../theme/app_colors.dart';

class AchievementsScreen extends StatelessWidget {
  const AchievementsScreen({super.key});

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
                const Positioned.fill(child: _AchievementsBackground()),
                SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(18, 14, 18, 130),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      _AchievementsHeader(),
                      SizedBox(height: 16),
                      _GlobalLeaderboardCard(),
                      SizedBox(height: 16),
                      _EarnedBadgesGrid(),
                      SizedBox(height: 16),
                      _MilestonesSection(),
                      SizedBox(height: 16),
                      _TopPerformersCard(),
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

class _AchievementsBackground extends StatelessWidget {
  const _AchievementsBackground();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.background,
        gradient: RadialGradient(
          center: Alignment(0.0, -0.95),
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

class _AchievementsHeader extends StatelessWidget {
  const _AchievementsHeader();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 165,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(24),
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
            child: CustomPaint(
              painter: _TrophyGlowPainter(),
            ),
          ),
          Positioned(
            top: 18,
            left: 18,
            child: _CircleButton(
              icon: Icons.arrow_back,
            ),
          ),
          Positioned(
            top: 18,
            right: 18,
            child: _CircleButton(
              icon: Icons.notifications_none,
            ),
          ),
          const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.emoji_events,
                  color: AppColors.primaryNeon,
                  size: 58,
                ),
                SizedBox(height: 10),
                Text(
                  'ACHIEVEMENTS',
                  style: TextStyle(
                    color: AppColors.text,
                    fontSize: 26,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0.8,
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

class _CircleButton extends StatelessWidget {
  final IconData icon;

  const _CircleButton({required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 36,
      height: 36,
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

class _GlobalLeaderboardCard extends StatelessWidget {
  const _GlobalLeaderboardCard();

  @override
  Widget build(BuildContext context) {
    return NeonCard(
      child: Row(
        children: [
          Container(
            width: 62,
            height: 62,
            decoration: BoxDecoration(
              color: AppColors.primaryNeon,
              shape: BoxShape.circle,
              boxShadow: const [
                BoxShadow(
                  color: Color(0x88CCFF00),
                  blurRadius: 22,
                ),
              ],
            ),
            child: const Center(
              child: Text(
                '#14',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ),
          const SizedBox(width: 18),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('GLOBAL LEADERBOARD', style: AppTextStyles.smallTitle),
                SizedBox(height: 8),
                Text(
                  '4,812 pts',
                  style: TextStyle(
                    color: AppColors.primaryNeon,
                    fontSize: 30,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  '+6 spots from last week',
                  style: TextStyle(
                    color: AppColors.secondaryText,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
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

class _EarnedBadgesGrid extends StatelessWidget {
  const _EarnedBadgesGrid();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Text('EARNED BADGES', style: AppTextStyles.smallTitle),
        SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _BadgeCard(
                icon: Icons.local_fire_department,
                title: 'First Burn',
                points: '+100 pts',
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: _BadgeCard(
                icon: Icons.flash_on,
                title: '7-Day Streak',
                points: '+500 pts',
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: _BadgeCard(
                icon: Icons.fitness_center,
                title: 'PR Crusher',
                points: '+300 pts',
              ),
            ),
          ],
        ),
        SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: _BadgeCard(
                icon: Icons.directions_run,
                title: 'Speed Demon',
                points: '+400 pts',
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: _BadgeCard(
                icon: Icons.emoji_events,
                title: '21-Day Grind',
                points: '+1,000 pts',
                locked: true,
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: _BadgeCard(
                icon: Icons.favorite,
                title: 'Elite Zone',
                points: '+750 pts',
                locked: true,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _BadgeCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String points;
  final bool locked;

  const _BadgeCard({
    required this.icon,
    required this.title,
    required this.points,
    this.locked = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = locked ? AppColors.mutedText : AppColors.primaryNeon;

    return Container(
      height: 116,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: locked ? const Color(0xFF333333) : AppColors.border,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            locked ? Icons.lock_outline : icon,
            color: color,
            size: 25,
          ),
          const SizedBox(height: 10),
          Text(
            title,
            textAlign: TextAlign.center,
            maxLines: 2,
            style: TextStyle(
              color: locked ? AppColors.mutedText : AppColors.text,
              fontSize: 10,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 7),
          Text(
            points,
            style: TextStyle(
              color: color,
              fontSize: 9,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}

class _MilestonesSection extends StatelessWidget {
  const _MilestonesSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Text('MILESTONES', style: AppTextStyles.smallTitle),
        SizedBox(height: 12),
        _MilestoneCard(
          icon: Icons.local_fire_department,
          title: '9-Day Streak',
          subtitle: 'Completed',
          progress: 1.0,
          reward: '+500 pts',
        ),
        SizedBox(height: 10),
        _MilestoneCard(
          icon: Icons.hourglass_bottom,
          title: '10,000 kcal Burned',
          subtitle: '7,412 / 10,000 kcal',
          progress: 0.74,
          reward: '+800 pts',
        ),
        SizedBox(height: 10),
        _MilestoneCard(
          icon: Icons.calendar_month,
          title: '30-Day Warrior',
          subtitle: '9 / 30 days',
          progress: 0.30,
          reward: '+2,000 pts',
          locked: true,
        ),
      ],
    );
  }
}

class _MilestoneCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final double progress;
  final String reward;
  final bool locked;

  const _MilestoneCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.progress,
    required this.reward,
    this.locked = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = locked ? AppColors.mutedText : AppColors.primaryNeon;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: locked ? const Color(0xFF333333) : AppColors.border,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: locked ? const Color(0xFF202020) : const Color(0xFF263A00),
              borderRadius: BorderRadius.circular(13),
            ),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: locked ? AppColors.mutedText : AppColors.text,
                    fontSize: 14,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: AppColors.secondaryText,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 9),
                ClipRRect(
                  borderRadius: BorderRadius.circular(999),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 5,
                    backgroundColor: const Color(0xFF2D2D2D),
                    valueColor: AlwaysStoppedAnimation(color),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Text(
            reward,
            style: TextStyle(
              color: color,
              fontSize: 11,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}

class _TopPerformersCard extends StatelessWidget {
  const _TopPerformersCard();

  @override
  Widget build(BuildContext context) {
    return NeonCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text('TOP PERFORMERS', style: AppTextStyles.smallTitle),
          SizedBox(height: 8),
          Text(
            "THIS WEEK'S LEADERBOARD",
            style: TextStyle(
              color: AppColors.secondaryText,
              fontSize: 11,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.1,
            ),
          ),
          SizedBox(height: 18),
          _Podium(),
          SizedBox(height: 16),
          _YourRankRow(),
        ],
      ),
    );
  }
}

class _Podium extends StatelessWidget {
  const _Podium();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 185,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: const [
          Expanded(
            child: _PodiumItem(
              name: 'Mike K.',
              initials: 'MK',
              points: '5,340',
              height: 72,
              place: '2',
            ),
          ),
          SizedBox(width: 10),
          Expanded(
            child: _PodiumItem(
              name: 'Jay L.',
              initials: 'JL',
              points: '6,120',
              height: 90,
              place: '1',
              active: true,
            ),
          ),
          SizedBox(width: 10),
          Expanded(
            child: _PodiumItem(
              name: 'Sara R.',
              initials: 'SR',
              points: '4,990',
              height: 58,
              place: '3',
            ),
          ),
        ],
      ),
    );
  }
}

class _PodiumItem extends StatelessWidget {
  final String name;
  final String initials;
  final String points;
  final double height;
  final String place;
  final bool active;

  const _PodiumItem({
    required this.name,
    required this.initials,
    required this.points,
    required this.height,
    required this.place,
    this.active = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = active ? AppColors.primaryNeon : AppColors.secondaryText;

    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(
          points,
          style: TextStyle(
            color: color,
            fontSize: 12,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          name,
          style: const TextStyle(
            color: AppColors.secondaryText,
            fontSize: 10,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: active ? AppColors.primaryNeon : const Color(0xFF2B2B2B),
            shape: BoxShape.circle,
            border: Border.all(color: color),
          ),
          child: Center(
            child: Text(
              initials,
              style: TextStyle(
                color: active ? Colors.black : AppColors.text,
                fontSize: 12,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          height: height,
          width: double.infinity,
          decoration: BoxDecoration(
            color: active ? const Color(0xFF314700) : const Color(0xFF272727),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: active ? AppColors.primaryNeon : const Color(0xFF333333),
            ),
          ),
          child: Center(
            child: Text(
              '#$place',
              style: TextStyle(
                color: color,
                fontSize: 15,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _YourRankRow extends StatelessWidget {
  const _YourRankRow();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF1C2408),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: const Row(
        children: [
          Text(
            'Your Rank',
            style: TextStyle(
              color: AppColors.secondaryText,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
          Spacer(),
          Text(
            '#14',
            style: TextStyle(
              color: AppColors.primaryNeon,
              fontSize: 14,
              fontWeight: FontWeight.w900,
            ),
          ),
          SizedBox(width: 22),
          Text(
            '4,812 pts',
            style: TextStyle(
              color: AppColors.text,
              fontSize: 12,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}

class _TrophyGlowPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final glowPaint = Paint()
      ..color = const Color(0x66CCFF00)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 7);

    final thinPaint = Paint()
      ..color = const Color(0x44ABE600)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.1;

    final trophy = Path()
      ..moveTo(size.width * 0.38, size.height * 0.25)
      ..lineTo(size.width * 0.62, size.height * 0.25)
      ..quadraticBezierTo(
        size.width * 0.60,
        size.height * 0.48,
        size.width * 0.50,
        size.height * 0.52,
      )
      ..quadraticBezierTo(
        size.width * 0.40,
        size.height * 0.48,
        size.width * 0.38,
        size.height * 0.25,
      );

    final leftHandle = Path()
      ..moveTo(size.width * 0.38, size.height * 0.30)
      ..quadraticBezierTo(
        size.width * 0.25,
        size.height * 0.30,
        size.width * 0.30,
        size.height * 0.43,
      )
      ..quadraticBezierTo(
        size.width * 0.33,
        size.height * 0.50,
        size.width * 0.43,
        size.height * 0.47,
      );

    final rightHandle = Path()
      ..moveTo(size.width * 0.62, size.height * 0.30)
      ..quadraticBezierTo(
        size.width * 0.75,
        size.height * 0.30,
        size.width * 0.70,
        size.height * 0.43,
      )
      ..quadraticBezierTo(
        size.width * 0.67,
        size.height * 0.50,
        size.width * 0.57,
        size.height * 0.47,
      );

    final base = Path()
      ..moveTo(size.width * 0.50, size.height * 0.52)
      ..lineTo(size.width * 0.50, size.height * 0.66)
      ..moveTo(size.width * 0.42, size.height * 0.69)
      ..lineTo(size.width * 0.58, size.height * 0.69)
      ..moveTo(size.width * 0.36, size.height * 0.75)
      ..lineTo(size.width * 0.64, size.height * 0.75);

    canvas.drawPath(trophy, glowPaint);
    canvas.drawPath(leftHandle, glowPaint);
    canvas.drawPath(rightHandle, glowPaint);
    canvas.drawPath(base, glowPaint);

    canvas.drawPath(trophy, thinPaint);
    canvas.drawPath(leftHandle, thinPaint);
    canvas.drawPath(rightHandle, thinPaint);
    canvas.drawPath(base, thinPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}