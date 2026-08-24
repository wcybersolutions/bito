import 'package:flutter/material.dart';

import '../../../theme/radius.dart';
import '../../../theme/shadows.dart';
import '../../../theme/spacing.dart';
import '../../../theme/theme_extensions.dart';

class AppCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final VoidCallback? onTap;

  const AppCard({
    super.key,
    required this.child,
    this.padding,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    final content = Container(
      padding: padding ?? const EdgeInsets.all(BitoSpacing.md),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(
          BitoRadius.lg,
        ),
        border: Border.all(
          color: colors.line,
        ),
        boxShadow: BitoShadows.sm,
      ),
      child: child,
    );

    if (onTap == null) return content;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(
          BitoRadius.lg,
        ),
        onTap: onTap,
        child: content,
      ),
    );
  }
}


