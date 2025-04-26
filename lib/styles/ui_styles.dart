import 'package:flutter/material.dart';

class UiStyles {
  // Colors
  static const Color primaryColor = Color(0xFF6C63FF);
  static const Color accentColor = Color(0xFFFF6584);
  static const Color backgroundColor = Color(0xFF061637);
  static const Color textColor = Color(0xFFFFFFFF);

  static const Color buttonTextColor = Colors.black;
  static const Color buttonBackgroundColor = Color(0xFF1DB853);
  static const Color buttonBorderColor = Color(0xFF000000);
  static const double buttonBorderWidth = 2.0;
  static const EdgeInsets buttonPadding = EdgeInsets.symmetric(horizontal: 24, vertical: 12);

  // Text Styles
  static const TextStyle heading1 = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: textColor,
  );

  static const TextStyle heading2 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    color: textColor,
  );

  static const TextStyle bodyText = TextStyle(
    fontSize: 16,
    color: textColor,
  );

  static const TextStyle buttonText = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );

  static ButtonStyle textButtonStyle = TextButton.styleFrom(
    foregroundColor: buttonTextColor,
    backgroundColor: buttonBackgroundColor,
    padding: buttonPadding,
    side: const BorderSide(
      color: buttonBorderColor,
      width: buttonBorderWidth,
    ),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(12)),
    ),
    textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
  );

  // Padding
  static const EdgeInsets screenPadding = EdgeInsets.symmetric(horizontal: 16, vertical: 8);
}