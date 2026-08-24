import 'package:flutter/material.dart';

import '../../../theme/radius.dart';
import '../../../theme/spacing.dart';

class PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final Widget? icon;
  final bool isLoading;
  final bool expanded;

  const PrimaryButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.icon,
    this.isLoading = false,
    this.expanded = true,
  });

  @override
  Widget build(BuildContext context) {
    final button = FilledButton.icon(
      onPressed: isLoading ? null : onPressed,
      icon: isLoading
          ? const SizedBox(
        height: 18,
        width: 18,
        child: CircularProgressIndicator(
          strokeWidth: 2,
        ),
      )
          : (icon ?? const SizedBox.shrink()),
      label: Text(text),
      style: FilledButton.styleFrom(
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


