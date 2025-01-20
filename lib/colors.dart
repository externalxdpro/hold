import 'package:flutter/material.dart';

class Themes {
  static const Color _primary = Colors.black;

  static const Color _mainBackground = Color(0xfffaf6f8);
  static const Color _mainSecondary = Color(0xfffffeff);

  static const Color _welcomeBackground = Color(0xfffffeff);
  static const Color _welcomeSecondary = Color(0xfff7f5fd);

  static ThemeData welcomeTheme = ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.black,
      background: _welcomeBackground,
      primary: _primary,
      secondary: _welcomeSecondary,
    ),
    brightness: Brightness.light,
    appBarTheme: const AppBarTheme(
      backgroundColor: _welcomeBackground,
      surfaceTintColor: _welcomeBackground,
    ),
    fontFamily: 'Causten',
    useMaterial3: true,
  );

  static ThemeData mainTheme = ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.black,
      background: _mainBackground,
      primary: _primary,
      secondary: _mainSecondary,
    ),
    brightness: Brightness.light,
    appBarTheme: const AppBarTheme(
      backgroundColor: _mainBackground,
      surfaceTintColor: _mainBackground,
    ),
    fontFamily: 'Causten',
    useMaterial3: true,
  );
}
