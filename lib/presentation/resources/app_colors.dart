import 'package:flutter/material.dart';

/// Centralized color palette for the application.
abstract final class AppColors {
  // Primary Colors
  static const Color primary = Color(0xFF774FFF);
  static const Color primaryDark = Color(0xFF6C69FF);
  static const Color primaryLight = Color(0xFF9B7FFF);

  // Accent Colors
  static const Color accent = Color(0xFFFF6B35);

  // Status Colors
  static const Color success = Color(0xFF4CAF50);
  static const Color error = Color(0xFFE53935);
  static const Color warning = Color(0xFFFFA726);
  static const Color info = Color(0xFF29B6F6);

  // Background Colors
  static const Color background = Color(0xFFF5F5F5);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceVariant = Color(0xFFF5F5F5);

  // Text Colors
  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF757575);
  static const Color textDisabled = Color(0xFFBDBDBD);
  static const Color textOnPrimary = Color(0xFFFFFFFF);

  // Meal Type Colors
  static const Color regular = Color(0xFF774FFF);
  static const Color vegetarian = Color(0xFF4CAF50);
  static const Color glutenFree = Color(0xFFFF9800);
  static const Color nonPork = Color(0xFF00ACC1);

  // Day Status Colors
  static const Color working = Color(0xFF4CAF50);
  static const Color closed = Color(0xFFE53935);
  static const Color noteOnly = Color(0xFFFFA726);

  // Divider & Border Colors
  static const Color divider = Color(0xFFE0E0E0);
  static const Color border = Color(0xFFBDBDBD);
}
