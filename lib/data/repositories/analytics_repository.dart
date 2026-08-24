// lib/data/repositories/analytics_repository.dart
import '../../domain/entities/analytics.dart';
import '../../domain/repositories/i_analytics_repository.dart';
import '../datasources/remote/analytics_remote_datasource.dart';

class AnalyticsRepository implements IAnalyticsRepository {
  final AnalyticsRemoteDataSource _remoteDataSource;

  AnalyticsRepository(this._remoteDataSource);

  @override
  Future<AnalyticsData> getAnalyticsData({String timeframe = '7D'}) async {
    try {
      final data = await _remoteDataSource.getAnalyticsData(timeframe);
      return _mapToDomain(data);
    } catch (e) {
      // Return mock data if API is not available yet
      return _getMockData();
    }
  }

  @override
  Future<AnalyticsData> refreshAnalyticsData({String timeframe = '7D'}) async {
    try {
      final data = await _remoteDataSource.getAnalyticsData(timeframe);
      return _mapToDomain(data);
    } catch (e) {
      return _getMockData();
    }
  }

  AnalyticsData _mapToDomain(Map<String, dynamic> data) {
    // This will map API response to domain entities
    // For now, return mock data
    return _getMockData();
  }

  AnalyticsData _getMockData() {
    return AnalyticsData(
      stats: AnalyticsStats(
        activeHabits: 6,
        completions: 17,
        bestStreak: '7d',
        weeklyGoals: '1/4w',
        averageCompletion: 48.0,
      ),
      dailyPerformance: [
        const DailyPerformance(date: 'Aug 10', completed: 4, total: 6),
        const DailyPerformance(date: 'Aug 11', completed: 6, total: 6),
        const DailyPerformance(date: 'Aug 12', completed: 0, total: 6),
        const DailyPerformance(date: 'Aug 13', completed: 5, total: 6),
        const DailyPerformance(date: 'Aug 14', completed: 3, total: 6),
        const DailyPerformance(date: 'Aug 15', completed: 6, total: 6),
        const DailyPerformance(date: 'Aug 16', completed: 4, total: 6),
        const DailyPerformance(date: 'Aug 17', completed: 5, total: 6),
      ],
      streaks: [
        const HabitStreak(id: '1', name: 'Morning Walk', value: '100%', isComplete: true, currentStreak: 6),
        const HabitStreak(id: '2', name: 'Cycle for at least 5kms', value: '100%', isComplete: true, currentStreak: 6),
        const HabitStreak(id: '5', name: 'Yoga for 30 minutes', value: '100%', isComplete: true, currentStreak: 5),
        const HabitStreak(id: '6', name: 'Journal for 5 minutes', value: '100%', isComplete: true, currentStreak: 4),
        const HabitStreak(id: '7', name: 'Read 20 pages before bed', value: '67%', isComplete: false, currentStreak: 3),
        const HabitStreak(id: '3', name: 'Strength basics', value: '1/2w', isComplete: false, currentStreak: 2),
        const HabitStreak(id: '4', name: 'Meditate for 5 minutes', value: '50%', isComplete: false, currentStreak: 1),
      ],
      aiSignal: AISignal(
        briefing: 'The user maintains a 91% habit completion rate, with strong consistency in fitness, productivity, and mindfulness.',
        questions: [
          'Why does my consistency drop on week',
          'Which habit is hurting my consistency?',
          'My strongest trend this period?',
          'One adjustment to improve next week?',
        ],
      ),
      patterns: [
        const AnalyticsPattern(
          title: 'Consistent morning fitness routine',
          description: 'The user consistently completes morning runs, especially early in the week.',
        ),
        const AnalyticsPattern(
          title: 'Stable high weekly completion rate',
          description: 'The weekly completion rate is 50% for the tracked week.',
          isStable: true,
        ),
      ],
      trends: [
        const AnalyticsTrend(
          title: 'Stable high weekly completion rate',
          description: 'The weekly completion rate is 95% for the tracked week.',
          badge: 'Stable',
        ),
      ],
      correlations: [
        const AnalyticsCorrelation(
          title: 'Morning productivity and habit completion',
          description: 'The user\'s preference for morning hours coincides with habit completions.',
        ),
      ],
      recommendations: [
        const AnalyticsRecommendation(
          title: 'Increase Tracking Frequency',
          description: 'Expand habit tracking to cover more days in the week.',
          priority: 'High',
        ),
        const AnalyticsRecommendation(
          title: 'Diversify Habit Timing',
          description: 'Consider spreading some habits into afternoon or evening.',
          priority: 'Medium',
        ),
      ],
    );
  }
}

