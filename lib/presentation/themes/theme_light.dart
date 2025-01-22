import 'package:flutter/material.dart';
import 'package:maresto/core/constants/app_constant.dart';
import 'package:maresto/presentation/themes/theme_text.dart';

ThemeData buildLightTheme() {
  final base = ThemeData.light();
  return base.copyWith(
    colorScheme: base.colorScheme.copyWith(
      primary: oPrimary,
      secondary: Colors.orangeAccent,
    ),
    textTheme: buildTextTheme(base.textTheme),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
    ),
    scaffoldBackgroundColor: Colors.white,
    cardColor: Colors.white,
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: oPrimary,
        textStyle: const TextStyle(
          fontFamily: 'Roboto',
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
  );
}
