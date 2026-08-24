// lib/data/datasources/remote/habit_remote_datasource.dart
import '../../../core/constants/api_constants.dart';
import '../../../core/network/api_client.dart';
import '../../models/habits/habit_model.dart';
import '../../models/habits/habit_stats_model.dart';

class HabitRemoteDataSource {
  final ApiClient _apiClient;

  HabitRemoteDataSource(this._apiClient);

  // GET /api/habits
  Future<List<HabitModel>> getHabits() async {
    final response = await _apiClient.get(ApiConstants.habits);
    final data = response.data['data'] as List? ?? [];
    return data.map((json) => HabitModel.fromJson(json)).toList();
  }

  // GET /api/habits/:id
  Future<HabitModel> getHabit(String id) async {
    final url = ApiConstants.replaceParam(ApiConstants.habitsId, 'id', id);
    final response = await _apiClient.get(url);
    return HabitModel.fromJson(response.data['data']);
  }

  // POST /api/habits
  Future<HabitModel> createHabit(Map<String, dynamic> params) async {
    final response = await _apiClient.post(
      ApiConstants.habits,
      data: params,
    );
    return HabitModel.fromJson(response.data['data']);
  }

  // PUT /api/habits/:id
  Future<HabitModel> updateHabit(String id, Map<String, dynamic> params) async {
    final url = ApiConstants.replaceParam(ApiConstants.habitsId, 'id', id);
    final response = await _apiClient.put(
      url,
      data: params,
    );
    return HabitModel.fromJson(response.data['data']);
  }

  // DELETE /api/habits/:id
  Future<void> deleteHabit(String id) async {
    final url = ApiConstants.replaceParam(ApiConstants.habitsId, 'id', id);
    await _apiClient.delete(url);
  }

  // POST /api/habits/:id/check
  Future<HabitModel> toggleHabit(String id) async {
    final url = ApiConstants.replaceParam(ApiConstants.habitsCheck, 'id', id);
    final response = await _apiClient.post(url);
    return HabitModel.fromJson(response.data['data']);
  }

  // GET /api/habits/stats
  Future<HabitStatsModel> getStats() async {
    final response = await _apiClient.get(ApiConstants.habitsStats);
    return HabitStatsModel.fromJson(response.data['data']);
  }
}

