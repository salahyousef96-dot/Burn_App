import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import 'home_screen.dart';
import 'workout_screen.dart';
import 'stats_screen.dart';
import 'achievements_screen.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int selectedIndex = 0;

  final List<Widget> screens = const [
    BurnHomeScreen(),
    WorkoutScreen(),
    StatsScreen(),
    AchievementsScreen(),
  ];

  void changeScreen(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          IndexedStack(
            index: selectedIndex,
            children: screens,
          ),
          Positioned(
            left: 18,
            right: 18,
            bottom: 6,
            child: _BottomNavBar(
              selectedIndex: selectedIndex,
              onItemSelected: changeScreen,
            ),
          ),
        ],
      ),
    );
  }
}

class _BottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onItemSelected;

  const _BottomNavBar({
    required this.selectedIndex,
    required this.onItemSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        height: 76,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          color: const Color(0xEE101010),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: AppColors.border),
          boxShadow: const [
            BoxShadow(
              color: Color(0x99000000),
              blurRadius: 28,
              offset: Offset(0, 12),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _NavItem(
              icon: Icons.home_rounded,
              label: 'HOME',
              active: selectedIndex == 0,
              onTap: () => onItemSelected(0),
            ),
            _NavItem(
              icon: Icons.calendar_month,
              label: 'TRAIN',
              active: selectedIndex == 1,
              onTap: () => onItemSelected(1),
            ),
            _NavItem(
              icon: Icons.show_chart,
              label: 'STATS',
              active: selectedIndex == 2,
              onTap: () => onItemSelected(2),
            ),
            _NavItem(
              icon: Icons.emoji_events_outlined,
              label: 'AWARDS',
              active: selectedIndex == 3,
              onTap: () => onItemSelected(3),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool active;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.active,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = active ? AppColors.primaryNeon : AppColors.mutedText;

    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: SizedBox(
        width: 70,
        height: 58,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 22),
            const SizedBox(height: 5),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 9,
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ),
      ),
    );
  }
}