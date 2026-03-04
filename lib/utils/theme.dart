import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart'; // <-- ADD THIS IMPORT

class AppColors {
  static const Color primary = Color(0xFF154694); 
  static const Color background = Color(0xFFF5F7FA); 
  static const Color cardBg = Colors.white;
  static const Color textMain = Color(0xFF1A1A1A); 
  static const Color textSub = Colors.blueGrey;
  static const Color priceRed = Color(0xFFEF4444);
  static const Color successGreen = Color(0xFF2E7D32);
  static const Color lightBlueHighlight = Color(0xFFE8EEF5);
}

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      primaryColor: AppColors.primary,
      scaffoldBackgroundColor: AppColors.background,
      
      // --- NEW: GLOBALLY APPLY 'INTER' FONT ---
      // This automatically updates all text in your app to the modern, clean look
      textTheme: GoogleFonts.interTextTheme(), 
      
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.primary,
        elevation: 0,
        centerTitle: false, // In your screenshot, "HOME" is aligned to the left
        iconTheme: const IconThemeData(color: Colors.white),
        // Update the AppBar title font specifically
        titleTextStyle: GoogleFonts.inter(
          color: Colors.white, 
          fontSize: 24, 
          fontWeight: FontWeight.w800, 
        ),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),

      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: Colors.white,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: Colors.grey.shade500,
        type: BottomNavigationBarType.fixed,
        // Make the bottom nav text match the clean font
        selectedLabelStyle: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w700),
        unselectedLabelStyle: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w500),
      ),
    );
  }
}