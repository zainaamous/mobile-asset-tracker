import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFF4285F4);
  static const Color secondary = Color(0xFF34A853);
  static const Color accent = Color(0xFFFBBC05);
  static const Color background = Color(0xFFFFFFFF);
  static const Color text = Color(0xFF202124);
}

class AppTypography {
  static const String fontFamily = 'Roboto'; // Or 'Open Sans'

  static const TextStyle bodyText = TextStyle(
    fontFamily: fontFamily,
    color: AppColors.text,
  );

  static const TextStyle title = TextStyle(
    fontFamily: fontFamily,
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppColors.text,
  );

  static const TextStyle subtitle = TextStyle(
    fontFamily: fontFamily,
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppColors.text,
  );
}
