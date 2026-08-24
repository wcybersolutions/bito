// lib/features/habits/widgets/habit_progress.dart
import 'package:flutter/material.dart';
import '../../../theme/theme_extensions.dart';

class HabitProgress extends StatelessWidget {
  final int completed;
  final int total;
  final double height;

  const HabitProgress({
    super.key,
    required this.completed,
    required this.total,
    this.height = 4,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<BitoColorScheme>()!;
    final percentage = total == 0 ? 0.0 : (completed / total).clamp(0.0, 1.0).toDouble();

    return Container(
      height: height,
      decoration: BoxDecoration(
        color: colors.line,
        borderRadius: BorderRadius.circular(2),
      ),
      child: FractionallySizedBox(
        widthFactor: percentage,
        child: Container(
          decoration: BoxDecoration(
            color: colors.signal2,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      ),
    );
  }
}

