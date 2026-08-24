// lib/data/models/habits/habit_model.dart
import 'package:json_annotation/json_annotation.dart';
import '../../../domain/entities/habit.dart';

part 'habit_model.g.dart';

@JsonSerializable()
class HabitModel {
  final String id;
  final String name;
  final String? description;
  final String cadence;
  final String block;
  final String icon;
  final int color;
  final bool isCompleted;
  final int streak;
  final int? target;
  final int? progress;  // ← Added to match generated code
  final DateTime createdAt;
  final DateTime? updatedAt;

  HabitModel({
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
    this.progress,  // ← Added
    required this.createdAt,
    this.updatedAt,
  });

  factory HabitModel.fromJson(Map<String, dynamic> json) =>
      _$HabitModelFromJson(json);

  Map<String, dynamic> toJson() => _$HabitModelToJson(this);

  Habit toDomain() {
    return Habit(
      id: id,
      name: name,
      description: description,
      cadence: _stringToCadence(cadence),
      block: _stringToBlock(block),
      icon: icon,
      color: color,
      isCompleted: isCompleted,
      streak: streak,
      target: target,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  factory HabitModel.fromDomain(Habit habit) {
    return HabitModel(
      id: habit.id,
      name: habit.name,
      description: habit.description,
      cadence: habit.cadence.toString().split('.').last,
      block: habit.block.toString().split('.').last,
      icon: habit.icon,
      color: habit.color,
      isCompleted: habit.isCompleted,
      streak: habit.streak,
      target: habit.target,
      progress: habit.target, // Or calculate based on progress
      createdAt: habit.createdAt,
      updatedAt: habit.updatedAt,
    );
  }

  static HabitCadence _stringToCadence(String value) {
    switch (value) {
      case 'daily':
        return HabitCadence.daily;
      case 'weekly':
        return HabitCadence.weekly;
      default:
        return HabitCadence.daily;
    }
  }

  static HabitTimeBlock _stringToBlock(String value) {
    switch (value) {
      case 'morning':
        return HabitTimeBlock.morning;
      case 'afternoon':
        return HabitTimeBlock.afternoon;
      case 'evening':
        return HabitTimeBlock.evening;
      default:
        return HabitTimeBlock.morning;
    }
  }
}
