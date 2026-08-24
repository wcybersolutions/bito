// lib/theme/typography.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BitoTypography {
  const BitoTypography._();

  static TextTheme textTheme(Color color) {
    return TextTheme(
      // Display/Headlines - Fraunces (variable serif)
      displayLarge: GoogleFonts.fraunces(
        fontSize: 34,
        fontWeight: FontWeight.w700,
        color: color,
        height: 1.2,
      ),
      displayMedium: GoogleFonts.fraunces(
        fontSize: 28,
        fontWeight: FontWeight.w700,
        color: color,
        height: 1.2,
      ),
      displaySmall: GoogleFonts.fraunces(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: color,
        height: 1.3,
      ),

      // Headlines - Fraunces
      headlineLarge: GoogleFonts.fraunces(
        fontSize: 22,
        fontWeight: FontWeight.w700,
        color: color,
        height: 1.3,
      ),
      headlineMedium: GoogleFonts.fraunces(
        fontSize: 20,
        fontWeight: FontWeight.w700,
        color: color,
        height: 1.3,
        letterSpacing: -0.5,
      ),
      headlineSmall: GoogleFonts.fraunces(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: color,
        height: 1.4,
      ),

      // Body - Hanken Grotesk (sans-serif)
      bodyLarge: GoogleFonts.hankenGrotesk(
        fontSize: 16,
        color: color,
        height: 1.6,
        letterSpacing: 0.01,
      ),
      bodyMedium: GoogleFonts.hankenGrotesk(
        fontSize: 15,
        color: color,
        height: 1.6,
        letterSpacing: 0.01,
      ),
      bodySmall: GoogleFonts.hankenGrotesk(
        fontSize: 14,
        color: color,
        height: 1.5,
        letterSpacing: 0.01,
      ),

      // Labels - Space Mono (uppercase with wide tracking)
      labelLarge: GoogleFonts.spaceMono(
        fontSize: 11,
        fontWeight: FontWeight.w700,
        color: color,
        letterSpacing: 1.2,
        height: 1.4,
      ),
      labelMedium: GoogleFonts.spaceMono(
        fontSize: 10,
        fontWeight: FontWeight.w700,
        color: color,
        letterSpacing: 1.0,
        height: 1.4,
      ),
      labelSmall: GoogleFonts.spaceMono(
        fontSize: 9,
        fontWeight: FontWeight.w700,
        color: color,
        letterSpacing: 0.8,
        height: 1.4,
      ),

      // Numerals - Fraunces (tabular figures)
      titleLarge: GoogleFonts.fraunces(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: color,
        height: 1.4,
        fontFeatures: const [FontFeature.tabularFigures()],
      ),
      titleMedium: GoogleFonts.fraunces(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: color,
        height: 1.4,
        fontFeatures: const [FontFeature.tabularFigures()],
      ),
      titleSmall: GoogleFonts.fraunces(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: color,
        height: 1.4,
        fontFeatures: const [FontFeature.tabularFigures()],
      ),
    );
  }
}

