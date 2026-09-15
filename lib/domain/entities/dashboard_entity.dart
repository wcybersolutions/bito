// lib/domain/entities/dashboard_entity.dart
import 'package:equatable/equatable.dart';

class DashboardEntity extends Equatable {
  final String userName;
  final String greeting;
  final String date;
  final String dayOfWeek;
  final int completedToday;
  final int totalToday;
  final int weeklyCompleted;
  final int totalWeekly;
  final int streak;
  final String insight;
  final List<DashboardHabitEntity> todayHabits;
  final List<DashboardWeekDayEntity> weekData;
  final String weekRange;

  const DashboardEntity({
    required this.userName,
    required this.greeting,
    required this.date,
    required this.dayOfWeek,
    required this.completedToday,
    required this.totalToday,
    required this.weeklyCompleted,
    required this.totalWeekly,
    required this.streak,
    required this.insight,
    required this.todayHabits,
    required this.weekData,
    required this.weekRange,
  });

  @override
  List<Object?> get props => [
    userName,
    greeting,
    date,
    dayOfWeek,
    completedToday,
    totalToday,
    weeklyCompleted,
    totalWeekly,
    streak,
    insight,
    todayHabits,
    weekData,
    weekRange,
  ];
}

class DashboardHabitEntity extends Equatable {
  final String id;
  final String name;
  final int streak;
  final bool isCompleted;
  final String iconName;  // Store icon name as string

  const DashboardHabitEntity({
    required this.id,
    required this.name,
    required this.streak,
    required this.isCompleted,
    required this.iconName,
  });

  @override
  List<Object?> get props => [id, name, streak, isCompleted, iconName];
}

class DashboardWeekDayEntity extends Equatable {
  final String label;
  final String state;
  final int done;
  final int total;

  const DashboardWeekDayEntity({
    required this.label,
    required this.state,
    required this.done,
    required this.total,
  });

  @override
  List<Object?> get props => [label, state, done, total];
}

