import 'package:flutter/material.dart';
import 'package:flutter_app_project/utils/theme.dart'; // <-- IMPORT YOUR THEME
import 'screens/splash_screen.dart'; // Ensure correct path

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CPL Real Estate',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme, 
      
      // --- CHANGED THIS LINE ---
      home: const SplashScreen(), 
    );
  }
}