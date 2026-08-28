// lib/features/groups/habits/habits_tab.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:bito/theme/theme_extensions.dart';
import 'package:bito/data/groups/group_habit.dart';
import 'package:bito/data/groups/group_habits_provider.dart';
import 'package:bito/features/groups/widgets/add_group_habit_sheet.dart';

class HabitsTab extends ConsumerWidget {
  final String groupId;

  const HabitsTab({
    super.key,
    required this.groupId,
  });

  IconData _getHabitIcon(String iconName) {
    switch (iconName) {
      case 'barbell':
        return PhosphorIcons.barbell();
      case 'sneakerMove':
        return PhosphorIcons.sneakerMove();
      case 'heart':
        return PhosphorIcons.heart();
      case 'drop':
        return PhosphorIcons.drop();
      case 'bookOpen':
        return PhosphorIcons.bookOpen();
      case 'brain':
        return PhosphorIcons.brain();
      case 'sparkle':
        return PhosphorIcons.sparkle();
      case 'checkCircle':
        return PhosphorIcons.checkCircle();
      case 'fire':
        return PhosphorIcons.fire();
      case 'sun':
        return PhosphorIcons.sun();
      case 'moon':
        return PhosphorIcons.moon();
      case 'trophy':
        return PhosphorIcons.trophy();
      default:
        return PhosphorIcons.target();
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).extension<BitoColorScheme>()!;
    final textTheme = Theme.of(context).textTheme;
    final habits = ref.watch(groupHabitsListProvider(groupId));
    final adoptedCount = habits.where((h) => h.isAdopted).length;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header row with count and Create Habit button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'GROUP HABITS · $adoptedCount/${habits.length}',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: colors.ink3,
                  letterSpacing: 0.6,
                  fontFamily: 'SpaceMono',
                ),
              ),
              OutlinedButton.icon(
                onPressed: () => AddGroupHabitSheet.show(context, groupId),
                icon: Icon(
                  PhosphorIcons.plus(),
                  size: 13,
                  color: colors.ink,
                ),
                label: Text(
                  'CREATE HABIT',
                  style: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                    color: colors.ink,
                    letterSpacing: 0.5,
                    fontFamily: 'SpaceMono',
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  side: BorderSide(color: colors.line),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Content: Empty State vs Habit List
          if (habits.isEmpty)
            _buildEmptyHabitsCard(context, colors, textTheme)
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: habits.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                return _buildGroupHabitCard(context, ref, colors, habits[index]);
              },
            ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildEmptyHabitsCard(
    BuildContext context,
    BitoColorScheme colors,
    TextTheme textTheme,
  ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 24),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: colors.line),
      ),
      child: Column(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: colors.signal2.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(
              PhosphorIcons.target(),
              size: 24,
              color: colors.signal2,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'No group habits yet',
            style: textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
              color: colors.ink,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Add the first habit to set the pace for the group',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              color: colors.ink3,
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: () => AddGroupHabitSheet.show(context, groupId),
            icon: Icon(
              PhosphorIcons.plus(),
              size: 14,
              color: Colors.black,
            ),
            label: const Text(
              'CREATE GROUP HABIT',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: Colors.black,
                letterSpacing: 0.5,
                fontFamily: 'SpaceMono',
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: colors.signal2,
              foregroundColor: Colors.black,
              padding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              elevation: 0,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGroupHabitCard(
    BuildContext context,
    WidgetRef ref,
    BitoColorScheme colors,
    GroupHabit habit,
  ) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colors.line),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: Color(habit.color).withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: Color(habit.color).withValues(alpha: 0.3),
                  ),
                ),
                child: Icon(
                  _getHabitIcon(habit.icon),
                  size: 20,
                  color: Color(habit.color),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      habit.name,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: colors.ink,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'DAILY · BY ${habit.createdBy.toUpperCase()}',
                      style: TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.w700,
                        color: colors.ink3,
                        letterSpacing: 0.5,
                        fontFamily: 'SpaceMono',
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  ref
                      .read(groupHabitsProvider.notifier)
                      .toggleAdopt(groupId, habit.id);
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color:
                        habit.isAdopted ? colors.surface2 : Colors.transparent,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                      color: habit.isAdopted ? colors.line : colors.line2,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (habit.isAdopted) ...[
                        Icon(
                          PhosphorIcons.check(),
                          size: 13,
                          color: colors.ink,
                        ),
                        const SizedBox(width: 4),
                      ],
                      Text(
                        habit.isAdopted ? 'ADOPTED' : 'ADOPT',
                        style: TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.w700,
                          color: habit.isAdopted ? colors.ink : colors.ink2,
                          letterSpacing: 0.5,
                          fontFamily: 'SpaceMono',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Divider(height: 1, color: colors.line.withValues(alpha: 0.5)),
          const SizedBox(height: 8),
          Text(
            '${habit.adoptedBy.length} / 2 ADOPTED',
            style: TextStyle(
              fontSize: 8,
              fontWeight: FontWeight.w700,
              color: colors.ink3,
              letterSpacing: 0.5,
              fontFamily: 'SpaceMono',
            ),
          ),
        ],
      ),
    );
  }
}
