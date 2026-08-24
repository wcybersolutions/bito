import 'analytics_data.dart';

class AnalyticsRepository {
  static AnalyticsData? _cachedData;

  Future<AnalyticsData> getAnalyticsData() async {
    // Simulate network/database delay
    await Future.delayed(const Duration(milliseconds: 500));

    // Return cached data if available, otherwise generate sample data
    _cachedData ??= _getSampleData();
    return _cachedData!;
  }

  Future<AnalyticsData> refreshAnalyticsData() async {
    // Simulate network/database delay
    await Future.delayed(const Duration(milliseconds: 500));
    _cachedData = _getSampleData();
    return _cachedData!;
  }

  // Sample data - replace with actual API call
  AnalyticsData _getSampleData() {
    return AnalyticsData(
      stats: AnalyticsStats(
        activeHabits: 6,
        completions: 17,
        bestStreak: '7d',
        weeklyGoals: '1/4w',
        averageCompletion: 48.0,
      ),
      dailyPerformance: [
        DailyPerformance(date: 'Aug 10', completed: 4, total: 6),
        DailyPerformance(date: 'Aug 11', completed: 6, total: 6),
        DailyPerformance(date: 'Aug 12', completed: 0, total: 6),
        DailyPerformance(date: 'Aug 13', completed: 5, total: 6),
        DailyPerformance(date: 'Aug 14', completed: 3, total: 6),
        DailyPerformance(date: 'Aug 15', completed: 6, total: 6),
        DailyPerformance(date: 'Aug 16', completed: 4, total: 6),
        DailyPerformance(date: 'Aug 17', completed: 5, total: 6),
      ],
      streaks: [
        HabitStreak(id: '1', name: 'Morning Walk', value: '100%', isComplete: true, currentStreak: 6),
        HabitStreak(id: '2', name: 'Cycle for at least 5kms', value: '100%', isComplete: true, currentStreak: 6),
        HabitStreak(id: '5', name: 'Yoga for 30 minutes', value: '100%', isComplete: true, currentStreak: 5),
        HabitStreak(id: '6', name: 'Journal for 5 minutes', value: '100%', isComplete: true, currentStreak: 4),
        HabitStreak(id: '7', name: 'Read 20 pages before bed', value: '67%', isComplete: false, currentStreak: 3),
        HabitStreak(id: '3', name: 'Strength basics', value: '1/2w', isComplete: false, currentStreak: 2),
        HabitStreak(id: '4', name: 'Meditate for 5 minutes', value: '50%', isComplete: false, currentStreak: 1),
      ],
      aiSignal: AISignal(
        briefing: 'The user maintains a 91% habit completion rate, with strong consistency in fitness, productivity, and mindfulness. Weekly strength training is less consistent, while overall weekly completion reaches 95%.',
        questions: [
          'Why does my consistency drop on week',
          'Which habit is hurting my consistency?',
          'My strongest trend this period?',
          'One adjustment to improve next week?',
        ],
      ),
      patterns: [
        AnalyticsPattern(
          title: 'Consistent morning fitness routine',
          description: 'The user consistently completes morning runs, especially early in the week, achieving a 100% completion rate and reinforcing a strong fitness routine.',
        ),
        AnalyticsPattern(
          title: 'Stable high weekly completion rate',
          description: 'The weekly completion rate is 50% for the tracked week, indicating strong momentum in habit adherence with all 18 targeted completions achieved.',
          isStable: true,
        ),
        AnalyticsPattern(
          title: 'Morning productivity and habit completion',
          description: 'The user\'s preference for morning hours coincides with the majority of habit completions, suggesting that scheduling habits in the morning supports higher adherence.',
        ),
      ],
      trends: [
        AnalyticsTrend(
          title: 'Stable high weekly completion rate',
          description: 'The weekly completion rate is 95% for the tracked week, indicating strong momentum in habit adherence.',
          badge: 'Stable',
        ),
      ],
      correlations: [
        AnalyticsCorrelation(
          title: 'Morning productivity and habit completion',
          description: 'The user\'s preference for morning hours coincides with the majority of habit completions, suggesting that scheduling habits in the morning supports higher adherence.',
        ),
      ],
      recommendations: [
        AnalyticsRecommendation(
          title: 'Increase Tracking Frequency',
          description: 'Expand habit tracking to cover more days in the week to gain a fuller picture of adherence patterns and identify any missed habits on untracked days.',
          priority: 'High',
        ),
        AnalyticsRecommendation(
          title: 'Diversify Habit Timing',
          description: 'Consider spreading some habits into afternoon or evening to test if habit completion can be maintained or improved across different times of day.',
          priority: 'Medium',
        ),
        AnalyticsRecommendation(
          title: 'Monitor \'At Risk\' Habits Despite High Completion',
          description: 'Although all habits show 100% completion, several are flagged as \'at risk\' for mild missing. Review these habits closely to prevent potential drop-offs.',
          priority: 'Medium',
        ),
        AnalyticsRecommendation(
          title: 'Prioritize Strength Basics on Thursdays',
          description: 'The user\'s preference for morning hours coincides with the majority of habit completions, suggesting that scheduling habits in the morning supports higher adherence.',
          priority: 'Medium',
        ),
      ],
    );
  }
}
