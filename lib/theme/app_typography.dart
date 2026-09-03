import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTypography {
  // Futuristic Display Titles (Orbitron)
  static TextStyle heroTitle = GoogleFonts.orbitron(
    fontSize: 42,
    fontWeight: FontWeight.w900,
    letterSpacing: 4.0,
    color: AppColors.textPrimary,
    height: 1.1,
  );

  static TextStyle displayLarge = GoogleFonts.orbitron(
    fontSize: 32,
    fontWeight: FontWeight.w800,
    letterSpacing: 3.0,
    color: AppColors.textPrimary,
  );

  static TextStyle displayMedium = GoogleFonts.orbitron(
    fontSize: 24,
    fontWeight: FontWeight.w700,
    letterSpacing: 2.0,
    color: AppColors.textPrimary,
  );

  static TextStyle displaySmall = GoogleFonts.orbitron(
    fontSize: 18,
    fontWeight: FontWeight.w700,
    letterSpacing: 1.5,
    color: AppColors.textPrimary,
  );

  // HUD & Telemetry Data (JetBrains Mono / Orbitron)
  static TextStyle hudLabel = GoogleFonts.jetBrainsMono(
    fontSize: 11,
    fontWeight: FontWeight.w700,
    letterSpacing: 1.8,
    color: AppColors.cyan,
  );

  static TextStyle hudValue = GoogleFonts.jetBrainsMono(
    fontSize: 15,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.8,
    color: AppColors.textPrimary,
  );

  static TextStyle telemetryCode = GoogleFonts.jetBrainsMono(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: AppColors.textSecondary,
    height: 1.4,
  );

  // Body & Storytelling (Space Grotesk)
  static TextStyle titleLarge = GoogleFonts.spaceGrotesk(
    fontSize: 20,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.5,
    color: AppColors.textPrimary,
  );

  static TextStyle titleMedium = GoogleFonts.spaceGrotesk(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.3,
    color: AppColors.textPrimary,
  );

  static TextStyle bodyLarge = GoogleFonts.spaceGrotesk(
    fontSize: 15,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.2,
    color: AppColors.textPrimary,
    height: 1.5,
  );

  static TextStyle bodyMedium = GoogleFonts.spaceGrotesk(
    fontSize: 13,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.2,
    color: AppColors.textSecondary,
    height: 1.5,
  );

  static TextStyle bodySmall = GoogleFonts.spaceGrotesk(
    fontSize: 11,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.1,
    color: AppColors.textMuted,
    height: 1.4,
  );

  static TextStyle button = GoogleFonts.orbitron(
    fontSize: 13,
    fontWeight: FontWeight.w700,
    letterSpacing: 2.0,
    color: AppColors.background,
  );
}
