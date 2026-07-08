import 'package:flutter/material.dart';
import 'theme/app_colors.dart';
import 'screens/app_shell.dart';

void main() {
  runApp(const BurnApp());
}

class BurnApp extends StatelessWidget {
  const BurnApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BURN Fitness',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Inter',
        scaffoldBackgroundColor: AppColors.background,
      ),
      home: const AppShell(),
    );
  }
}

