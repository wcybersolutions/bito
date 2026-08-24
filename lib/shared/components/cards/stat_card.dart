import 'package:flutter/material.dart';

import '../../../theme/spacing.dart';
import 'app_card.dart';

class StatCard extends StatelessWidget {
  final String title;
  final String value;
  final String? subtitle;
  final Widget? icon;

  const StatCard({
    super.key,
    required this.title,
    required this.value,
    this.subtitle,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          if (icon != null) icon!,

          const SizedBox(height: BitoSpacing.sm),

          Text(
            value,
            style: Theme.of(context).textTheme.headlineMedium,
          ),

          const SizedBox(height: 4),

          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium,
          ),

          if (subtitle != null) ...[
            const SizedBox(height: 2),
            Text(
              subtitle!,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ],
      ),
    );
  }
}

