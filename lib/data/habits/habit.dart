// lib/data/habits/habit.dart
import 'package:flutter/material.dart';

enum HabitCadence {
  daily,
  weekly,
}

enum HabitTimeBlock {
  morning,
  afternoon,
  evening,
}

extension HabitTimeBlockExtension on HabitTimeBlock {
  String get label {
    switch (this) {
      case HabitTimeBlock.morning:
        return 'Morning';
      case HabitTimeBlock.afternoon:
        return 'Afternoon';
      case HabitTimeBlock.evening:
        return 'Evening';
    }
  }

  IconData get icon {
    switch (this) {
      case HabitTimeBlock.morning:
        return Icons.wb_sunny;
      case HabitTimeBlock.afternoon:
        return Icons.sunny;
      case HabitTimeBlock.evening:
        return Icons.nightlight_round;
    }
  }
}

extension HabitCadenceExtension on HabitCadence {
  String get label {
    switch (this) {
      case HabitCadence.daily:
        return 'Daily';
      case HabitCadence.weekly:
        return 'Weekly';
    }
  }
}

class Habit {
  final String id;
  final String name;
  final String? description;
  final HabitCadence cadence;
  final HabitTimeBlock block;
  final IconData icon;
  final Color color;
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
    IconData? icon,
    Color? color,
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

  factory Habit.fromJson(Map<String, dynamic> json) {
    return Habit(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      cadence: HabitCadence.values.firstWhere(
            (e) => e.toString() == json['cadence'],
      ),
      block: HabitTimeBlock.values.firstWhere(
            (e) => e.toString() == json['block'],
      ),
      icon: IconData(
        json['iconCodePoint'],
        fontFamily: 'MaterialIcons',
      ),
      color: Color(json['color']),
      isCompleted: json['isCompleted'] ?? false,
      streak: json['streak'] ?? 0,
      target: json['target'],
      progress: json['progress'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'cadence': cadence.toString(),
      'block': block.toString(),
      'iconCodePoint': icon.codePoint,
      'color': color.value,
      'isCompleted': isCompleted,
      'streak': streak,
      'target': target,
      'progress': progress,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }
}

