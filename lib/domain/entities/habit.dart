// lib/domain/entities/habit.dart
import 'package:equatable/equatable.dart';

enum HabitCadence {
  daily,
  weekly,
}

enum HabitTimeBlock {
  morning,
  afternoon,
  evening,
}

class Habit extends Equatable {
  final String id;
  final String name;
  final String? description;
  final HabitCadence cadence;
  final HabitTimeBlock block;
  final String icon;
  final int color;
  final bool isCompleted;
  final int streak;
  final int? target;
  final int? progress;
  final DateTime createdAt;
  final DateTime? updatedAt;

  const Habit({
    required this.id,
    required this.name,
    this.description,
    required this.cadence,
    required this.block,
    required this.icon,
    required this.color,
    this.isCompleted = false,
    this.streak = 0,
    this.target,
    this.progress,
    required this.createdAt,
    this.updatedAt,
  });

  Habit copyWith({
    String? id,
    String? name,
    String? description,
    HabitCadence? cadence,
    HabitTimeBlock? block,
    String? icon,
    int? color,
    bool? isCompleted,
    int? streak,
    int? target,
    int? progress,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Habit(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      cadence: cadence ?? this.cadence,
      block: block ?? this.block,
      icon: icon ?? this.icon,
      color: color ?? this.color,
      isCompleted: isCompleted ?? this.isCompleted,
      streak: streak ?? this.streak,
      target: target ?? this.target,
      progress: progress ?? this.progress,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  // Helper getters
  bool get isWeekly => cadence == HabitCadence.weekly;
  bool get isDaily => cadence == HabitCadence.daily;
  bool get hasTarget => target != null && target! > 0;
  bool get isComplete => isCompleted;

  @override
  List<Object?> get props => [
    id,
    name,
    description,
    cadence,
    block,
    icon,
    color,
    isCompleted,
    streak,
    target,
    progress,
    createdAt,
    updatedAt,
  ];
}

// Habit Stats Entity
class HabitStats extends Equatable {
  final int totalHabits;
  final int completedToday;
  final int weeklyCompleted;
  final int streak;
  final double completionRate;

  const HabitStats({
    required this.totalHabits,
    required this.completedToday,
    required this.weeklyCompleted,
    required this.streak,
    required this.completionRate,
  });

  @override
  List<Object?> get props => [
    totalHabits,
    completedToday,
    weeklyCompleted,
    streak,
    completionRate,
  ];
}

