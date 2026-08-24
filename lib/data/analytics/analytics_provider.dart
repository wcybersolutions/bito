import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'analytics_data.dart';
import 'analytics_repository.dart';

// Repository provider
final analyticsRepositoryProvider = Provider<AnalyticsRepository>((ref) {
  return AnalyticsRepository();
});

// Main analytics data provider
final analyticsDataProvider = FutureProvider<AnalyticsData>((ref) async {
  final repository = ref.read(analyticsRepositoryProvider);
  return repository.getAnalyticsData();
});

// Refreshable analytics data provider
final refreshAnalyticsProvider = FutureProvider<AnalyticsData>((ref) async {
  final repository = ref.read(analyticsRepositoryProvider);
  return repository.refreshAnalyticsData();
});

// Individual data providers for specific sections
final analyticsStatsProvider = FutureProvider<AnalyticsStats>((ref) async {
  final data = await ref.watch(analyticsDataProvider.future);
  return data.stats;
});

final dailyPerformanceProvider = FutureProvider<List<DailyPerformance>>((ref) async {
  final data = await ref.watch(analyticsDataProvider.future);
  return data.dailyPerformance;
});

final streaksProvider = FutureProvider<List<HabitStreak>>((ref) async {
  final data = await ref.watch(analyticsDataProvider.future);
  return data.streaks;
});

final aiSignalProvider = FutureProvider<AISignal>((ref) async {
  final data = await ref.watch(analyticsDataProvider.future);
  return data.aiSignal;
});

final patternsProvider = FutureProvider<List<AnalyticsPattern>>((ref) async {
  final data = await ref.watch(analyticsDataProvider.future);
  return data.patterns;
});

final trendsProvider = FutureProvider<List<AnalyticsTrend>>((ref) async {
  final data = await ref.watch(analyticsDataProvider.future);
  return data.trends;
});

final correlationsProvider = FutureProvider<List<AnalyticsCorrelation>>((ref) async {
  final data = await ref.watch(analyticsDataProvider.future);
  return data.correlations;
});

final recommendationsProvider = FutureProvider<List<AnalyticsRecommendation>>((ref) async {
  final data = await ref.watch(analyticsDataProvider.future);
  return data.recommendations;
});

