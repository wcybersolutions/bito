import 'package:flutter/material.dart';

import '../../../theme/radius.dart';
import '../../../theme/spacing.dart';
import '../../../theme/theme_extensions.dart';

class ActionCard extends StatelessWidget {
  final Widget icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const ActionCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Material(
      color: colors.surface,
      borderRadius: BorderRadius.circular(BitoRadius.lg),
      child: InkWell(
        borderRadius: BorderRadius.circular(BitoRadius.lg),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(BitoSpacing.md),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(BitoRadius.lg),
            border: Border.all(
              color: colors.line,
            ),
          ),
          child: Row(
            children: [

              CircleAvatar(
                backgroundColor: colors.signal.withOpacity(.12),
                child: icon,
              ),

              const SizedBox(width: BitoSpacing.md),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),

                    const SizedBox(height: 4),

                    Text(
                      subtitle,
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(
                        color: colors.ink3,
                      ),
                    ),
                  ],
                ),
              ),

              Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: colors.ink3,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

