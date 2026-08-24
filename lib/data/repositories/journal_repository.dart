// lib/data/repositories/journal_repository.dart
import '../../domain/entities/journal_entry.dart';
import '../../domain/repositories/i_journal_repository.dart';
import '../datasources/remote/journal_remote_datasource.dart';
import '../models/journal/journal_entry_model.dart';
import '../models/journal/journal_stats_model.dart';

class JournalRepository implements IJournalRepository {
  final JournalRemoteDataSource _remoteDataSource;

  JournalRepository(this._remoteDataSource);

  @override
  Future<List<JournalEntry>> getEntries() async {
    try {
      final models = await _remoteDataSource.getEntries();
      return models.map((model) => model.toDomain()).toList();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<JournalEntry> getEntry(String id) async {
    try {
      final model = await _remoteDataSource.getEntry(id);
      return model.toDomain();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<JournalEntry> createEntry(CreateJournalEntryParams params) async {
    try {
      final model = await _remoteDataSource.createEntry(params.toJson());
      return model.toDomain();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<JournalEntry> updateEntry(String id, Map<String, dynamic> params) async {
    try {
      final model = await _remoteDataSource.updateEntry(id, params);
      return model.toDomain();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> deleteEntry(String id) async {
    try {
      await _remoteDataSource.deleteEntry(id);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<JournalStats> getStats() async {
    try {
      final model = await _remoteDataSource.getStats();
      return model.toDomain();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<JournalEntry>> searchEntries(String query) async {
    try {
      final models = await _remoteDataSource.searchEntries(query);
      return models.map((model) => model.toDomain()).toList();
    } catch (e) {
      rethrow;
    }
  }
}

