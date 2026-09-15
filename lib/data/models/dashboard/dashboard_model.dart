// lib/data/models/dashboard/dashboard_model.dart
import 'package:json_annotation/json_annotation.dart';
import '../../../domain/entities/dashboard_entity.dart';

part 'dashboard_model.g.dart';

@JsonSerializable()
class DashboardModel {
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
  final List<DashboardHabitModel> todayHabits;
  final List<DashboardWeekDayModel> weekData;
  final String weekRange;

  DashboardModel({
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

  factory DashboardModel.fromJson(Map<String, dynamic> json) =>
      _$DashboardModelFromJson(json);

  Map<String, dynamic> toJson() => _$DashboardModelToJson(this);

  DashboardEntity toDomain() {
    return DashboardEntity(
      userName: userName,
      greeting: greeting,
      date: date,
      dayOfWeek: dayOfWeek,
      completedToday: completedToday,
      totalToday: totalToday,
      weeklyCompleted: weeklyCompleted,
      totalWeekly: totalWeekly,
      streak: streak,
      insight: insight,
      todayHabits: todayHabits.map((h) => h.toDomain()).toList(),
      weekData: weekData.map((w) => w.toDomain()).toList(),
      weekRange: weekRange,
    );
  }

  factory DashboardModel.fromDomain(DashboardEntity entity) {
    return DashboardModel(
      userName: entity.userName,
      greeting: entity.greeting,
      date: entity.date,
      dayOfWeek: entity.dayOfWeek,
      completedToday: entity.completedToday,
      totalToday: entity.totalToday,
      weeklyCompleted: entity.weeklyCompleted,
      totalWeekly: entity.totalWeekly,
      streak: entity.streak,
      insight: entity.insight,
      todayHabits: entity.todayHabits.map((h) => DashboardHabitModel.fromDomain(h)).toList(),
      weekData: entity.weekData.map((w) => DashboardWeekDayModel.fromDomain(w)).toList(),
      weekRange: entity.weekRange,
    );
  }

  static DashboardModel sample() {
    return DashboardModel(
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
        const DashboardHabitModel(
          id: '1',
          name: 'Evening run',
          streak: 3,
          isCompleted: false,
          iconName: 'directions_run',
        ),
        const DashboardHabitModel(
          id: '2',
          name: 'Yoga',
          streak: 5,
          isCompleted: false,
          iconName: 'self_improvement',
        ),
        const DashboardHabitModel(
          id: '3',
          name: 'Deep work',
          streak: 2,
          isCompleted: false,
          iconName: 'work',
        ),
      ],
      weekData: [
        const DashboardWeekDayModel(label: 'MON', state: 'complete', done: 9, total: 9),
        const DashboardWeekDayModel(label: 'TUE', state: 'today', done: 0, total: 9),
        const DashboardWeekDayModel(label: 'WED', state: 'upcoming', done: 0, total: 9),
        const DashboardWeekDayModel(label: 'THU', state: 'upcoming', done: 0, total: 9),
        const DashboardWeekDayModel(label: 'FRI', state: 'upcoming', done: 0, total: 9),
        const DashboardWeekDayModel(label: 'SAT', state: 'upcoming', done: 0, total: 7),
        const DashboardWeekDayModel(label: 'SUN', state: 'upcoming', done: 0, total: 5),
      ],
      weekRange: 'Jul 27–Aug 2',
    );
  }
}

@JsonSerializable()
class DashboardHabitModel {
  final String id;
  final String name;
  final int streak;
  final bool isCompleted;
  final String iconName;

  const DashboardHabitModel({
    required this.id,
    required this.name,
    required this.streak,
    required this.isCompleted,
    required this.iconName,
  });

  factory DashboardHabitModel.fromJson(Map<String, dynamic> json) =>
      _$DashboardHabitModelFromJson(json);

  Map<String, dynamic> toJson() => _$DashboardHabitModelToJson(this);

  DashboardHabitEntity toDomain() {
    return DashboardHabitEntity(
      id: id,
      name: name,
      streak: streak,
      isCompleted: isCompleted,
      iconName: iconName,
    );
  }

  factory DashboardHabitModel.fromDomain(DashboardHabitEntity entity) {
    return DashboardHabitModel(
      id: entity.id,
      name: entity.name,
      streak: entity.streak,
      isCompleted: entity.isCompleted,
      iconName: entity.iconName,
    );
  }
}

@JsonSerializable()
class DashboardWeekDayModel {
  final String label;
  final String state;
  final int done;
  final int total;

  const DashboardWeekDayModel({
    required this.label,
    required this.state,
    required this.done,
    required this.total,
  });

  factory DashboardWeekDayModel.fromJson(Map<String, dynamic> json) =>
      _$DashboardWeekDayModelFromJson(json);

  Map<String, dynamic> toJson() => _$DashboardWeekDayModelToJson(this);

  DashboardWeekDayEntity toDomain() {
    return DashboardWeekDayEntity(
      label: label,
      state: state,
      done: done,
      total: total,
    );
  }

  factory DashboardWeekDayModel.fromDomain(DashboardWeekDayEntity entity) {
    return DashboardWeekDayModel(
      label: entity.label,
      state: entity.state,
      done: entity.done,
      total: entity.total,
    );
  }
}

