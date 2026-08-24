// lib/features/widgets/weekly_habits_card.dart
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:bito/theme/theme_extensions.dart';

class WeeklyHabitsCard extends StatefulWidget {
  final List<WeeklyHabit> habits;

  const WeeklyHabitsCard({
    super.key,
    required this.habits,
  });

  @override
  State<WeeklyHabitsCard> createState() => _WeeklyHabitsCardState();
}

class _WeeklyHabitsCardState extends State<WeeklyHabitsCard> {
  // Track progress for each habit by id
  late Map<String, int> _progressMap;

  @override
  void initState() {
    super.initState();
    // Initialize progress from the habits list
    _progressMap = {
      for (var habit in widget.habits) habit.id: habit.progress,
    };
  }

  void _toggleProgress(String habitId, int target) {
    setState(() {
      final currentProgress = _progressMap[habitId] ?? 0;
      if (currentProgress < target) {
        _progressMap[habitId] = currentProgress + 1;
      } else {
        _progressMap[habitId] = 0;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<BitoColorScheme>()!;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'This Week',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: colors.ink,
                  letterSpacing: -0.3,
                ),
              ),
              TextButton(
                onPressed: () {
                  context.go('/habits');
                },
                child: Text(
                  'View All',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: colors.signal,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            decoration: BoxDecoration(
              color: colors.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: colors.line),
            ),
            child: Column(
              children: widget.habits.asMap().entries.map((entry) {
                final index = entry.key;
                final habit = entry.value;
                final progress = _progressMap[habit.id] ?? habit.progress;
                final isComplete = progress >= habit.target;

                return Column(
                  children: [
                    _buildWeeklyHabitTile(
                      habit: habit,
                      progress: progress,
                      isComplete: isComplete,
                      colors: colors,
                    ),
                    if (index < widget.habits.length - 1)
                      Divider(height: 1, indent: 52, color: colors.line),
                  ],
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeeklyHabitTile({
    required WeeklyHabit habit,
    required int progress,
    required bool isComplete,
    required BitoColorScheme colors,
  }) {
    return InkWell(
      onTap: () => _toggleProgress(habit.id, habit.target),
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            // Rectangle checkbox with rounded corners
            GestureDetector(
              onTap: () => _toggleProgress(habit.id, habit.target),
              child: Container(
                width: 22,
                height: 22,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(
                    color: isComplete ? colors.signal : colors.line2,
                    width: 2,
                  ),
                  color: isComplete ? colors.signal : Colors.transparent,
                ),
                child: isComplete
                    ? Icon(
                  Icons.check,
                  size: 14,
                  color: colors.signalInk,
                )
                    : null,
              ),
            ),
            const SizedBox(width: 12),
            // Habit icon
            Icon(
              habit.icon,
              size: 20,
              color: colors.ink2,
            ),
            const SizedBox(width: 12),
            // Habit label
            Expanded(
              child: Text(
                habit.name,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: isComplete ? colors.ink3 : colors.ink,
                  decoration: isComplete ? TextDecoration.lineThrough : null,
                ),
              ),
            ),
            // Weekly progress dots
            Row(
              children: [
                ...List.generate(habit.target, (index) {
                  final isDone = index < progress;
                  return Container(
                    width: 8,
                    height: 8,
                    margin: const EdgeInsets.only(right: 2),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isDone ? colors.signal : colors.line2,
                    ),
                  );
                }),
                const SizedBox(width: 8),
                Text(
                  '$progress/${habit.target}',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: colors.ink3,
                  ),
                ),
              ],
            ),
            const SizedBox(width: 8),
            // Edit icon
            IconButton(
              onPressed: () {},
              icon: Icon(
                PhosphorIcons.pencil(),
                size: 16,
                color: colors.ink3,
              ),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              style: IconButton.styleFrom(
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class WeeklyHabit {
  final String id;
  final String name;
  final IconData icon;
  final int target;
  final int progress;

  const WeeklyHabit({
    required this.id,
    required this.name,
    required this.icon,
    required this.target,
    required this.progress,
  });
}


