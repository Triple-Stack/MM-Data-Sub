import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';

class AppFont {
  static final AppFont instance = AppFont._robotonal();

  factory AppFont() {
    return instance;
  }

  AppFont._robotonal();

  /// Headline Font Styles
  final TextStyle headlineLarge = GoogleFonts.roboto(
    fontSize: 34,
    fontWeight: FontWeight.w700,
  );
  final TextStyle headlineMedium = GoogleFonts.roboto(
    fontSize: 28,
    fontWeight: FontWeight.w500,
  );
  final TextStyle headlineSmall = GoogleFonts.roboto(
    fontSize: 26,
    fontWeight: FontWeight.w500,
  );

  /// Title Font Styles
  final TextStyle titleLarge = GoogleFonts.roboto(
    fontSize: 20,
    fontWeight: FontWeight.w700,
  );

  final TextStyle titleMedium = GoogleFonts.roboto(
    fontSize: 14,
    fontWeight: FontWeight.w700,
  );
  final TextStyle titleSmall = GoogleFonts.roboto(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.10,
  );

  /// Body Font Styles
  final TextStyle bodyLarge = GoogleFonts.roboto(
    fontSize: 14,
    fontWeight: FontWeight.w400,
  );

  final TextStyle bodyMedium = GoogleFonts.roboto(
    fontSize: 12,
    fontWeight: FontWeight.w400,
  );

  final TextStyle bodySmall = GoogleFonts.roboto(
    fontSize: 10,
    fontWeight: FontWeight.w400,
  );

  /// Label Font Styles
  final TextStyle labelLarge = GoogleFonts.roboto(
    fontSize: 14,
    fontWeight: FontWeight.w500,
  );

  final TextStyle labelMedium = GoogleFonts.roboto(
    fontSize: 12,
    fontWeight: FontWeight.w500,
  );
  final TextStyle labelSmall = GoogleFonts.roboto(
    fontSize: 10,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.50,
  );
}
