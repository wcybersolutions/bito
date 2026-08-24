// lib/data/providers/analytics_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/providers/core_providers.dart';  // ← Add this for apiClientProvider
import '../../domain/entities/analytics.dart';
import '../../domain/repositories/i_analytics_repository.dart';
import '../datasources/remote/analytics_remote_datasource.dart';
import '../repositories/analytics_repository.dart';

// ============================================================
// Data Source
// ============================================================
final analyticsRemoteDataSourceProvider = Provider<AnalyticsRemoteDataSource>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return AnalyticsRemoteDataSource(apiClient);
});

// ============================================================
// Repository - FIXED: Pass the remote data source
// ============================================================
final analyticsRepositoryProvider = Provider<IAnalyticsRepository>((ref) {
  final remoteDataSource = ref.watch(analyticsRemoteDataSourceProvider);
  return AnalyticsRepository(remoteDataSource);  // ← Now passes the required parameter
});

// ============================================================
// State Providers
// ============================================================
final analyticsDataProvider = FutureProvider.family<AnalyticsData, String>((ref, timeframe) async {
  final repository = ref.watch(analyticsRepositoryProvider);
  return repository.getAnalyticsData(timeframe: timeframe);
});

final analyticsStatsProvider = FutureProvider.family<AnalyticsStats, String>((ref, timeframe) async {
  final data = await ref.watch(analyticsDataProvider(timeframe).future);
  return data.stats;
});

final dailyPerformanceProvider = FutureProvider.family<List<DailyPerformance>, String>((ref, timeframe) async {
  final data = await ref.watch(analyticsDataProvider(timeframe).future);
  return data.dailyPerformance;
});

final streaksProvider = FutureProvider.family<List<HabitStreak>, String>((ref, timeframe) async {
  final data = await ref.watch(analyticsDataProvider(timeframe).future);
  return data.streaks;
});

final aiSignalProvider = FutureProvider.family<AISignal, String>((ref, timeframe) async {
  final data = await ref.watch(analyticsDataProvider(timeframe).future);
  return data.aiSignal;
});

final patternsProvider = FutureProvider.family<List<AnalyticsPattern>, String>((ref, timeframe) async {
  final data = await ref.watch(analyticsDataProvider(timeframe).future);
  return data.patterns;
});

final trendsProvider = FutureProvider.family<List<AnalyticsTrend>, String>((ref, timeframe) async {
  final data = await ref.watch(analyticsDataProvider(timeframe).future);
  return data.trends;
});

final correlationsProvider = FutureProvider.family<List<AnalyticsCorrelation>, String>((ref, timeframe) async {
  final data = await ref.watch(analyticsDataProvider(timeframe).future);
  return data.correlations;
});

final recommendationsProvider = FutureProvider.family<List<AnalyticsRecommendation>, String>((ref, timeframe) async {
  final data = await ref.watch(analyticsDataProvider(timeframe).future);
  return data.recommendations;
});

