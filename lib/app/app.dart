// lib/app/app.dart
import 'package:flutter/material.dart';

import 'router.dart';
import '../theme/bito_theme.dart';

class BitoApp extends StatelessWidget {
  const BitoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Bito',
      debugShowCheckedModeBanner: false,

      // Theme
      theme: BitoTheme.light(),
      darkTheme: BitoTheme.dark(),
      themeMode: ThemeMode.system,

      // Router
      routerConfig: router,
    );
  }
}

