// lib/data/dashboard/dashboard_summary.dart
import 'package:flutter/material.dart';

class DashboardSummary {
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
  final List<DashboardHabit> todayHabits;
  final List<DashboardWeekDay> weekData;
  final String weekRange;

  const DashboardSummary({
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

  factory DashboardSummary.sample() {
    return DashboardSummary(
      userName: 'John',
      greeting: 'Good morning',
      date: 'JULY 30',
      dayOfWeek: 'THURSDAY',
      completedToday: 0,
      totalToday: 7,
      weeklyCompleted: 0,
      totalWeekly: 2,
      streak: 12,
      insight: 'You have nine daily habits with an average completion rate of 33%. "Easy Morning Run" leads with a 78% completion rate, while "Evening run" is at the lowest with just 3%. Over the last three tracked days, you achieved 100% completion each day, including a full set of eight or more habits completed daily. Sundays stand out as your most productive day, with all habits completed, and mornings.',
      todayHabits: [
        const DashboardHabit(
          id: '1',
          name: 'Evening run',
          streak: 3,
          isCompleted: false,
          icon: Icons.directions_run,
        ),
        const DashboardHabit(
          id: '2',
          name: 'Yoga',
          streak: 5,
          isCompleted: false,
          icon: Icons.self_improvement,
        ),
        const DashboardHabit(
          id: '3',
          name: 'Deep work',
          streak: 2,
          isCompleted: false,
          icon: Icons.work,
        ),
      ],
      weekData: [
        const DashboardWeekDay(label: 'MON', state: 'complete', done: 9, total: 9),
        const DashboardWeekDay(label: 'TUE', state: 'today', done: 0, total: 9),
        const DashboardWeekDay(label: 'WED', state: 'upcoming', done: 0, total: 9),
        const DashboardWeekDay(label: 'THU', state: 'upcoming', done: 0, total: 9),
        const DashboardWeekDay(label: 'FRI', state: 'upcoming', done: 0, total: 9),
        const DashboardWeekDay(label: 'SAT', state: 'upcoming', done: 0, total: 7),
        const DashboardWeekDay(label: 'SUN', state: 'upcoming', done: 0, total: 5),
      ],
      weekRange: 'Jul 27–Aug 2',
    );
  }
}

class DashboardHabit {
  final String id;
  final String name;
  final int streak;
  final bool isCompleted;
  final IconData icon;

  const DashboardHabit({
    required this.id,
    required this.name,
    required this.streak,
    required this.isCompleted,
    required this.icon,
  });

  DashboardHabit copyWith({
    String? id,
    String? name,
    int? streak,
    bool? isCompleted,
    IconData? icon,
  }) {
    return DashboardHabit(
      id: id ?? this.id,
      name: name ?? this.name,
      streak: streak ?? this.streak,
      isCompleted: isCompleted ?? this.isCompleted,
      icon: icon ?? this.icon,
    );
  }
}

class DashboardWeekDay {
  final String label;
  final String state;
  final int done;
  final int total;

  const DashboardWeekDay({
    required this.label,
    required this.state,
    required this.done,
    required this.total,
  });
}

