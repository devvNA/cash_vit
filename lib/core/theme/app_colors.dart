import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Primary
  static const Color primaryBlue = Color(0xFF2196F3);
  static const Color primaryBlueDark = Color(0xFF1976D2);
  static const Color accentBlue = Color(0xFF64B5F6);

  // Semantic
  static const Color incomeGreen = Color(0xFF4CAF50);
  static const Color expenseRed = Color(0xFFEF5350);
  static const Color warningOrange = Color(0xFFFF9800);

  // Background & Surface
  static const Color backgroundLight = Color(0xFFF5F7FA);
  static const Color surfaceWhite = Color(0xFFFFFFFF);

  // Text
  static const Color textPrimary = Color(0xFF1A1D1F);
  static const Color textSecondary = Color(0xFF6B7280);

  // Border
  static const Color borderLight = Color(0xFFE5E7EB);

  // Category colors (soft backgrounds)
  static const Color categoryFood = Color(0xFFFFF3E0);
  static const Color categorySalary = Color(0xFFE8F5E9);
  static const Color categoryEntertainment = Color(0xFFF3E5F5);
  static const Color categoryFuel = Color(0xFFE3F2FD);
  static const Color categoryShopping = Color(0xFFFCE4EC);

  // Gradient
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primaryBlue, primaryBlueDark],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
