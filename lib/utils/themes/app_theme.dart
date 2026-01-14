import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

/// [AppTheme] adalah kelas yang menyediakan tema untuk aplikasi
/// dengan mengikuti Material Design dan penerapan warna dari [AppColors]
class AppTheme {
  /// Private constructor untuk mencegah instansiasi
  const AppTheme._();

  /// Mendapatkan tema utama aplikasi
  static ThemeData get theme => ThemeData(
    useMaterial3: false,
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.primaryBlue,
      foregroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
    ),
    textTheme: GoogleFonts.plusJakartaSansTextTheme(),
    primaryColor: AppColors.primaryBlue,
    scaffoldBackgroundColor: Colors.white,
    elevatedButtonTheme: _elevatedButtonThemeData,
    inputDecorationTheme: _inputDecorationTheme,
  );

  /// Tema untuk elevated button
  static ElevatedButtonThemeData get _elevatedButtonThemeData =>
      ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: AppColors.primaryBlue,
          foregroundColor: Colors.white,
          shape: const StadiumBorder(),
          maximumSize: const Size(double.infinity, 56),
          minimumSize: const Size(double.infinity, 56),
        ),
      );

  /// Tema untuk input decoration
  static const InputDecorationTheme _inputDecorationTheme =
      InputDecorationTheme(
        filled: true,
        fillColor: AppColors.backgroundLight,
        iconColor: AppColors.primaryBlue,
        prefixIconColor: AppColors.primaryBlue,
        contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(30)),
          borderSide: BorderSide.none,
        ),
      );
}
