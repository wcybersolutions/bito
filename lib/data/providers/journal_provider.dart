// lib/data/providers/journal_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/providers/core_providers.dart';
import '../../domain/entities/journal_entry.dart';
import '../../domain/repositories/i_journal_repository.dart';
import '../../domain/entities/journal_entry.dart' show JournalStats;
import '../datasources/remote/journal_remote_datasource.dart';
import '../repositories/journal_repository.dart';

final journalRemoteDataSourceProvider = Provider<JournalRemoteDataSource>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return JournalRemoteDataSource(apiClient);
});

final journalRepositoryProvider = Provider<IJournalRepository>((ref) {
  final remoteDataSource = ref.watch(journalRemoteDataSourceProvider);
  return JournalRepository(remoteDataSource);
});

final journalEntriesProvider = FutureProvider<List<JournalEntry>>((ref) async {
  final repository = ref.watch(journalRepositoryProvider);
  return repository.getEntries();
});

final journalStatsProvider = FutureProvider<JournalStats>((ref) async {
  final repository = ref.watch(journalRepositoryProvider);
  return repository.getStats();
});

final journalEntryProvider = FutureProvider.family<JournalEntry, String>((ref, id) async {
  final repository = ref.watch(journalRepositoryProvider);
  return repository.getEntry(id);
});

