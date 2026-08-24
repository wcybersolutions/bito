// lib/data/journal/journal_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'journal_entry.dart';
import 'journal_repository.dart';
import 'journal_stats.dart';

final journalRepositoryProvider = Provider<JournalRepository>((ref) {
  return JournalRepository();
});

final journalEntriesProvider = FutureProvider<List<JournalEntry>>((ref) async {
  final repository = ref.read(journalRepositoryProvider);
  return repository.getEntries();
});

final journalStatsProvider = FutureProvider<JournalStats>((ref) async {
  final repository = ref.read(journalRepositoryProvider);
  return repository.getStats();
});

class JournalEntryNotifier extends StateNotifier<JournalEntry?> {
  final JournalRepository _repository;

  JournalEntryNotifier(this._repository) : super(null);

  Future<void> saveEntry(JournalEntry entry) async {
    if (entry.id.isEmpty) {
      await _repository.addEntry(entry);
    } else {
      await _repository.updateEntry(entry);
    }
    state = entry;
  }

  Future<void> deleteEntry(String id) async {
    await _repository.deleteEntry(id);
    state = null;
  }

  Future<void> loadEntry(String id) async {
    final entry = await _repository.getEntry(id);
    state = entry;
  }
}

final journalEntryProvider = StateNotifierProvider<JournalEntryNotifier, JournalEntry?>((ref) {
  final repository = ref.read(journalRepositoryProvider);
  return JournalEntryNotifier(repository);
});

