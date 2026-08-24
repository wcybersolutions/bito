// lib/shared/components/shell/shell_screen.dart
import 'package:flutter/material.dart';
import '../navigation/bottom_nav.dart';

class ShellScreen extends StatelessWidget {
  final Widget child;

  const ShellScreen({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: const BottomNav(),
    );
  }
}

