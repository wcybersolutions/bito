// lib/features/more/more_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:go_router/go_router.dart';
// import '../../theme/theme_extensions.dart';
import '../../shared/shared.dart';

class MoreScreen extends ConsumerWidget {
  const MoreScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).extension<BitoColorScheme>()!;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () => context.go('/'),
                child: Container(
                  color: Colors.transparent,
                ),
              ),
            ),
            // Bottom sheet
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: colors.bg,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(20),
                ),
                border: Border(
                  top: BorderSide(color: colors.line),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 12, bottom: 8),
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: colors.line2,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  // Header
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 8,
                    ),
                    child: Row(
                      children: [
                        Text(
                          'MORE',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: colors.ink3,
                            letterSpacing: 1.5,
                            fontFamily: 'SpaceMono',
                          ),
                        ),
                        const Spacer(),
                        IconButton(
                          onPressed: () => context.go('/'),
                          icon: Icon(
                            PhosphorIcons.x(),
                            size: 18,
                            color: colors.ink2,
                          ),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 4),
                  // Content
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        
                        _MenuItem(
                          icon: PhosphorIcons.gear(),
                          label: 'Settings',
                          colors: colors,
                          onTap: () => context.go('/settings'),
                        ),
                        const SizedBox(height: 8),

                        _MenuItem(
                          icon: PhosphorIcons.repeat(),
                          label: 'Habits',
                          colors: colors,
                          onTap: () => context.go('/habits'),
                        ),
                        const SizedBox(height: 8),

                        _MenuItem(
                          icon: PhosphorIcons.notePencil(),
                          label: 'Journal',
                          colors: colors,
                          onTap: () => context.go('/journal'),
                        ),
                        const SizedBox(height: 8),

                        _MenuItem(
                          icon: PhosphorIcons.compass(),
                          label: 'Compass',
                          colors: colors,
                          onTap: () => context.go('/compass'),
                        ),
                        const SizedBox(height: 16),
                        const ThemeDropdown(),
                        const SizedBox(height: 12),

                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: colors.error.withValues(alpha: 0.08),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Center(
                            child: Text(
                              'Sign out',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: colors.error,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        // App version
                        Center(
                          child: Text(
                            'bito  ·  v1.0.0',
                            style: TextStyle(
                              fontSize: 11,
                              color: colors.ink3,
                              fontFamily: 'SpaceMono',
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Menu Item Widget ──────────────────────────────────────────────────────

class _MenuItem extends StatelessWidget {
  const _MenuItem({
    required this.icon,
    required this.label,
    required this.colors,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final BitoColorScheme colors;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: colors.line),
        ),
        child: Row(
          children: [
            Icon(icon, size: 20, color: colors.ink2),
            const SizedBox(width: 12),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: colors.ink,
              ),
            ),
            const Spacer(),
            Icon(
              PhosphorIcons.caretRight(),
              size: 16,
              color: colors.ink3,
            ),
          ],
        ),
      ),
    );
  }
}

