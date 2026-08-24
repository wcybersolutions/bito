import 'package:flutter/material.dart';

import '../../../theme/radius.dart';
import '../../../theme/spacing.dart';
import '../../../theme/theme_extensions.dart';

class AppChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback? onTap;

  const AppChip({
    super.key,
    required this.label,
    this.selected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return InkWell(
      borderRadius: BorderRadius.circular(BitoRadius.pill),
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOut,
        padding: const EdgeInsets.symmetric(
          horizontal: BitoSpacing.md,
          vertical: 10,
        ),
        decoration: BoxDecoration(
          color: selected
              ? colors.signal
              : colors.surface,
          borderRadius:
          BorderRadius.circular(BitoRadius.pill),
          border: Border.all(
            color: selected
                ? colors.signal
                : colors.line,
          ),
        ),
        child: Text(
          label.toUpperCase(),
          style: Theme.of(context)
              .textTheme
              .labelLarge
              ?.copyWith(
            color: selected
                ? colors.signalInk
                : colors.ink2,
          ),
        ),
      ),
    );
  }
}

