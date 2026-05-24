import 'package:flutter/material.dart';

class AppTheme {
  static const Color _primaryBrandColor = Color(0xFF0F172A);

  static const Color _lightBg = Color(0xFFF8F9FA);
  static const Color _lightCard = Color(0xFFFFFFFF);
  static const Color _lightBorder = Color(0xFFE2E8F0);

  static const Color _darkBg = Color(0xFF0F172A);
  static const Color _darkCard = Color(0xFF1E1E1E);
  static const Color _darkBorder = Color(0xFF334155);

  static ThemeData get lightTheme {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: _primaryBrandColor,
      brightness: Brightness.light,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,

      scaffoldBackgroundColor: _lightBg,

      appBarTheme: const AppBarTheme(
        backgroundColor: _lightBg,
        foregroundColor: _primaryBrandColor,
        elevation: 0,
        centerTitle: false,
      ),

      cardTheme: const CardThemeData(
        color: _lightCard,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          side: BorderSide(color: _lightBorder, width: 1),
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: _lightBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colorScheme.primary, width: 2),
        ),
      ),

      elevatedButtonTheme: _buttonTheme(colorScheme),
    );
  }

  static ThemeData get darkTheme {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: _primaryBrandColor,
      brightness: Brightness.dark,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,

      scaffoldBackgroundColor: _darkBg,

      appBarTheme: const AppBarTheme(
        backgroundColor: _darkBg,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
      ),

      cardTheme: const CardThemeData(
        color: _darkCard,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          side: BorderSide(color: _lightBorder, width: 1),
        ),
      ),

      inputDecorationTheme: lightTheme.inputDecorationTheme.copyWith(
        fillColor: colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: _darkBorder),
        ),
      ),

      elevatedButtonTheme: _buttonTheme(colorScheme),
    );
  }

  static ElevatedButtonThemeData _buttonTheme(ColorScheme colorScheme) {
    return ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: 0,
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        minimumSize: const Size.fromHeight(56),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      ),
    );
  }
}