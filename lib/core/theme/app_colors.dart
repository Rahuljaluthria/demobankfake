import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Primary palette - Deep Blue
  static const Color primaryDark = Color(0xFF0A1E3D);
  static const Color primary = Color(0xFF0F2D5E);
  static const Color primaryLight = Color(0xFF1A3F7A);
  static const Color primarySurface = Color(0xFF1E4A8F);

  // Accent - Teal
  static const Color accent = Color(0xFF00BFA6);
  static const Color accentLight = Color(0xFF33CCBB);
  static const Color accentDark = Color(0xFF009688);

  // Neutrals
  static const Color white = Color(0xFFFFFFFF);
  static const Color background = Color(0xFFF5F7FA);
  static const Color surfaceLight = Color(0xFFF8F9FC);
  static const Color cardBackground = Color(0xFFFFFFFF);
  static const Color divider = Color(0xFFE8ECF2);
  static const Color textPrimary = Color(0xFF1A1F36);
  static const Color textSecondary = Color(0xFF6B7394);
  static const Color textTertiary = Color(0xFF9CA3BF);
  static const Color iconGrey = Color(0xFF8892B0);

  // Status
  static const Color success = Color(0xFF00C48C);
  static const Color successLight = Color(0xFFE6FAF3);
  static const Color error = Color(0xFFFF4757);
  static const Color errorLight = Color(0xFFFFF0F0);
  static const Color warning = Color(0xFFFFBE21);
  static const Color warningLight = Color(0xFFFFF8E6);
  static const Color info = Color(0xFF3B82F6);

  // Transaction colors
  static const Color credit = Color(0xFF00C48C);
  static const Color debit = Color(0xFFFF4757);

  // Gradient
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF0F2D5E),
      Color(0xFF1A3F7A),
      Color(0xFF0A1E3D),
    ],
  );

  static const LinearGradient cardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF1A3F7A),
      Color(0xFF0F2D5E),
    ],
  );

  static const LinearGradient accentGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF00BFA6),
      Color(0xFF009688),
    ],
  );
}
