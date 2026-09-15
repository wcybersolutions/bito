// lib/app/app.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'router.dart';
import '../theme/bito_theme.dart';
import '../core/providers/theme_provider.dart';

class BitoApp extends ConsumerWidget {
  const BitoApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the themeModeProvider so the widget tree rebuilds on change
    final themeMode = ref.watch(themeModeProvider);

    return MaterialApp.router(
      title: 'Bito',
      debugShowCheckedModeBanner: false,

      // Theme
      theme: BitoTheme.light(),
      darkTheme: BitoTheme.dark(),
      themeMode: themeMode, // Uses the watched provider value

      // Router
      routerConfig: router,
    );
  }
}