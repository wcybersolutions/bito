// lib/features/dashboard/widgets/recent_habit_card.dart
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
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

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: colors.line),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: Colors.orange.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                PhosphorIcons.fire(),
                color: streak > 0 ? Colors.orange[400] : colors.ink3,
                size: 24,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    habitName,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: colors.ink,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '$streak day streak',
                    style: TextStyle(
                      fontSize: 13,
                      color: colors.ink2,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              PhosphorIcons.caretRight(),
              size: 16,
              color: colors.ink3,
            ),
          ],
        ),
      ),
    );
  }
}