import 'package:flutter/material.dart';

class AppTheme {
  static const background = Color(0xFF1E1E1E);
  static const surface = Color(0xFF252526);
  static const cardColor = Color(0xFF2D2D30);
  static const primary = Color(0xFF0078D4);
  static const secondary = Color(0xFF4CC2FF);
  static const textPrimary = Color(0xFFFFFFFF);
  static const textSecondary = Color(0xFFB0B0B0);

  static ThemeData dark() {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: background,
      canvasColor: background,
      cardColor: cardColor,
      primaryColor: primary,
      colorScheme: const ColorScheme.dark(
        surface: surface,
        primary: primary,
        secondary: secondary,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: surface,
        elevation: 0,
      ),
      textTheme: const TextTheme(
        headlineSmall: TextStyle(
          color: textPrimary,
          fontWeight: FontWeight.w700,
        ),
        titleMedium: TextStyle(color: textPrimary),
        bodyMedium: TextStyle(color: textSecondary),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFF2D2D30),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          padding: const EdgeInsets.symmetric(
            vertical: 16,
            horizontal: 24,
          ),
          textStyle: const TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
