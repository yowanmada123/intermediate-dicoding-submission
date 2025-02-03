import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:maresto/core/constants/app_constant.dart';
import 'package:maresto/presentation/themes/theme_text.dart';

ThemeData buildDarkTheme() {
  final base = ThemeData.dark();
  return base.copyWith(
    colorScheme: base.colorScheme.copyWith(
      primary: oPrimary,
      secondary: Colors.orangeAccent,
    ),
    textTheme: buildTextTheme(base.textTheme, isDark: true),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.black,
      foregroundColor: Colors.white,
    ),
    scaffoldBackgroundColor: Colors.black,
    cardColor: const Color(0xFF1E1E1E),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.black,
        backgroundColor: oPrimary,
        textStyle: TextStyle(
          fontFamily: GoogleFonts.lato().fontFamily,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
  );
}
