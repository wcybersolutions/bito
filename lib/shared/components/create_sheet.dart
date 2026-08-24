// lib/shared/components/create_sheet.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:bito/theme/theme_extensions.dart';
import 'package:bito/theme/radius.dart';

class CreateSheet extends StatelessWidget {
  const CreateSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<BitoColorScheme>()!;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
      decoration: BoxDecoration(
        color: colors.bg,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag handle
          Container(
            width: 36,
            height: 4,
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: colors.line2,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          // Options
          _buildOption(
            context,
            icon: PhosphorIcons.plus(),
            iconBgColor: const Color(0xFFA78BFA),
            label: 'New Habit',
            description: 'Create a new habit to track',
            onTap: () {
              Navigator.pop(context);
              context.go('/habits/create/step1');
            },
          ),
          const SizedBox(height: 12),
          _buildOption(
            context,
            icon: PhosphorIcons.pencil(),
            iconBgColor: const Color(0xFF2563EB),
            label: 'Journal Entry',
            description: 'Write down your thoughts',
            onTap: () {
              Navigator.pop(context);
              context.go('/journal/new');
            },
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _buildOption(
      BuildContext context, {
        required IconData icon,
        required Color iconBgColor,
        required String label,
        required String description,
        required VoidCallback onTap,
      }) {
    final colors = Theme.of(context).extension<BitoColorScheme>()!;
    final textTheme = Theme.of(context).textTheme;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(BitoRadius.card),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.circular(BitoRadius.card),
          border: Border.all(color: colors.line),
        ),
        child: Row(
          children: [
            // Icon with rounded rectangle background
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: iconBgColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                size: 24,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: textTheme.titleMedium?.copyWith(
                      color: colors.ink,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 13,
                      color: colors.ink2,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              PhosphorIcons.arrowRight(),
              size: 20,
              color: colors.ink3,
            ),
          ],
        ),
      ),
    );
  }
}

