// lib/theme/bito_theme.dart
import 'package:flutter/material.dart';

import 'colors.dart';
import 'theme_extensions.dart';
import 'typography.dart';
import 'radius.dart';

class BitoTheme {
  const BitoTheme._();

  static ThemeData light() {
    return _buildTheme(
      brightness: Brightness.light,
      colors: const BitoColorScheme(
        bg: BitoColors.lightBg,
        bg2: BitoColors.lightBg2,
        surface: BitoColors.lightSurface,
        surface2: BitoColors.lightSurface2,
        ink: BitoColors.lightInk,
        ink2: BitoColors.lightInk2,
        ink3: BitoColors.lightInk3,
        line: BitoColors.lightLine,
        line2: BitoColors.lightLine2,
        line3: BitoColors.lightLine3,
        signal: BitoColors.signal,
        signal2: BitoColors.signal2,
        signalInk: BitoColors.signalInk,
        success: BitoColors.success,
        warning: BitoColors.warning,
        error: BitoColors.error,
      ),
    );
  }

  static ThemeData dark() {
    return _buildTheme(
      brightness: Brightness.dark,
      colors: const BitoColorScheme(
        bg: BitoColors.darkBg,
        bg2: BitoColors.darkBg2,
        surface: BitoColors.darkSurface,
        surface2: BitoColors.darkSurface2,
        ink: BitoColors.darkInk,
        ink2: BitoColors.darkInk2,
        ink3: BitoColors.darkInk3,
        line: BitoColors.darkLine,
        line2: BitoColors.darkLine2,
        line3: BitoColors.darkLine3,
        signal: BitoColors.signal,
        signal2: BitoColors.signal2,
        signalInk: BitoColors.signalInk,
        success: BitoColors.success,
        warning: BitoColors.warning,
        error: BitoColors.error,
      ),
    );
  }

  static ThemeData _buildTheme({
    required Brightness brightness,
    required BitoColorScheme colors,
  }) {
    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      scaffoldBackgroundColor: colors.bg,
      colorScheme: ColorScheme.fromSeed(
        seedColor: colors.signal,
        brightness: brightness,
      ),
      textTheme: BitoTypography.textTheme(colors.ink),
      extensions: [colors],

      // Card theme - use CardThemeData
      cardTheme: CardThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(BitoRadius.card),
        ),
        color: colors.surface,
        elevation: 0,
        clipBehavior: Clip.antiAlias,
      ),

      // Apply custom radius to button themes
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(BitoRadius.button),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(BitoRadius.button),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(BitoRadius.button),
          ),
        ),
      ),

      // Chip theme - use ChipThemeData
      chipTheme: ChipThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(BitoRadius.pill),
        ),
        backgroundColor: colors.surface,
        selectedColor: colors.signal,
        secondarySelectedColor: colors.signal2,
        labelStyle: TextStyle(
          color: colors.ink,
          fontFamily: 'SpaceMono',
          fontSize: 11,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.0,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      ),
    );
  }
}

