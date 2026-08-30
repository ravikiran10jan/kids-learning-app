import 'package:flutter/material.dart';

class AppColors {
  static const primary = Color(0xFF58CC02);       // Vibrant green
  static const primaryDark = Color(0xFF46A302);
  static const secondary = Color(0xFF1CB0F6);      // Blue
  static const accent = Color(0xFFFF9600);         // Orange/gold
  static const error = Color(0xFFFF4B4B);          // Red
  static const correct = Color(0xFF58CC02);        // Green
  static const purple = Color(0xFFCE82FF);
  static const background = Color(0xFFF5F5F5);
  static const cardBg = Colors.white;
  static const textPrimary = Color(0xFF3C3C3C);
  static const textSecondary = Color(0xFF777777);
  static const mathGradient1 = Color(0xFF1CB0F6);
  static const mathGradient2 = Color(0xFF0095D9);
  static const englishGradient1 = Color(0xFFCE82FF);
  static const englishGradient2 = Color(0xFFA855F7);
  static const goldCoin = Color(0xFFFFC800);
  static const streakOrange = Color(0xFFFF9600);
  static const lockedGrey = Color(0xFFE5E5E5);
  static const lockedIcon = Color(0xFFAFAFAF);
}

class AppTheme {
  static ThemeData get light => ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        scaffoldBackgroundColor: AppColors.background,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          primary: AppColors.primary,
          secondary: AppColors.secondary,
          error: AppColors.error,
        ),
        textTheme: const TextTheme(
          headlineLarge: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
            letterSpacing: -0.5,
          ),
          headlineMedium: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
          titleLarge: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
          bodyLarge: TextStyle(fontSize: 16, color: AppColors.textPrimary),
          bodyMedium: TextStyle(fontSize: 14, color: AppColors.textSecondary),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            minimumSize: const Size(double.infinity, 56),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            textStyle: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w700,
            ),
            elevation: 0,
          ),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: IconThemeData(color: AppColors.textPrimary),
          titleTextStyle: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
      );
}
