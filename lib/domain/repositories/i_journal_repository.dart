// lib/domain/repositories/i_journal_repository.dart
import '../entities/journal_entry.dart';

class CreateJournalEntryParams {
  final DateTime date;
  final JournalMood? mood;
  final int? energy;
  final List<QuickLog> quickLogs;
  final String longFormContent;

  CreateJournalEntryParams({
    required this.date,
    this.mood,
    this.energy,
    this.quickLogs = const [],
    this.longFormContent = '',
  });

  Map<String, dynamic> toJson() => {
    'date': date.toIso8601String(),
    'mood': mood?.toString().split('.').last,
    'energy': energy,
    'quickLogs': quickLogs.map((q) => {
      'id': q.id,
      'timestamp': q.timestamp.toIso8601String(),
      'content': q.content,
    }).toList(),
    'longFormContent': longFormContent,
  };
}

abstract class IJournalRepository {
  Future<List<JournalEntry>> getEntries();
  Future<JournalEntry> getEntry(String id);
  Future<JournalEntry> createEntry(CreateJournalEntryParams params);
  Future<JournalEntry> updateEntry(String id, Map<String, dynamic> params);
  Future<void> deleteEntry(String id);
  Future<JournalStats> getStats();
  Future<List<JournalEntry>> searchEntries(String query);
}

