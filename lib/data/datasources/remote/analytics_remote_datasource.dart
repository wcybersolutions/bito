// lib/data/datasources/remote/analytics_remote_datasource.dart
import '../../../core/constants/api_constants.dart';
import '../../../core/network/api_client.dart';

class AnalyticsRemoteDataSource {
  final ApiClient _apiClient;

  AnalyticsRemoteDataSource(this._apiClient);

  Future<Map<String, dynamic>> getAnalyticsData(String timeframe) async {
    final response = await _apiClient.get(
      ApiConstants.insightsAnalytics,
      queryParameters: {'timeframe': timeframe},
    );
    return response.data;
  }

  Future<Map<String, dynamic>> getInsights() async {
    final response = await _apiClient.get(ApiConstants.insights);
    return response.data;
  }

  Future<Map<String, dynamic>> queryInsights(Map<String, dynamic> query) async {
    final response = await _apiClient.post(
      ApiConstants.insightsQuery,
      data: query,
    );
    return response.data;
  }

  Future<void> dismissInsight(String insightId) async {
    await _apiClient.post(
      '${ApiConstants.insights}/$insightId/dismiss',
    );
  }
}
