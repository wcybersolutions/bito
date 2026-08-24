// lib/data/journal/journal_stats.dart
class JournalStats {
  final int totalEntries;
  final int totalWords;
  final int journaledDays;
  final int quickNotes;
  final int longForms;
  final int totalReadTime;

  const JournalStats({
    required this.totalEntries,
    required this.totalWords,
    required this.journaledDays,
    this.quickNotes = 0,
    this.longForms = 0,
    this.totalReadTime = 0,
  });

  JournalStats copyWith({
    int? totalEntries,
    int? totalWords,
    int? journaledDays,
    int? quickNotes,
    int? longForms,
    int? totalReadTime,
  }) {
    return JournalStats(
      totalEntries: totalEntries ?? this.totalEntries,
      totalWords: totalWords ?? this.totalWords,
      journaledDays: journaledDays ?? this.journaledDays,
      quickNotes: quickNotes ?? this.quickNotes,
      longForms: longForms ?? this.longForms,
      totalReadTime: totalReadTime ?? this.totalReadTime,
    );
  }

  factory JournalStats.fromJson(Map<String, dynamic> json) {
    return JournalStats(
      totalEntries: json['totalEntries'] ?? 0,
      totalWords: json['totalWords'] ?? 0,
      journaledDays: json['journaledDays'] ?? 0,
      quickNotes: json['quickNotes'] ?? 0,
      longForms: json['longForms'] ?? 0,
      totalReadTime: json['totalReadTime'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalEntries': totalEntries,
      'totalWords': totalWords,
      'journaledDays': journaledDays,
      'quickNotes': quickNotes,
      'longForms': longForms,
      'totalReadTime': totalReadTime,
    };
  }
}

