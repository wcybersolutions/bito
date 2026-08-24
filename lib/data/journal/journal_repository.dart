// lib/data/journal/journal_repository.dart
import 'journal_entry.dart';
import 'journal_stats.dart';

class JournalRepository {
  static List<JournalEntry> _entries = [];

  JournalRepository() {
    if (_entries.isEmpty) {
      _entries = _getSampleEntries();
    }
  }

  Future<List<JournalEntry>> getEntries() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _entries;
  }

  Future<JournalEntry> getEntry(String id) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return _entries.firstWhere((e) => e.id == id);
  }

  Future<JournalEntry> addEntry(JournalEntry entry) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _entries.insert(0, entry);
    return entry;
  }

  Future<JournalEntry> updateEntry(JournalEntry entry) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final index = _entries.indexWhere((e) => e.id == entry.id);
    if (index != -1) {
      _entries[index] = entry;
    }
    return entry;
  }

  Future<void> deleteEntry(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _entries.removeWhere((e) => e.id == id);
  }

  Future<JournalStats> getStats() async {
    await Future.delayed(const Duration(milliseconds: 200));

    final totalEntries = _entries.length;
    final totalWords = _entries.fold(0, (sum, e) => sum + e.wordCount);
    final journaledDays = _entries.map((e) => e.date.day).toSet().length;
    final quickNotes = _entries.where((e) => e.totalQuickNotes > 0).length;
    final longForms = _entries.where((e) => e.longFormContent.isNotEmpty).length;
    final totalReadTime = _entries.fold(0, (sum, e) => sum + e.readingTimeMinutes);

    return JournalStats(
      totalEntries: totalEntries,
      totalWords: totalWords,
      journaledDays: journaledDays,
      quickNotes: quickNotes,
      longForms: longForms,
      totalReadTime: totalReadTime,
    );
  }

  List<JournalEntry> _getSampleEntries() {
    final now = DateTime.now();
    return [
      JournalEntry(
        id: '1',
        date: now.subtract(const Duration(days: 2)),
        mood: JournalMood.happy,
        energy: 4,
        longFormContent: 'A documentary exploring Letsile Tebogo\'s inspiring journey from a small village to becoming a world-class athlete. His dedication and consistency are truly remarkable.',
        quickLogs: [
          QuickLog(
            id: 'q1',
            timestamp: now.subtract(const Duration(days: 2)),
            content: 'Watched inspiring documentary',
          ),
        ],
      ),
      JournalEntry(
        id: '2',
        date: now.subtract(const Duration(days: 4)),
        mood: JournalMood.neutral,
        energy: 3,
        longFormContent: 'Mastering momentum is all about understanding the psychology of consistency. Once you start something and gain traction, it becomes easier to continue. The key is to start small and build gradually.',
        quickLogs: [],
      ),
      JournalEntry(
        id: '3',
        date: now.subtract(const Duration(days: 8)),
        mood: JournalMood.happy,
        energy: 5,
        longFormContent: 'Committed to running every morning. Starting with 2km and building up. Need to stay consistent with this new habit.',
        quickLogs: [
          QuickLog(
            id: 'q2',
            timestamp: now.subtract(const Duration(days: 8)),
            content: 'Morning run completed!',
          ),
        ],
      ),
    ];
  }
}

