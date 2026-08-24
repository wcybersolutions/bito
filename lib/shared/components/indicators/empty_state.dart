// lib/shared/components/indicators/empty_state.dart
import 'package:flutter/material.dart';

import '../../../theme/spacing.dart';
import '../buttons/primary_button.dart';
import 'package:bito/theme/theme_extensions.dart';

class EmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String message;
  final String? actionText;
  final VoidCallback? onAction;

  const EmptyState({
    super.key,
    required this.icon,
    required this.title,
    required this.message,
    this.actionText,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<BitoColorScheme>()!;
    final textTheme = Theme.of(context).textTheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(BitoSpacing.xl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 72,
              color: colors.ink3,
            ),
            const SizedBox(height: BitoSpacing.lg),
            Text(
              title,
              style: textTheme.headlineMedium?.copyWith(
                color: colors.ink,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: BitoSpacing.sm),
            Text(
              message,
              textAlign: TextAlign.center,
              style: textTheme.bodyMedium?.copyWith(
                color: colors.ink2,
              ),
            ),
            if (actionText != null && onAction != null) ...[
              const SizedBox(height: BitoSpacing.xl),
              PrimaryButton(
                text: actionText!,
                onPressed: onAction,
                expanded: false,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

