import 'package:flutter/material.dart';

class PulseColors {
  static const Color background = Color(0xFF071417);
  static const Color surface = Color(0xFF0F262B);
  static const Color surfaceLight = Color(0xFF16353C);
  static const Color primaryTeal = Color(0xFF00796B);
  static const Color lightTeal = Color(0xFF26A69A);
  static const Color mint = Color(0xFF48C9B0);
  static const Color softMint = Color(0xFFA7F3D0);
  static const Color accentAmber = Color(0xFFF6C85F);
  static const Color textPrimary = Color(0xFFE6F4F1);
  static const Color textSecondary = Color(0xFF8BA5A2);
  static const Color border = Color(0xFF1E464E);
  static const Color errorRed = Color(0xFFEF5350);
}

class PulseTheme {
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: PulseColors.background,
      colorScheme: const ColorScheme.dark(
        primary: PulseColors.mint,
        onPrimary: PulseColors.background,
        secondary: PulseColors.lightTeal,
        onSecondary: Colors.white,
        surface: PulseColors.surface,
        onSurface: PulseColors.textPrimary,
        error: PulseColors.errorRed,
      ),
      cardTheme: CardThemeData(
        color: PulseColors.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: PulseColors.border, width: 1),
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: PulseColors.background,
        elevation: 0,
        centerTitle: true,
        scrolledUnderElevation: 0,
        titleTextStyle: TextStyle(
          color: PulseColors.textPrimary,
          fontSize: 19,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
        iconTheme: IconThemeData(color: PulseColors.textPrimary),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: PulseColors.surface,
        selectedItemColor: PulseColors.mint,
        unselectedItemColor: PulseColors.textSecondary,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: PulseColors.mint,
          foregroundColor: PulseColors.background,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.3,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: PulseColors.surfaceLight,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: PulseColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: PulseColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: PulseColors.mint, width: 1.5),
        ),
        hintStyle: const TextStyle(color: PulseColors.textSecondary),
        labelStyle: const TextStyle(color: PulseColors.textPrimary),
      ),
    );
  }
}
