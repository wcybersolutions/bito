// lib/features/habits/widgets/habit_card.dart
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:bito/theme/theme_extensions.dart';

class HabitCard extends StatelessWidget {
  final String name;
  final bool isCompleted;
  final int streak;
  final VoidCallback? onToggle;
  final VoidCallback? onEdit;

  const HabitCard({
    super.key,
    required this.name,
    this.isCompleted = false,
    this.streak = 0,
    this.onToggle,
    this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<BitoColorScheme>()!;

    return Container(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colors.line),
      ),
      child: ListTile(
        leading: GestureDetector(
          onTap: onToggle,
          child: Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: isCompleted ? colors.signal : colors.line2,
                width: 2,
              ),
              color: isCompleted ? colors.signal : Colors.transparent,
            ),
            child: isCompleted
                ? Icon(Icons.check, size: 16, color: colors.signalInk)
                : null,
          ),
        ),
        title: Text(
          name,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: isCompleted ? colors.ink3 : colors.ink,
            decoration: isCompleted ? TextDecoration.lineThrough : null,
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (streak > 0)
              Row(
                children: [
                  Icon(
                    PhosphorIcons.fire(),
                    size: 16,
                    color: Colors.orange[400],
                  ),
                  const SizedBox(width: 4),
                  Text(
                    streak.toString(),
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: colors.ink2,
                    ),
                  ),
                ],
              ),
            const SizedBox(width: 8),
            IconButton(
              onPressed: onEdit,
              icon: Icon(
                PhosphorIcons.pencil(),
                size: 16,
                color: colors.ink3,
              ),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
          ],
        ),
        onTap: onToggle,
      ),
    );
  }
}

