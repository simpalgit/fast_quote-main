import 'package:flutter/material.dart';

/// Centralized color palette + text styles for the FastQuote app.
class AppColors {
  AppColors._();

  static const Color primaryBlue = Color(0xFF2563EB);
  static const Color darkNavy = Color(0xFF16224E);
  static const Color background = Color(0xFFF5F6FA);
  static const Color cardWhite = Color(0xFFFFFFFF);
  static const Color border = Color(0xFFE7E9F0);

  static const Color textDark = Color(0xFF1A1F36);
  static const Color textGrey = Color(0xFF6B7280);
  static const Color textLightGrey = Color(0xFF9CA3AF);

  static const Color green = Color(0xFF16A34A);
  static const Color greenBg = Color(0xFFE7F7ED);
  static const Color red = Color(0xFFDC2626);
  static const Color redBg = Color(0xFFFCE9E9);
  static const Color orange = Color(0xFFF59E0B);
  static const Color orangeBg = Color(0xFFFEF3E2);
  static const Color purple = Color(0xFF7C3AED);
  static const Color purpleBg = Color(0xFFF1EAFE);
  static const Color blueBg = Color(0xFFE9EFFD);
  static const Color tealBg = Color(0xFFE3F6F5);
  static const Color teal = Color(0xFF0D9488);
  static const Color pinkBg = Color(0xFFFDE9F1);
  static const Color pink = Color(0xFFDB2777);

  static const List<Color> avatarPalette = [
    primaryBlue,
    green,
    orange,
    purple,
    teal,
    pink,
  ];
}

class AppText {
  AppText._();

  static const TextStyle h1 = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.bold,
    color: AppColors.textDark,
  );

  static const TextStyle h2 = TextStyle(
    fontSize: 17,
    fontWeight: FontWeight.w700,
    color: AppColors.textDark,
  );

  static const TextStyle subtitle = TextStyle(
    fontSize: 13,
    color: AppColors.textGrey,
  );

  static const TextStyle cardValue = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppColors.textDark,
  );

  static const TextStyle cardLabel = TextStyle(
    fontSize: 13,
    color: AppColors.textGrey,
    fontWeight: FontWeight.w500,
  );

  static const TextStyle small = TextStyle(
    fontSize: 12,
    color: AppColors.textGrey,
  );
}
