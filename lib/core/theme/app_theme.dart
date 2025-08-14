import 'package:flutter/material.dart';

class AppTheme{
  static final dark = ThemeData(
    scaffoldBackgroundColor: Color(0xff171212),
    textTheme: TextTheme(
      bodyMedium: TextStyle(
        color: Colors.white,
      ),
    ),
    colorScheme: ColorScheme.fromSeed(
      seedColor: Color(0xff171212),
      brightness: Brightness.dark,
    ),
    useMaterial3: true,
  );
}