// lib/shared/components/bito_logo.dart
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:bito/theme/theme_extensions.dart';

class BitoLogo extends StatelessWidget {
  final double size;
  final bool showText;

  const BitoLogo({
    super.key,
    this.size = 28,
    this.showText = true,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<BitoColorScheme>()!;
    final textTheme = Theme.of(context).textTheme;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Target icon
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(size * 0.2),
            color: colors.signal.withOpacity(0.1),
            border: Border.all(color: colors.signal2),
          ),
          child: Center(
            child: Icon(
              PhosphorIcons.target(),
              size: size * 0.65,
              color: colors.signal,
            ),
          ),
        ),
        if (showText) ...[
          const SizedBox(width: 8),
          Text(
            'bito',
            style: textTheme.headlineSmall?.copyWith(
              color: colors.ink,
              letterSpacing: -0.8,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ],
    );
  }
}

