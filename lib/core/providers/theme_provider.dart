// lib/core/providers/theme_provider.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum AppThemeMode {
  system,
  light,
  dark,
}

extension AppThemeModeExtension on AppThemeMode {
  String get label {
    switch (this) {
      case AppThemeMode.system:
        return 'System';
      case AppThemeMode.light:
        return 'Light';
      case AppThemeMode.dark:
        return 'Dark';
    }
  }

  String get storageKey {
    switch (this) {
      case AppThemeMode.system:
        return 'system';
      case AppThemeMode.light:
        return 'light';
      case AppThemeMode.dark:
        return 'dark';
    }
  }

  IconData get icon {
    switch (this) {
      case AppThemeMode.system:
        return Icons.devices;
      case AppThemeMode.light:
        return Icons.light_mode;
      case AppThemeMode.dark:
        return Icons.dark_mode;
    }
  }

  static AppThemeMode fromStorage(String value) {
    switch (value) {
      case 'system':
        return AppThemeMode.system;
      case 'light':
        return AppThemeMode.light;
      case 'dark':
        return AppThemeMode.dark;
      default:
        return AppThemeMode.system;
    }
  }
}

class ThemeNotifier extends StateNotifier<AppThemeMode> {
  ThemeNotifier() : super(AppThemeMode.system) {
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final saved = prefs.getString('app_theme') ?? 'system';
      state = AppThemeModeExtension.fromStorage(saved);
    } catch (e) {
      state = AppThemeMode.system;
    }
  }

  Future<void> setTheme(AppThemeMode mode) async {
    state = mode;
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('app_theme', mode.storageKey);
    } catch (e) {
      // Handle error
    }
  }

  ThemeMode get themeMode {
    switch (state) {
      case AppThemeMode.system:
        return ThemeMode.system;
      case AppThemeMode.light:
        return ThemeMode.light;
      case AppThemeMode.dark:
        return ThemeMode.dark;
    }
  }
}

final themeProvider = StateNotifierProvider<ThemeNotifier, AppThemeMode>((ref) {
  return ThemeNotifier();
});

final themeModeProvider = Provider<ThemeMode>((ref) {
  final notifier = ref.watch(themeProvider.notifier);
  return notifier.themeMode;
});

