// lib/domain/repositories/i_analytics_repository.dart
import '../entities/analytics.dart';

abstract class IAnalyticsRepository {
  Future<AnalyticsData> getAnalyticsData({String timeframe = '7D'});
  Future<AnalyticsData> refreshAnalyticsData({String timeframe = '7D'});
}

