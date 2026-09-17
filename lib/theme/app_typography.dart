import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTypography {
  // Futuristic Display Titles (Orbitron with Prompt fallback for Thai)
  static TextStyle heroTitle = GoogleFonts.orbitron(
    fontSize: 38,
    fontWeight: FontWeight.w900,
    letterSpacing: 2.5,
    color: AppColors.textPrimary,
    height: 1.15,
  );

  static TextStyle displayLarge = GoogleFonts.orbitron(
    fontSize: 28,
    fontWeight: FontWeight.w800,
    letterSpacing: 2.0,
    color: AppColors.textPrimary,
  );

  static TextStyle displayMedium = GoogleFonts.orbitron(
    fontSize: 22,
    fontWeight: FontWeight.w700,
    letterSpacing: 1.5,
    color: AppColors.textPrimary,
  );

  static TextStyle displaySmall = GoogleFonts.orbitron(
    fontSize: 17,
    fontWeight: FontWeight.w700,
    letterSpacing: 1.2,
    color: AppColors.textPrimary,
  );

  // HUD & Telemetry Data (JetBrains Mono)
  static TextStyle hudLabel = GoogleFonts.jetBrainsMono(
    fontSize: 11,
    fontWeight: FontWeight.w700,
    letterSpacing: 1.2,
    color: AppColors.cyan,
  );

  static TextStyle hudValue = GoogleFonts.jetBrainsMono(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.6,
    color: AppColors.textPrimary,
  );

  static TextStyle telemetryCode = GoogleFonts.jetBrainsMono(
    fontSize: 11.5,
    fontWeight: FontWeight.w500,
    color: AppColors.textSecondary,
    height: 1.4,
  );

  // Body & Storytelling (Prompt / Space Grotesk hybrid for Thai & English legibility)
  static TextStyle titleLarge = GoogleFonts.prompt(
    fontSize: 19,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.3,
    color: AppColors.textPrimary,
  );

  static TextStyle titleMedium = GoogleFonts.prompt(
    fontSize: 15.5,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.2,
    color: AppColors.textPrimary,
  );

  static TextStyle bodyLarge = GoogleFonts.prompt(
    fontSize: 14.5,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.2,
    color: AppColors.textPrimary,
    height: 1.5,
  );

  static TextStyle bodyMedium = GoogleFonts.prompt(
    fontSize: 13,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.15,
    color: AppColors.textSecondary,
    height: 1.45,
  );

  static TextStyle bodySmall = GoogleFonts.prompt(
    fontSize: 11,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.1,
    color: AppColors.textMuted,
    height: 1.35,
  );

  static TextStyle button = GoogleFonts.prompt(
    fontSize: 13,
    fontWeight: FontWeight.w700,
    letterSpacing: 1.2,
    color: AppColors.background,
  );
}
