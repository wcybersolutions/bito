// lib/shared/components/section_divider.dart
import 'package:flutter/material.dart';
import 'package:bito/theme/theme_extensions.dart';

class SectionDivider extends StatelessWidget {
  final double height;
  final Color? color;
  final double indent;
  final double endIndent;

  const SectionDivider({
    super.key,
    this.height = 1,
    this.color,
    this.indent = 0,
    this.endIndent = 0,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<BitoColorScheme>()!;

    return Divider(
      height: height,
      color: color ?? colors.line,
      indent: indent,
      endIndent: endIndent,
    );
  }
}

