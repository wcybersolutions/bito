// lib/features/more/more_screen.dart
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:go_router/go_router.dart';

import '../../theme/theme_extensions.dart';

class MoreScreen extends StatelessWidget {
  const MoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<BitoColorScheme>()!;

    return Scaffold(
      backgroundColor: colors.bg,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          children: [
            // ── Header ──────────────────────────────────────────────────────
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
            const SizedBox(height: 4),
            Text(
              'Explore',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w700,
                color: colors.ink,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 28),

            // ── Quick Links ─────────────────────────────────────────────────
            _SectionLabel(label: 'QUICK LINKS', colors: colors),
            const SizedBox(height: 8),
            _SettingsCard(
              colors: colors,
              children: [
                _NavRow(
                  icon: PhosphorIcons.repeat(),
                  label: 'Habits',
                  subtitle: 'Track your daily & weekly habits',
                  colors: colors,
                  onTap: () => context.go('/habits'),
                ),
                _Divider(colors: colors),
                _NavRow(
                  icon: PhosphorIcons.notePencil(),
                  label: 'Journal',
                  subtitle: 'Daily reflections and entries',
                  colors: colors,
                  onTap: () => context.go('/journal'),
                ),
                _Divider(colors: colors),
                _NavRow(
                  icon: PhosphorIcons.compass(),
                  label: 'Compass',
                  subtitle: 'Your values and long-term goals',
                  colors: colors,
                  onTap: () => context.go('/compass'),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // ── Account ─────────────────────────────────────────────────────
            _SectionLabel(label: 'ACCOUNT', colors: colors),
            const SizedBox(height: 8),
            _SettingsCard(
              colors: colors,
              children: [
                _NavRow(
                  icon: PhosphorIcons.user(),
                  label: 'Profile',
                  subtitle: 'Edit your name, avatar, and bio',
                  colors: colors,
                  onTap: () => context.go('/profile'),
                ),
                _Divider(colors: colors),
                _NavRow(
                  icon: PhosphorIcons.bell(),
                  label: 'Notifications',
                  subtitle: 'Manage reminders and alerts',
                  colors: colors,
                  onTap: () => context.go('/notifications'),
                ),
                _Divider(colors: colors),
                _NavRow(
                  icon: PhosphorIcons.gear(),
                  label: 'Settings',
                  subtitle: 'Preferences, data, and account',
                  colors: colors,
                  onTap: () => context.go('/settings'),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // ── App version ─────────────────────────────────────────────────
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
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}

// ── Shared sub-widgets ──────────────────────────────────────────────────────

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({required this.label, required this.colors});
  final String label;
  final BitoColorScheme colors;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: TextStyle(
        fontSize: 10,
        fontWeight: FontWeight.w700,
        color: colors.ink3,
        letterSpacing: 1.2,
        fontFamily: 'SpaceMono',
      ),
    );
  }
}

class _SettingsCard extends StatelessWidget {
  const _SettingsCard({required this.colors, required this.children});
  final BitoColorScheme colors;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: colors.line),
      ),
      child: Column(children: children),
    );
  }
}

class _NavRow extends StatelessWidget {
  const _NavRow({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.colors,
    required this.onTap,
  });
  final IconData icon;
  final String label;
  final String subtitle;
  final BitoColorScheme colors;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: colors.surface2,
                borderRadius: BorderRadius.circular(9),
              ),
              child: Icon(icon, size: 18, color: colors.ink2),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: colors.ink,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(fontSize: 12, color: colors.ink3),
                  ),
                ],
              ),
            ),
            Icon(PhosphorIcons.caretRight(), size: 16, color: colors.ink3),
          ],
        ),
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  const _Divider({required this.colors});
  final BitoColorScheme colors;

  @override
  Widget build(BuildContext context) {
    return Divider(height: 1, indent: 66, color: colors.line);
  }
}
