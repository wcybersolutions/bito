// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'habit_stats_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HabitStatsModel _$HabitStatsModelFromJson(Map<String, dynamic> json) =>
    HabitStatsModel(
      totalHabits: (json['totalHabits'] as num).toInt(),
      completedToday: (json['completedToday'] as num).toInt(),
      weeklyCompleted: (json['weeklyCompleted'] as num).toInt(),
      streak: (json['streak'] as num).toInt(),
      completionRate: (json['completionRate'] as num).toDouble(),
    );

Map<String, dynamic> _$HabitStatsModelToJson(HabitStatsModel instance) =>
    <String, dynamic>{
      'totalHabits': instance.totalHabits,
      'completedToday': instance.completedToday,
      'weeklyCompleted': instance.weeklyCompleted,
      'streak': instance.streak,
      'completionRate': instance.completionRate,
    };
