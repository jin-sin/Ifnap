import 'package:flutter/material.dart';

import 'features/home/presentation/home_screen.dart';

void main() {
  runApp(const IfnapApp());
}

class IfnapApp extends StatelessWidget {
  const IfnapApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Ifnap',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF6C63FF)),
        scaffoldBackgroundColor: const Color(0xFFF8F7FC),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}
