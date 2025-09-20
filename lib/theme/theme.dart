import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  static const Color primary = Color(0xFFC67C4E); // 01
  static const Color secondary = Color(0xFFEDD6C8); // 02
  static const Color dark = Color(0xFF313131); // 03
  static const Color greyLight = Color(0xFFE3E3E3); // 04
  static const Color background = Color(0xFFF9F2ED); // 05
}

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    primaryColor: AppColors.primary,
    scaffoldBackgroundColor: AppColors.background,
    fontFamily: GoogleFonts.sora().fontFamily,

    // Text styles
    textTheme: TextTheme(
      displayLarge: const TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: AppColors.dark,
      ),
      displayMedium: const TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.w600,
        color: AppColors.dark,
      ),
      displaySmall: const TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w500,
        color: AppColors.dark,
      ),
      headlineMedium: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w500,
        color: AppColors.dark,
      ),
      bodyLarge: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.normal,
        color: AppColors.dark,
      ),
      bodyMedium: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.normal,
        color: AppColors.dark,
      ),
    ),

    // AppBar styling
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.primary,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: TextStyle(
        fontFamily: GoogleFonts.sora().fontFamily,
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      iconTheme: const IconThemeData(color: Colors.white),
    ),

    // Elevated buttons
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        textStyle: const TextStyle(fontWeight: FontWeight.w600),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
      ),
    ),

    // Outlined buttons
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.primary,
        side: const BorderSide(color: AppColors.primary, width: 1.5),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        textStyle: const TextStyle(fontWeight: FontWeight.w600),
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
      ),
    ),

    // Text buttons
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.primary,
        textStyle: const TextStyle(fontWeight: FontWeight.w600),
      ),
    ),

    // Input fields
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.greyLight,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.transparent),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(
          color: AppColors.primary, // brand color instead of purple
          width: 2,
        ),
      ),
      contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      labelStyle: const TextStyle(color: AppColors.dark),
      floatingLabelStyle: const TextStyle(
        color: AppColors.primary,
        fontWeight: FontWeight.w600,
      ),
    ),

    // Text selection (cursor + highlight)
    textSelectionTheme: const TextSelectionThemeData(
      cursorColor: AppColors.primary,
      selectionColor: AppColors.primary,
      selectionHandleColor: AppColors.primary,
    ),
  );
}

class AppSpacing {
  static const double paddingSmall = 8.0;
  static const double paddingMedium = 16.0;
  static const double paddingLarge = 24.0;

  static const double marginSmall = 8.0;
  static const double marginMedium = 16.0;
  static const double marginLarge = 24.0;

  static const double borderRadius = 12.0;
}
