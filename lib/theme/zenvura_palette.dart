import 'package:flutter/material.dart';

class ZenvuraPalette {
  static const background = Color(0xFF070F18);
  static const surface = Color(0xFF0F1E2E);
  static const card = Color(0xFF172C42);
  static const mint = Color(0xFF34D399);
  static const teal = Color(0xFF06B6D4);
  static const lavender = Color(0xFFA78BFA);
  static const textPrimary = Color(0xFFF0FDF4);
  static const textSecondary = Color(0xFF94A3B8);

  static ThemeData get themeData {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: background,
      primaryColor: mint,
      cardColor: card,
      fontFamily: 'AppFont',
      colorScheme: const ColorScheme.dark(
        primary: mint,
        secondary: teal,
        surface: surface,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: background,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: textPrimary,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
