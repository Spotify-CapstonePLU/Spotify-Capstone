import 'package:flutter/material.dart';
import 'package:spotify_polls/pages/home_page.dart';
import '../styles/themes.dart' as theme;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: theme.defaultTheme,
      home: const HomePage(),
    );
  }
}

