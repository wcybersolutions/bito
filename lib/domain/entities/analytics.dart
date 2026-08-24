// lib/domain/entities/analytics.dart
import 'package:equatable/equatable.dart';

class AnalyticsData extends Equatable {
  final AnalyticsStats stats;
  final List<DailyPerformance> dailyPerformance;
  final List<HabitStreak> streaks;
  final AISignal aiSignal;
  final List<AnalyticsPattern> patterns;
  final List<AnalyticsTrend> trends;
  final List<AnalyticsCorrelation> correlations;
  final List<AnalyticsRecommendation> recommendations;

  const AnalyticsData({
    required this.stats,
    required this.dailyPerformance,
    required this.streaks,
    required this.aiSignal,
    required this.patterns,
    required this.trends,
    required this.correlations,
    required this.recommendations,
  });

  @override
  List<Object?> get props => [
    stats,
    dailyPerformance,
    streaks,
    aiSignal,
    patterns,
    trends,
    correlations,
    recommendations,
  ];
}

class AnalyticsStats extends Equatable {
  final int activeHabits;
  final int completions;
  final String bestStreak;
  final String weeklyGoals;
  final double averageCompletion;

  const AnalyticsStats({
    required this.activeHabits,
    required this.completions,
    required this.bestStreak,
    required this.weeklyGoals,
    required this.averageCompletion,
  });

  @override
  List<Object?> get props => [
    activeHabits,
    completions,
    bestStreak,
    weeklyGoals,
    averageCompletion,
  ];
}

class DailyPerformance extends Equatable {
  final String date;
  final int completed;
  final int total;

  const DailyPerformance({
    required this.date,
    required this.completed,
    required this.total,
  });

  double get percentage => total > 0 ? (completed / total) * 100 : 0;

  @override
  List<Object?> get props => [date, completed, total];
}

class HabitStreak extends Equatable {
  final String id;
  final String name;
  final String value;
  final bool isComplete;
  final int currentStreak;

  const HabitStreak({
    required this.id,
    required this.name,
    required this.value,
    this.isComplete = false,
    this.currentStreak = 0,
  });

  @override
  List<Object?> get props => [id, name, value, isComplete, currentStreak];
}

class AISignal extends Equatable {
  final String briefing;
  final List<String> questions;

  const AISignal({
    required this.briefing,
    required this.questions,
  });

  @override
  List<Object?> get props => [briefing, questions];
}

class AnalyticsPattern extends Equatable {
  final String title;
  final String description;
  final bool isStable;

  const AnalyticsPattern({
    required this.title,
    required this.description,
    this.isStable = false,
  });

  @override
  List<Object?> get props => [title, description, isStable];
}

class AnalyticsTrend extends Equatable {
  final String title;
  final String description;
  final String badge;

  const AnalyticsTrend({
    required this.title,
    required this.description,
    required this.badge,
  });

  @override
  List<Object?> get props => [title, description, badge];
}

class AnalyticsCorrelation extends Equatable {
  final String title;
  final String description;

  const AnalyticsCorrelation({
    required this.title,
    required this.description,
  });

  @override
  List<Object?> get props => [title, description];
}

class AnalyticsRecommendation extends Equatable {
  final String title;
  final String description;
  final String priority;

  const AnalyticsRecommendation({
    required this.title,
    required this.description,
    required this.priority,
  });

  @override
  List<Object?> get props => [title, description, priority];
}

