// lib/features/habits/habits_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:go_router/go_router.dart';

import '../../theme/theme_extensions.dart';
import '../../shared/shared.dart';  // ← ONE import for all shared components
import '../../domain/entities/habit.dart';
import '../../data/providers/habit_provider.dart';

class HabitsScreen extends ConsumerStatefulWidget {
  const HabitsScreen({super.key});

  @override
  ConsumerState<HabitsScreen> createState() => _HabitsScreenState();
}

class _HabitsScreenState extends ConsumerState<HabitsScreen> {
  String _selectedFilter = 'All';
  final List<String> _filters = ['All', 'Daily', 'Weekly', 'Todo', 'Done'];

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<BitoColorScheme>()!;
    final habitsAsync = ref.watch(habitsProvider);
    final completionStates = ref.watch(habitCompletionProvider);

    return Scaffold(
      backgroundColor: colors.bg,
      appBar: AppBar(
        title: Text(
          'Habits',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: colors.ink,
            letterSpacing: -0.5,
          ),
        ),
        backgroundColor: colors.bg,
        elevation: 0,
        leading: IconButton(
          onPressed: () => context.go('/'),
          icon: Icon(
            PhosphorIcons.arrowLeft(),
            size: 20,
            color: colors.ink,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(
              PhosphorIcons.magnifyingGlass(),
              color: colors.ink2,
            ),
          ),
        ],
      ),
      body: habitsAsync.when(
        data: (habits) {
          // Initialize completion states if empty
          if (completionStates.isEmpty && habits.isNotEmpty) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              ref.read(habitCompletionProvider.notifier).setInitialStates(habits);
            });
          }

          final filtered = _filterHabits(habits, _selectedFilter);

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildFilterChips(context, colors),
              Expanded(
                child: filtered.isEmpty
                    ? _buildEmptyState(context, colors)
                    : _buildHabitsList(context, colors, filtered),
              ),
            ],
          );
        },
        loading: () => const Center(child: LoadingIndicator()),
        error: (error, stack) => Center(
          child: Text(
            'Error loading habits: $error',
            style: TextStyle(color: colors.error),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.go('/habits/create/step1'),
        backgroundColor: colors.signal,
        child: Icon(
          PhosphorIcons.plus(),
          color: colors.signalInk,
        ),
      ),
    );
  }

  Widget _buildFilterChips(BuildContext context, BitoColorScheme colors) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: SizedBox(
        height: 40,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: _filters.length,
          separatorBuilder: (context, index) => const SizedBox(width: 8),
          itemBuilder: (context, index) {
            final filter = _filters[index];
            final isSelected = filter == _selectedFilter;
            return FilterChip(
              label: Text(
                filter,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: isSelected ? colors.signalInk : colors.ink2,
                ),
              ),
              selected: isSelected,
              onSelected: (_) {
                setState(() {
                  _selectedFilter = filter;
                });
              },
              backgroundColor: colors.surface,
              selectedColor: colors.signal,
              side: BorderSide(
                color: isSelected ? colors.signal : colors.line,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildHabitsList(
      BuildContext context,
      BitoColorScheme colors,
      List<Habit> habits,
      ) {
    final completionStates = ref.watch(habitCompletionProvider);

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: habits.length,
      itemBuilder: (context, index) {
        final habit = habits[index];
        final isCompleted = completionStates[habit.id] ?? habit.isCompleted;

        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          decoration: BoxDecoration(
            color: colors.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: colors.line),
          ),
          child: ListTile(
            leading: GestureDetector(
              onTap: () async {
                await ref.read(habitCompletionProvider.notifier).toggleHabit(habit.id);
              },
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
              habit.name,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: isCompleted ? colors.ink3 : colors.ink,
                decoration: isCompleted ? TextDecoration.lineThrough : null,
              ),
            ),
            subtitle: Text(
              '${_getBlockLabel(habit.block)} • ${_getCadenceLabel(habit.cadence)}',
              style: TextStyle(
                fontSize: 12,
                color: colors.ink3,
              ),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (habit.streak > 0)
                  Row(
                    children: [
                      Icon(
                        PhosphorIcons.fire(),
                        size: 16,
                        color: Colors.orange[400],
                      ),
                      const SizedBox(width: 4),
                      Text(
                        habit.streak.toString(),
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
                  onPressed: () {
                    context.go('/habits/${habit.id}');
                  },
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
            onTap: () {
              context.go('/habits/${habit.id}');
            },
          ),
        );
      },
    );
  }

  Widget _buildEmptyState(BuildContext context, BitoColorScheme colors) {
    return EmptyState(
      icon: PhosphorIcons.checkCircle(),
      title: 'No habits found',
      message: 'Start building your routine by adding your first habit.',
      actionText: 'Add Habit',
      onAction: () {
        context.go('/habits/create/step1');
      },
    );
  }

  List<Habit> _filterHabits(List<Habit> habits, String filter) {
    switch (filter) {
      case 'Daily':
        return habits.where((h) => h.cadence == HabitCadence.daily).toList();
      case 'Weekly':
        return habits.where((h) => h.cadence == HabitCadence.weekly).toList();
      case 'Todo':
        return habits.where((h) => !h.isCompleted).toList();
      case 'Done':
        return habits.where((h) => h.isCompleted).toList();
      default:
        return habits;
    }
  }

  String _getBlockLabel(HabitTimeBlock block) {
    switch (block) {
      case HabitTimeBlock.morning:
        return 'MORNING';
      case HabitTimeBlock.afternoon:
        return 'AFTERNOON';
      case HabitTimeBlock.evening:
        return 'EVENING';
    }
  }

  String _getCadenceLabel(HabitCadence cadence) {
    switch (cadence) {
      case HabitCadence.daily:
        return 'DAILY';
      case HabitCadence.weekly:
        return 'WEEKLY';
    }
  }
}

