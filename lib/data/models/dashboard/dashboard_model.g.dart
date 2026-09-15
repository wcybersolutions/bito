// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dashboard_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DashboardModel _$DashboardModelFromJson(Map<String, dynamic> json) =>
    DashboardModel(
      userName: json['userName'] as String,
      greeting: json['greeting'] as String,
      date: json['date'] as String,
      dayOfWeek: json['dayOfWeek'] as String,
      completedToday: (json['completedToday'] as num).toInt(),
      totalToday: (json['totalToday'] as num).toInt(),
      weeklyCompleted: (json['weeklyCompleted'] as num).toInt(),
      totalWeekly: (json['totalWeekly'] as num).toInt(),
      streak: (json['streak'] as num).toInt(),
      insight: json['insight'] as String,
      todayHabits: (json['todayHabits'] as List<dynamic>)
          .map((e) => DashboardHabitModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      weekData: (json['weekData'] as List<dynamic>)
          .map((e) => DashboardWeekDayModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      weekRange: json['weekRange'] as String,
    );

Map<String, dynamic> _$DashboardModelToJson(DashboardModel instance) =>
    <String, dynamic>{
      'userName': instance.userName,
      'greeting': instance.greeting,
      'date': instance.date,
      'dayOfWeek': instance.dayOfWeek,
      'completedToday': instance.completedToday,
      'totalToday': instance.totalToday,
      'weeklyCompleted': instance.weeklyCompleted,
      'totalWeekly': instance.totalWeekly,
      'streak': instance.streak,
      'insight': instance.insight,
      'todayHabits': instance.todayHabits,
      'weekData': instance.weekData,
      'weekRange': instance.weekRange,
    };

DashboardHabitModel _$DashboardHabitModelFromJson(Map<String, dynamic> json) =>
    DashboardHabitModel(
      id: json['id'] as String,
      name: json['name'] as String,
      streak: (json['streak'] as num).toInt(),
      isCompleted: json['isCompleted'] as bool,
      iconName: json['iconName'] as String,
    );

Map<String, dynamic> _$DashboardHabitModelToJson(
        DashboardHabitModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'streak': instance.streak,
      'isCompleted': instance.isCompleted,
      'iconName': instance.iconName,
    };

DashboardWeekDayModel _$DashboardWeekDayModelFromJson(
        Map<String, dynamic> json) =>
    DashboardWeekDayModel(
      label: json['label'] as String,
      state: json['state'] as String,
      done: (json['done'] as num).toInt(),
      total: (json['total'] as num).toInt(),
    );

Map<String, dynamic> _$DashboardWeekDayModelToJson(
        DashboardWeekDayModel instance) =>
    <String, dynamic>{
      'label': instance.label,
      'state': instance.state,
      'done': instance.done,
      'total': instance.total,
    };
