import 'package:flutter/material.dart';

ThemeData get defaultTheme {
  return ThemeData(
    scaffoldBackgroundColor: const Color(0xFF061637),
    fontFamily: "Georgia",
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: const Color(0xFF000000),
        backgroundColor: const Color(0xFF1DB853),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: const Color(0xFF2B3A9F),

      ),
    ),
    dialogTheme : const DialogTheme(
      backgroundColor: Color(0xFF181B56),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      foregroundColor: Colors.white,
      backgroundColor: Color(0xFF5D6ABF),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFFB7CBF6),
    ),
    textTheme: const TextTheme(
      headlineLarge: TextStyle(fontSize: 64.0, color: Colors.white),
      headlineMedium: TextStyle(
          fontSize: 24.0,
          color: Colors.white), // Replace all text styles with custom values
      headlineSmall: TextStyle(fontSize: 16.0, color: Colors.white),
      bodyLarge: TextStyle(),
      bodyMedium: TextStyle(),
      bodySmall: TextStyle(),
    ),

  );
}
