import 'package:flutter/material.dart';

ThemeData get defaultTheme {
  return ThemeData(
    fontFamily: "Georgia",
    textTheme: const TextTheme(
      headlineLarge: TextStyle(fontSize: 64.0),
      headlineMedium: TextStyle(fontSize: 24.0), // Replace all text styles with custom values
      headlineSmall: TextStyle(fontSize: 16.0),
      bodyLarge: TextStyle(),
      bodyMedium: TextStyle(),
      bodySmall: TextStyle(),
    )
  );
}