import 'package:flutter/material.dart';

@immutable
class BitoColorScheme extends ThemeExtension<BitoColorScheme> {
  final Color bg;
  final Color bg2;

  final Color surface;
  final Color surface2;

  final Color ink;
  final Color ink2;
  final Color ink3;

  final Color line;
  final Color line2;
  final Color line3;

  final Color signal;
  final Color signal2;
  final Color signalInk;

  final Color success;
  final Color warning;
  final Color error;

  const BitoColorScheme({
    required this.bg,
    required this.bg2,
    required this.surface,
    required this.surface2,
    required this.ink,
    required this.ink2,
    required this.ink3,
    required this.line,
    required this.line2,
    required this.line3,
    required this.signal,
    required this.signal2,
    required this.signalInk,
    required this.success,
    required this.warning,
    required this.error,
  });

  @override
  BitoColorScheme copyWith({
    Color? bg,
    Color? bg2,
    Color? surface,
    Color? surface2,
    Color? ink,
    Color? ink2,
    Color? ink3,
    Color? line,
    Color? line2,
    Color? line3,
    Color? signal,
    Color? signal2,
    Color? signalInk,
    Color? success,
    Color? warning,
    Color? error,
  }) {
    return BitoColorScheme(
      bg: bg ?? this.bg,
      bg2: bg2 ?? this.bg2,
      surface: surface ?? this.surface,
      surface2: surface2 ?? this.surface2,
      ink: ink ?? this.ink,
      ink2: ink2 ?? this.ink2,
      ink3: ink3 ?? this.ink3,
      line: line ?? this.line,
      line2: line2 ?? this.line2,
      line3: line3 ?? this.line3,
      signal: signal ?? this.signal,
      signal2: signal2 ?? this.signal2,
      signalInk: signalInk ?? this.signalInk,
      success: success ?? this.success,
      warning: warning ?? this.warning,
      error: error ?? this.error,
    );
  }

  @override
  BitoColorScheme lerp(
      covariant ThemeExtension<BitoColorScheme>? other,
      double t,
      ) {
    if (other is! BitoColorScheme) return this;

    return BitoColorScheme(
      bg: Color.lerp(bg, other.bg, t)!,
      bg2: Color.lerp(bg2, other.bg2, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      surface2: Color.lerp(surface2, other.surface2, t)!,
      ink: Color.lerp(ink, other.ink, t)!,
      ink2: Color.lerp(ink2, other.ink2, t)!,
      ink3: Color.lerp(ink3, other.ink3, t)!,
      line: Color.lerp(line, other.line, t)!,
      line2: Color.lerp(line2, other.line2, t)!,
      line3: Color.lerp(line3, other.line3, t)!,
      signal: Color.lerp(signal, other.signal, t)!,
      signal2: Color.lerp(signal2, other.signal2, t)!,
      signalInk: Color.lerp(signalInk, other.signalInk, t)!,
      success: Color.lerp(success, other.success, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      error: Color.lerp(error, other.error, t)!,
    );
  }
}

extension BitoThemeExtension on BuildContext {
  BitoColorScheme get colors =>
      Theme.of(this).extension<BitoColorScheme>()!;
}



