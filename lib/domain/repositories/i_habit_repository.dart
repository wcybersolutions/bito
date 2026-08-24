// lib/domain/repositories/i_habit_repository.dart
import '../entities/habit.dart';

class CreateHabitParams {
  final String name;
  final String? description;
  final HabitCadence cadence;
  final HabitTimeBlock block;
  final String icon;
  final int color;
  final int? target;

  CreateHabitParams({
    required this.name,
    this.description,
    required this.cadence,
    required this.block,
    required this.icon,
    required this.color,
    this.target,
  });

  Map<String, dynamic> toJson() => {
    'name': name,
    'description': description,
    'cadence': cadence.toString().split('.').last,
    'block': block.toString().split('.').last,
    'icon': icon,
    'color': color,
    'target': target,
  };
}

class UpdateHabitParams {
  final String? name;
  final String? description;
  final HabitCadence? cadence;
  final HabitTimeBlock? block;
  final String? icon;
  final int? color;
  final int? target;

  UpdateHabitParams({
    this.name,
    this.description,
    this.cadence,
    this.block,
    this.icon,
    this.color,
    this.target,
  });

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (name != null) map['name'] = name;
    if (description != null) map['description'] = description;
    if (cadence != null) map['cadence'] = cadence.toString().split('.').last;
    if (block != null) map['block'] = block.toString().split('.').last;
    if (icon != null) map['icon'] = icon;
    if (color != null) map['color'] = color;
    if (target != null) map['target'] = target;
    return map;
  }
}

abstract class IHabitRepository {
  Future<List<Habit>> getHabits();
  Future<Habit> getHabit(String id);
  Future<Habit> createHabit(CreateHabitParams params);
  Future<Habit> updateHabit(String id, UpdateHabitParams params);
  Future<void> deleteHabit(String id);
  Future<Habit> toggleHabit(String id);
  Future<HabitStats> getStats();
  Future<List<Habit>> getHabitsByBlock(HabitTimeBlock block);
  Future<List<Habit>> getDailyHabits();
  Future<List<Habit>> getWeeklyHabits();
}
