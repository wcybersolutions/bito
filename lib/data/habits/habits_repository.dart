// lib/data/habits/habits_repository.dart
import 'package:flutter/material.dart';

import 'habit.dart';
import 'habits_provider.dart';

class HabitsRepository {
  // In-memory storage for demo purposes
  static List<Habit> _habits = [];

  HabitsRepository() {
    // Initialize with sample data if empty
    if (_habits.isEmpty) {
      _habits = _getSampleHabits();
    }
  }

  Future<List<Habit>> getHabits() async {
    // Simulate network/database delay
    await Future.delayed(const Duration(milliseconds: 300));
    return _habits;
  }

  Future<List<Habit>> getDailyHabits() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return _habits.where((h) => h.cadence == HabitCadence.daily).toList();
  }

  Future<List<Habit>> getWeeklyHabits() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return _habits.where((h) => h.cadence == HabitCadence.weekly).toList();
  }

  Future<Map<HabitTimeBlock, List<Habit>>> getHabitsByBlock() async {
    await Future.delayed(const Duration(milliseconds: 200));
    final blocks = HabitTimeBlock.values;
    final result = <HabitTimeBlock, List<Habit>>{};

    for (final block in blocks) {
      result[block] = _habits.where((h) => h.block == block).toList();
    }

    return result;
  }

  Future<Habit> addHabit(Habit habit) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _habits.add(habit);
    return habit;
  }

  Future<Habit> updateHabit(Habit habit) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final index = _habits.indexWhere((h) => h.id == habit.id);
    if (index != -1) {
      _habits[index] = habit;
    }
    return habit;
  }

  Future<void> deleteHabit(String habitId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _habits.removeWhere((h) => h.id == habitId);
  }

  Future<void> toggleHabitCompletion(String habitId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    final index = _habits.indexWhere((h) => h.id == habitId);
    if (index != -1) {
      final habit = _habits[index];
      final updated = habit.copyWith(
        isCompleted: !habit.isCompleted,
        streak: habit.isCompleted ? habit.streak : habit.streak + 1,
        updatedAt: DateTime.now(),
      );
      _habits[index] = updated;
    }
  }

  Future<HabitStats> getStats() async {
    await Future.delayed(const Duration(milliseconds: 200));

    final daily = _habits.where((h) => h.cadence == HabitCadence.daily);
    final completedToday = daily.where((h) => h.isCompleted).length;
    final weekly = _habits.where((h) => h.cadence == HabitCadence.weekly);
    final weeklyCompleted = weekly.where((h) => h.isCompleted).length;
    final total = _habits.length;
    final completed = _habits.where((h) => h.isCompleted).length;
    final rate = total > 0 ? (completed / total) * 100 : 0.0;
    final streak = _habits.fold(0, (max, h) => h.streak > max ? h.streak : max);

    return HabitStats(
      totalHabits: total,
      completedToday: completedToday,
      weeklyCompleted: weeklyCompleted,
      streak: streak,
      completionRate: rate.toDouble(),
    );
  }

  List<Habit> _getSampleHabits() {
    return [
      Habit(
        id: '1',
        name: 'Morning Meditation',
        description: 'Start the day with 10 minutes of mindfulness',
        cadence: HabitCadence.daily,
        block: HabitTimeBlock.morning,
        icon: Icons.self_improvement,
        color: Colors.purple,
        streak: 12,
        createdAt: DateTime.now().subtract(const Duration(days: 30)),
      ),
      Habit(
        id: '2',
        name: 'Evening Run',
        description: 'Run 3km after work',
        cadence: HabitCadence.daily,
        block: HabitTimeBlock.evening,
        icon: Icons.directions_run,
        color: Colors.orange,
        streak: 3,
        createdAt: DateTime.now().subtract(const Duration(days: 14)),
      ),
      Habit(
        id: '3',
        name: 'Yoga',
        description: '15 minute yoga session',
        cadence: HabitCadence.daily,
        block: HabitTimeBlock.evening,
        icon: Icons.self_improvement,
        color: Colors.green,
        streak: 5,
        createdAt: DateTime.now().subtract(const Duration(days: 20)),
      ),
      Habit(
        id: '4',
        name: 'Deep Work',
        description: '2 hours of focused work',
        cadence: HabitCadence.daily,
        block: HabitTimeBlock.afternoon,
        icon: Icons.work,
        color: Colors.blue,
        streak: 2,
        createdAt: DateTime.now().subtract(const Duration(days: 10)),
      ),
      Habit(
        id: '5',
        name: 'Read 30 Minutes',
        description: 'Read a book for 30 minutes',
        cadence: HabitCadence.daily,
        block: HabitTimeBlock.evening,
        icon: Icons.menu_book,
        color: Colors.red,
        target: 30,
        progress: 15,
        streak: 8,
        createdAt: DateTime.now().subtract(const Duration(days: 25)),
      ),
      Habit(
        id: '6',
        name: 'Weekly Review',
        description: 'Review goals and progress',
        cadence: HabitCadence.weekly,
        block: HabitTimeBlock.morning,
        icon: Icons.assessment,
        color: Colors.indigo,
        streak: 4,
        createdAt: DateTime.now().subtract(const Duration(days: 21)),
      ),
    ];
  }
}

