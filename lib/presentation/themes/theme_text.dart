import 'package:flutter/material.dart';

TextTheme buildTextTheme(TextTheme base, {bool isDark = false}) {
  final primaryTextColor = isDark ? Colors.white : Colors.black87;
  final secondaryTextColor = isDark ? Colors.white70 : Colors.black54;

  return base.copyWith(
    headlineLarge: base.headlineLarge?.copyWith(
      fontFamily: 'Roboto',
      fontSize: 18,
      fontWeight: FontWeight.w500,
      color: primaryTextColor,
    ),
    headlineMedium: base.headlineMedium?.copyWith(
      fontFamily: 'Roboto',
      fontSize: 16,
      fontWeight: FontWeight.w500,
      color: primaryTextColor,
    ),
    bodyLarge: base.bodyLarge?.copyWith(
      fontFamily: 'Roboto',
      fontSize: 14,
      fontWeight: FontWeight.normal,
      color: secondaryTextColor,
    ),
    bodyMedium: base.bodyMedium?.copyWith(
      fontFamily: 'Roboto',
      fontSize: 14,
      fontWeight: FontWeight.bold,
      color: primaryTextColor,
    ),
    bodySmall: base.bodySmall?.copyWith(
      fontFamily: 'Roboto',
      fontSize: 12,
      fontWeight: FontWeight.normal,
      color: secondaryTextColor,
    ),
    labelLarge: base.labelLarge?.copyWith(
      fontFamily: 'Roboto',
      fontSize: 12,
      fontWeight: FontWeight.bold,
      color: secondaryTextColor,
    ),
  );
}
