// lib/theme/colors.dart
import 'package:flutter/material.dart';

/// Semantic colors used throughout the app.
class BitoColors {
  const BitoColors._();

  // Indigo Default Palette (from Brand & Design System)

  // Dark Theme
  static const Color darkBg = Color(0xFF050507);
  static const Color darkBg2 = Color(0xFF0A0A0F);
  static const Color darkSurface = Color(0xFF141418);
  static const Color darkSurface2 = Color(0xFF1A1A20);
  static const Color darkInk = Color(0xFFF3EFE6);
  static const Color darkInk2 = Color(0xFFB4B0A7);
  static const Color darkInk3 = Color(0xFFB4B4B8); // Made lighter for visibility
  static const Color darkLine = Color(0xFF62626C); // Made lighter for visibility 0xFF4A4A52
  static const Color darkLine2 = Color(0xFF5A5A62);
  static const Color darkLine3 = Color(0xFF6A6A72);

  // Light Theme
  static const Color lightBg = Color(0xFFF4F2EA);
  static const Color lightBg2 = Color(0xFFFAF8F0);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightSurface2 = Color(0xFFF8F6EE);
  static const Color lightInk = Color(0xFF16140F);
  static const Color lightInk2 = Color(0xFF57534A);
  static const Color lightInk3 = Color(0xFF9A978E); // Made darker for visibility
  static const Color lightLine = Color(0xFFC8C6BE); // Made darker for visibility
  static const Color lightLine2 = Color(0xFFB8B6AE);
  static const Color lightLine3 = Color(0xFFA8A69E);

  // Signal (Indigo - Native)
  static const Color signal = Color(0xFF6F4EE6);
  static const Color signal2 = Color(0xFFA78BFA);
  static const Color signalInk = Color(0xFFFFFFFF);

  // Secondary Accents (from design system)
  static const Color ember = Color(0xFFF97316);
  static const Color cobalt = Color(0xFF2563EB);
  static const Color rose = Color(0xFFE11D48);

  // Google Colors
  static const Color googleBlue = Color(0xFF4285F4);
  static const Color googleRed = Color(0xFFEA4335);
  static const Color googleYellow = Color(0xFFFBBC05);
  static const Color googleGreen = Color(0xFF34A853);

  // Status
  static const Color success = Color(0xFF22C55E);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);
}