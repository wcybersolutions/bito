// lib/data/habits/habits_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'habit.dart';
import 'habits_repository.dart';

// Provider for the repository
final habitsRepositoryProvider = Provider<HabitsRepository>((ref) {
  return HabitsRepository();
});

// Provider for the list of habits
final habitsProvider = FutureProvider<List<Habit>>((ref) async {
  final repository = ref.read(habitsRepositoryProvider);
  return repository.getHabits();
});

// Provider for daily habits
final dailyHabitsProvider = FutureProvider<List<Habit>>((ref) async {
  final repository = ref.read(habitsRepositoryProvider);
  return repository.getDailyHabits();
});

// Provider for weekly habits
final weeklyHabitsProvider = FutureProvider<List<Habit>>((ref) async {
  final repository = ref.read(habitsRepositoryProvider);
  return repository.getWeeklyHabits();
});

// Provider for habits by time block
final habitsByBlockProvider = FutureProvider<Map<HabitTimeBlock, List<Habit>>>((
  ref,
) async {
  final repository = ref.read(habitsRepositoryProvider);
  return repository.getHabitsByBlock();
});

// State notifier for habit completion
class HabitCompletionNotifier extends StateNotifier<Map<String, bool>> {
  final HabitsRepository _repository;

  HabitCompletionNotifier(this._repository) : super({});

  Future<void> toggleHabit(String habitId) async {
    final current = state[habitId] ?? false;
    state = {...state, habitId: !current};

    // Update in repository
    await _repository.toggleHabitCompletion(habitId);
  }

  Future<void> loadHabitStates(List<Habit> habits) async {
    final states = <String, bool>{};
    for (final habit in habits) {
      states[habit.id] = habit.isCompleted;
    }
    state = states;
  }
}

// Provider for habit completion state
final habitCompletionProvider =
    StateNotifierProvider<HabitCompletionNotifier, Map<String, bool>>((ref) {
      final repository = ref.read(habitsRepositoryProvider);
      return HabitCompletionNotifier(repository);
    });

// Provider for habit statistics
final habitStatsProvider = FutureProvider<HabitStats>((ref) async {
  final repository = ref.read(habitsRepositoryProvider);
  return repository.getStats();
});

// Model for habit statistics
class HabitStats {
  final int totalHabits;
  final int completedToday;
  final int weeklyCompleted;
  final int streak;
  final double completionRate;

  HabitStats({
    required this.totalHabits,
    required this.completedToday,
    required this.weeklyCompleted,
    required this.streak,
    required this.completionRate,
  });
}
