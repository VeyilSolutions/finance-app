// lib/theme/app_theme.dart

import 'package:flutter/material.dart';

class AppTheme {
  // =========================
  // COLORS (Converted from CSS Variables)
  // =========================

  // LIGHT THEME
  static const Color backgroundLight = Color(0xFFFFFFFF);
  static const Color foregroundLight = Color(0xFF0F172A);

  static const Color cardLight = Color(0xFFFFFFFF);
  static const Color cardForegroundLight = Color(0xFF0F172A);

  static const Color primaryLight = Color(0xFF030213);
  static const Color primaryForegroundLight = Color(0xFFFFFFFF);

  static const Color secondaryLight = Color(0xFFF1F5F9);
  static const Color secondaryForegroundLight = Color(0xFF030213);

  static const Color mutedLight = Color(0xFFECECF0);
  static const Color mutedForegroundLight = Color(0xFF717182);

  static const Color accentLight = Color(0xFFE9EBEF);
  static const Color accentForegroundLight = Color(0xFF030213);

  static const Color destructiveLight = Color(0xFFD4183D);

  static const Color borderLight = Color.fromRGBO(0, 0, 0, 0.1);

  static const Color inputBackgroundLight = Color(0xFFF3F3F5);

  static const Color switchBackgroundLight = Color(0xFFCBCED4);

  static const Color sidebarLight = Color(0xFFF8FAFC);

  // DARK THEME
  static const Color backgroundDark = Color(0xFF0F172A);
  static const Color foregroundDark = Color(0xFFF8FAFC);

  static const Color cardDark = Color(0xFF1E293B);

  static const Color primaryDark = Color(0xFFF8FAFC);

  static const Color secondaryDark = Color(0xFF334155);

  static const Color mutedDark = Color(0xFF334155);

  static const Color mutedForegroundDark = Color(0xFF94A3B8);

  static const Color accentDark = Color(0xFF334155);

  static const Color destructiveDark = Color(0xFFFF5252);

  static const Color borderDark = Color.fromRGBO(255, 255, 255, 0.06);

  static const Color inputBackgroundDark = Color(0xFF1E293B);

  static const Color sidebarDark = Color(0xFF1E293B);

  // CUSTOM APP COLORS
  static const Color success = Color(0xFF00C853);
  static const Color warning = Color(0xFFFFD54F);
  static const Color info = Color(0xFF2979FF);
  static const Color danger = Color(0xFFFF5252);

  // CHART COLORS
  static const Color chart1 = Color(0xFF6366F1);
  static const Color chart2 = Color(0xFF06B6D4);
  static const Color chart3 = Color(0xFFF59E0B);
  static const Color chart4 = Color(0xFF8B5CF6);
  static const Color chart5 = Color(0xFFEF4444);

  // =========================
  // RADIUS
  // =========================

  static const double radiusSm = 6;
  static const double radiusMd = 8;
  static const double radiusLg = 10;
  static const double radiusXl = 14;

  // =========================
  // TEXT STYLES
  // =========================

  static const String fontFamily = 'Poppins';

  static TextTheme textThemeLight = const TextTheme(
    headlineLarge: TextStyle(
      fontSize: 32,
      fontWeight: FontWeight.w700,
      color: foregroundLight,
      fontFamily: fontFamily,
    ),

    headlineMedium: TextStyle(
      fontSize: 26,
      fontWeight: FontWeight.w700,
      color: foregroundLight,
      fontFamily: fontFamily,
    ),

    headlineSmall: TextStyle(
      fontSize: 22,
      fontWeight: FontWeight.w600,
      color: foregroundLight,
      fontFamily: fontFamily,
    ),

    titleLarge: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w600,
      color: foregroundLight,
      fontFamily: fontFamily,
    ),

