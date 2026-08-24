// lib/features/dashboard/widgets/recent_habit_card.dart
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../shared/components/cards/app_card.dart';
import 'package:bito/theme/theme_extensions.dart';

class RecentHabitCard extends StatelessWidget {
  final String habitName;
  final int streak;

  const RecentHabitCard({
    super.key,
    required this.habitName,
    required this.streak,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<BitoColorScheme>()!;
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: AppCard(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Icon(
                PhosphorIcons.fire(),
                color: streak > 0 ? Colors.orange[400] : colors.ink3,
                size: 24,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      habitName,
                      style: textTheme.titleMedium?.copyWith(
                        color: colors.ink,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '$streak day streak',
                      style: textTheme.bodyMedium?.copyWith(
                        color: colors.ink2,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

