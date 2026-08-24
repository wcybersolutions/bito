import 'package:flutter/material.dart';

import '../../../theme/radius.dart';
import '../../../theme/spacing.dart';


class SecondaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final Widget? icon;
  final bool expanded;

  const SecondaryButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.icon,
    this.expanded = true,
  });

  @override
  Widget build(BuildContext context) {
    final button = OutlinedButton.icon(
      onPressed: onPressed,
      icon: icon ?? const SizedBox.shrink(),
      label: Text(text),
      style: OutlinedButton.styleFrom(
        minimumSize: const Size(0, 52),
        padding: const EdgeInsets.symmetric(
          horizontal: BitoSpacing.lg,
          vertical: BitoSpacing.md,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            BitoRadius.lg,
          ),
        ),
      ),
    );

    return expanded
        ? SizedBox(
      width: double.infinity,
      child: button,
    )
        : button;
  }
}