    titleMedium: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w500,
      color: foregroundLight,
      fontFamily: fontFamily,
    ),

    bodyLarge: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      color: foregroundLight,
      fontFamily: fontFamily,
    ),

    bodyMedium: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      color: foregroundLight,
      fontFamily: fontFamily,
    ),

    bodySmall: TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w400,
      color: mutedForegroundLight,
      fontFamily: fontFamily,
    ),
  );

  static TextTheme textThemeDark = const TextTheme(
    headlineLarge: TextStyle(
      fontSize: 32,
      fontWeight: FontWeight.w700,
      color: foregroundDark,
      fontFamily: fontFamily,
    ),

    headlineMedium: TextStyle(
      fontSize: 26,
      fontWeight: FontWeight.w700,
      color: foregroundDark,
      fontFamily: fontFamily,
    ),

    headlineSmall: TextStyle(
      fontSize: 22,
      fontWeight: FontWeight.w600,
      color: foregroundDark,
      fontFamily: fontFamily,
    ),

    titleLarge: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w600,
      color: foregroundDark,
      fontFamily: fontFamily,
    ),

    titleMedium: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w500,
      color: foregroundDark,
      fontFamily: fontFamily,
    ),

    bodyLarge: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      color: foregroundDark,
      fontFamily: fontFamily,
    ),

    bodyMedium: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      color: foregroundDark,
      fontFamily: fontFamily,
    ),

    bodySmall: TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w400,
      color: mutedForegroundDark,
      fontFamily: fontFamily,
    ),
  );

  // =========================
  // LIGHT THEME
  // =========================

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    fontFamily: fontFamily,

    brightness: Brightness.light,

    scaffoldBackgroundColor: backgroundLight,

    primaryColor: info,

    colorScheme: const ColorScheme.light(
      primary: info,
      secondary: success,
      error: danger,
      surface: cardLight,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: foregroundLight,
    ),

    textTheme: textThemeLight,

    cardTheme: CardTheme(
      color: cardLight,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radiusXl),
        side: const BorderSide(color: borderLight),
      ),
    ),

    appBarTheme: const AppBarTheme(
      backgroundColor: backgroundLight,
      foregroundColor: foregroundLight,
      elevation: 0,
      centerTitle: false,
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: inputBackgroundLight,

      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 14,
      ),

      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radiusXl),
        borderSide: const BorderSide(color: borderLight),
      ),

      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radiusXl),
        borderSide: const BorderSide(color: borderLight),
      ),

      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radiusXl),
        borderSide: const BorderSide(color: info, width: 1.5),
      ),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: info,
        foregroundColor: Colors.white,
        elevation: 0,

        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 16,
        ),

        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusXl),
        ),

        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          fontFamily: fontFamily,
        ),
      ),
    ),
  );

  // =========================
  // DARK THEME
  // =========================

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    fontFamily: fontFamily,

    brightness: Brightness.dark,

    scaffoldBackgroundColor: backgroundDark,

    primaryColor: info,

    colorScheme: const ColorScheme.dark(
      primary: info,
      secondary: success,
      error: danger,
      surface: cardDark,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: foregroundDark,
    ),

    textTheme: textThemeDark,

    cardTheme: CardTheme(
      color: cardDark,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radiusXl),
        side: const BorderSide(color: borderDark),
      ),
    ),

    appBarTheme: const AppBarTheme(
      backgroundColor: backgroundDark,
      foregroundColor: foregroundDark,
      elevation: 0,
      centerTitle: false,
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: inputBackgroundDark,

      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 14,
      ),

      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radiusXl),
        borderSide: const BorderSide(color: borderDark),
      ),

      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radiusXl),
        borderSide: const BorderSide(color: borderDark),
      ),

      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radiusXl),
        borderSide: const BorderSide(color: info, width: 1.5),
      ),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: info,
        foregroundColor: Colors.white,
        elevation: 0,

        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 16,
        ),

        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusXl),
        ),

        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          fontFamily: fontFamily,
        ),
      ),
    ),
  );
}