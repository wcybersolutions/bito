// lib/data/models/habits/habit_stats_model.dart
import 'package:json_annotation/json_annotation.dart';
import '../../../domain/entities/habit.dart';

part 'habit_stats_model.g.dart';

@JsonSerializable()
class HabitStatsModel {
  final int totalHabits;
  final int completedToday;
  final int weeklyCompleted;
  final int streak;
  final double completionRate;

  HabitStatsModel({
    required this.totalHabits,
    required this.completedToday,
    required this.weeklyCompleted,
    required this.streak,
    required this.completionRate,
  });

  factory HabitStatsModel.fromJson(Map<String, dynamic> json) => _$HabitStatsModelFromJson(json);
  Map<String, dynamic> toJson() => _$HabitStatsModelToJson(this);

  HabitStats toDomain() {
    return HabitStats(
      totalHabits: totalHabits,
      completedToday: completedToday,
      weeklyCompleted: weeklyCompleted,
      streak: streak,
      completionRate: completionRate,
    );
  }

  factory HabitStatsModel.fromDomain(HabitStats stats) {
    return HabitStatsModel(
      totalHabits: stats.totalHabits,
      completedToday: stats.completedToday,
      weeklyCompleted: stats.weeklyCompleted,
      streak: stats.streak,
      completionRate: stats.completionRate,
    );
  }
}

