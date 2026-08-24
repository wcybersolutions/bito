// lib/data/datasources/remote/journal_remote_datasource.dart
import '../../../core/constants/api_constants.dart';
import '../../../core/network/api_client.dart';
import '../../models/journal/journal_entry_model.dart';
import '../../models/journal/journal_stats_model.dart';

class JournalRemoteDataSource {
  final ApiClient _apiClient;

  JournalRemoteDataSource(this._apiClient);

  Future<List<JournalEntryModel>> getEntries() async {
    final response = await _apiClient.get(ApiConstants.journalEntries);
    final data = response.data['data'] as List? ?? [];
    return data.map((json) => JournalEntryModel.fromJson(json)).toList();
  }

  Future<JournalEntryModel> getEntry(String id) async {
    final response = await _apiClient.get('${ApiConstants.journalEntries}/$id');
    return JournalEntryModel.fromJson(response.data['data']);
  }

  Future<JournalEntryModel> createEntry(Map<String, dynamic> params) async {
    final response = await _apiClient.post(
      ApiConstants.journalEntries,
      data: params,
    );
    return JournalEntryModel.fromJson(response.data['data']);
  }

  Future<JournalEntryModel> updateEntry(String id, Map<String, dynamic> params) async {
    final response = await _apiClient.put(
      '${ApiConstants.journalEntries}/$id',
      data: params,
    );
    return JournalEntryModel.fromJson(response.data['data']);
  }

  Future<void> deleteEntry(String id) async {
    await _apiClient.delete('${ApiConstants.journalEntries}/$id');
  }

  Future<JournalStatsModel> getStats() async {
    final response = await _apiClient.get(ApiConstants.journalStats);
    return JournalStatsModel.fromJson(response.data['data']);
  }

  Future<List<JournalEntryModel>> searchEntries(String query) async {
    final response = await _apiClient.get(
      ApiConstants.journalSearch,
      queryParameters: {'q': query},
    );
    final data = response.data['data'] as List? ?? [];
    return data.map((json) => JournalEntryModel.fromJson(json)).toList();
  }
}

