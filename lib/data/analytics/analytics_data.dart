// Daily performance data model
class DailyPerformance {
  final String date;
  final int completed;
  final int total;

  DailyPerformance({
    required this.date,
    required this.completed,
    required this.total,
  });

  double get percentage => total > 0 ? (completed / total) * 100 : 0;

  factory DailyPerformance.fromJson(Map<String, dynamic> json) {
    return DailyPerformance(
      date: json['date'],
      completed: json['completed'],
      total: json['total'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'date': date, 'completed': completed, 'total': total};
  }
}

// Streak data model
class HabitStreak {
  final String id;
  final String name;
  final String value;
  final bool isComplete;
  final int currentStreak;

  HabitStreak({
    required this.id,
    required this.name,
    required this.value,
    this.isComplete = false,
    this.currentStreak = 0,
  });

  factory HabitStreak.fromJson(Map<String, dynamic> json) {
    return HabitStreak(
      id: json['id'],
      name: json['name'],
      value: json['value'],
      isComplete: json['isComplete'] ?? false,
      currentStreak: json['currentStreak'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'value': value,
      'isComplete': isComplete,
      'currentStreak': currentStreak,
    };
  }
}

// Stats summary model
class AnalyticsStats {
  final int activeHabits;
  final int completions;
  final String bestStreak;
  final String weeklyGoals;
  final double averageCompletion;

  AnalyticsStats({
    required this.activeHabits,
    required this.completions,
    required this.bestStreak,
    required this.weeklyGoals,
    required this.averageCompletion,
  });

  factory AnalyticsStats.fromJson(Map<String, dynamic> json) {
    return AnalyticsStats(
      activeHabits: json['activeHabits'] ?? 0,
      completions: json['completions'] ?? 0,
      bestStreak: json['bestStreak'] ?? '0d',
      weeklyGoals: json['weeklyGoals'] ?? '0/0w',
      averageCompletion: json['averageCompletion']?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'activeHabits': activeHabits,
      'completions': completions,
      'bestStreak': bestStreak,
      'weeklyGoals': weeklyGoals,
      'averageCompletion': averageCompletion,
    };
  }
}

// AI Signal model
class AISignal {
  final String briefing;
  final List<String> questions;

  AISignal({required this.briefing, required this.questions});

  factory AISignal.fromJson(Map<String, dynamic> json) {
    return AISignal(
      briefing: json['briefing'] ?? '',
      questions: List<String>.from(json['questions'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {'briefing': briefing, 'questions': questions};
  }
}

// Pattern model
class AnalyticsPattern {
  final String title;
  final String description;
  final bool isStable;

  AnalyticsPattern({
    required this.title,
    required this.description,
    this.isStable = false,
  });

  factory AnalyticsPattern.fromJson(Map<String, dynamic> json) {
    return AnalyticsPattern(
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      isStable: json['isStable'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {'title': title, 'description': description, 'isStable': isStable};
  }
}

// Trend model
class AnalyticsTrend {
  final String title;
  final String description;
  final String badge;

  AnalyticsTrend({
    required this.title,
    required this.description,
    required this.badge,
  });

  factory AnalyticsTrend.fromJson(Map<String, dynamic> json) {
    return AnalyticsTrend(
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      badge: json['badge'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'title': title, 'description': description, 'badge': badge};
  }
}

// Correlation model
class AnalyticsCorrelation {
  final String title;
  final String description;

  AnalyticsCorrelation({required this.title, required this.description});

  factory AnalyticsCorrelation.fromJson(Map<String, dynamic> json) {
    return AnalyticsCorrelation(
      title: json['title'] ?? '',
      description: json['description'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'title': title, 'description': description};
  }
}

// Recommendation model
class AnalyticsRecommendation {
  final String title;
  final String description;
  final String priority; // 'High', 'Medium', 'Low'

  AnalyticsRecommendation({
    required this.title,
    required this.description,
    required this.priority,
  });

  factory AnalyticsRecommendation.fromJson(Map<String, dynamic> json) {
    return AnalyticsRecommendation(
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      priority: json['priority'] ?? 'Medium',
    );
  }

  Map<String, dynamic> toJson() {
    return {'title': title, 'description': description, 'priority': priority};
  }
}

// Complete analytics data model
class AnalyticsData {
  final AnalyticsStats stats;
  final List<DailyPerformance> dailyPerformance;
  final List<HabitStreak> streaks;
  final AISignal aiSignal;
  final List<AnalyticsPattern> patterns;
  final List<AnalyticsTrend> trends;
  final List<AnalyticsCorrelation> correlations;
  final List<AnalyticsRecommendation> recommendations;

  AnalyticsData({
    required this.stats,
    required this.dailyPerformance,
    required this.streaks,
    required this.aiSignal,
    required this.patterns,
    required this.trends,
    required this.correlations,
    required this.recommendations,
  });

  factory AnalyticsData.fromJson(Map<String, dynamic> json) {
    return AnalyticsData(
      stats: AnalyticsStats.fromJson(json['stats'] ?? {}),
      dailyPerformance: (json['dailyPerformance'] as List? ?? [])
          .map((e) => DailyPerformance.fromJson(e))
          .toList(),
      streaks: (json['streaks'] as List? ?? [])
          .map((e) => HabitStreak.fromJson(e))
          .toList(),
      aiSignal: AISignal.fromJson(json['aiSignal'] ?? {}),
      patterns: (json['patterns'] as List? ?? [])
          .map((e) => AnalyticsPattern.fromJson(e))
          .toList(),
      trends: (json['trends'] as List? ?? [])
          .map((e) => AnalyticsTrend.fromJson(e))
          .toList(),
      correlations: (json['correlations'] as List? ?? [])
          .map((e) => AnalyticsCorrelation.fromJson(e))
          .toList(),
      recommendations: (json['recommendations'] as List? ?? [])
          .map((e) => AnalyticsRecommendation.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'stats': stats.toJson(),
      'dailyPerformance': dailyPerformance.map((e) => e.toJson()).toList(),
      'streaks': streaks.map((e) => e.toJson()).toList(),
      'aiSignal': aiSignal.toJson(),
      'patterns': patterns.map((e) => e.toJson()).toList(),
      'trends': trends.map((e) => e.toJson()).toList(),
      'correlations': correlations.map((e) => e.toJson()).toList(),
      'recommendations': recommendations.map((e) => e.toJson()).toList(),
    };
  }
}
