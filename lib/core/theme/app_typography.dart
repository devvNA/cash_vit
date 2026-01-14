import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTypography {
  AppTypography._();

  static TextTheme get textTheme {
    return TextTheme(
      // Headings
      displayLarge: GoogleFonts.plusJakartaSans(
        fontSize: 48,
        fontWeight: FontWeight.bold,
      ),
      headlineLarge: GoogleFonts.plusJakartaSans(
        fontSize: 32,
        fontWeight: FontWeight.bold,
      ),
      headlineMedium: GoogleFonts.plusJakartaSans(
        fontSize: 24,
        fontWeight: FontWeight.bold,
      ),
      headlineSmall: GoogleFonts.plusJakartaSans(
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
      // Body
      bodyLarge: GoogleFonts.plusJakartaSans(
        fontSize: 16,
        fontWeight: FontWeight.w500,
      ),
      bodyMedium: GoogleFonts.plusJakartaSans(
        fontSize: 14,
        fontWeight: FontWeight.normal,
      ),
      bodySmall: GoogleFonts.plusJakartaSans(
        fontSize: 12,
        fontWeight: FontWeight.normal,
      ),
      // Labels
      labelLarge: GoogleFonts.plusJakartaSans(
        fontSize: 14,
        fontWeight: FontWeight.w600,
      ),
      labelMedium: GoogleFonts.plusJakartaSans(
        fontSize: 12,
        fontWeight: FontWeight.w500,
      ),
      labelSmall: GoogleFonts.plusJakartaSans(
        fontSize: 10,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  // Custom styles
  static TextStyle get displayAmount =>
      GoogleFonts.plusJakartaSans(fontSize: 48, fontWeight: FontWeight.bold);

  static TextStyle get amountLarge =>
      GoogleFonts.plusJakartaSans(fontSize: 24, fontWeight: FontWeight.bold);

  static TextStyle get amountMedium =>
      GoogleFonts.plusJakartaSans(fontSize: 18, fontWeight: FontWeight.w600);
}
