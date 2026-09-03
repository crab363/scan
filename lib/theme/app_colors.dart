import 'package:flutter/material.dart';

class AppColors {
  // Deep space / Cyber-medical dark backgrounds
  static const Color background = Color(0xFF040711);
  static const Color backgroundSecondary = Color(0xFF0A0F1D);
  static const Color backgroundTertiary = Color(0xFF111827);
  static const Color surface = Color(0xFF0E1626);
  static const Color surfaceHighlight = Color(0xFF172338);
  static const Color cardGlass = Color(0xCC0C1424);
  static const Color cardGlassBorder = Color(0x3300F2FE);

  // Neon & Luminous Accents
  static const Color cyan = Color(0xFF00F2FE);
  static const Color cyanGlow = Color(0x8000F2FE);
  static const Color neonTeal = Color(0xFF00E5FF);
  static const Color emerald = Color(0xFF00E599);
  static const Color emeraldGlow = Color(0x8000E599);
  static const Color violet = Color(0xFF9D4EDD);
  static const Color violetGlow = Color(0x809D4EDD);
  static const Color magenta = Color(0xFFFF007A);
  static const Color amber = Color(0xFFFFB703);
  static const Color amberGlow = Color(0x80FFB703);
  static const Color alertRed = Color(0xFFFF3366);

  // Modality Signature Colors
  static const Color mriElectric = Color(0xFF00D4FF);
  static const Color ctMatrix = Color(0xFF00FFA3);
  static const Color xrayViolet = Color(0xFFB388FF);

  // Text Colors
  static const Color textPrimary = Color(0xFFF1F5F9);
  static const Color textSecondary = Color(0xFF94A3B8);
  static const Color textMuted = Color(0xFF64748B);
  static const Color textCyan = Color(0xFF38BDF8);
  static const Color textEmerald = Color(0xFF34D399);

  // Gradients
  static const LinearGradient cyanTealGradient = LinearGradient(
    colors: [Color(0xFF00F2FE), Color(0xFF4FACFE)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient emeraldGradient = LinearGradient(
    colors: [Color(0xFF00E599), Color(0xFF00B4D8)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient violetGradient = LinearGradient(
    colors: [Color(0xFFC77DFF), Color(0xFF7B2CBF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient amberGradient = LinearGradient(
    colors: [Color(0xFFFFD166), Color(0xFFFF9F1C)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient darkCardGradient = LinearGradient(
    colors: [Color(0xFF0E1626), Color(0xFF070B14)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient glassOverlayGradient = LinearGradient(
    colors: [Color(0x1A00F2FE), Color(0x0500F2FE), Colors.transparent],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
