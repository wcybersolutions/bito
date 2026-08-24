// lib/domain/entities/journal_entry.dart
import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';


enum JournalMood {
  terrible,
  sad,
  neutral,
  happy,
  ecstatic,
}

extension JournalMoodExtension on JournalMood {
  String get label {
    switch (this) {
      case JournalMood.terrible:
        return 'Terrible';
      case JournalMood.sad:
        return 'Sad';
      case JournalMood.neutral:
        return 'Neutral';
      case JournalMood.happy:
        return 'Happy';
      case JournalMood.ecstatic:
        return 'Ecstatic';
    }
  }

  IconData get icon {
    switch (this) {
      case JournalMood.terrible:
        return Icons.sentiment_very_dissatisfied;
      case JournalMood.sad:
        return Icons.sentiment_dissatisfied;
      case JournalMood.neutral:
        return Icons.sentiment_neutral;
      case JournalMood.happy:
        return Icons.sentiment_satisfied;
      case JournalMood.ecstatic:
        return Icons.sentiment_very_satisfied;
    }
  }

  Color get color {
    switch (this) {
      case JournalMood.terrible:
        return Colors.red;
      case JournalMood.sad:
        return Colors.orange;
      case JournalMood.neutral:
        return Colors.grey;
      case JournalMood.happy:
        return Colors.green;
      case JournalMood.ecstatic:
        return Colors.teal;
    }
  }
}

class QuickLog extends Equatable {
  final String id;
  final DateTime timestamp;
  final String content;

  const QuickLog({
    required this.id,
    required this.timestamp,
    required this.content,
  });

  @override
  List<Object?> get props => [id, timestamp, content];
}

class JournalEntry extends Equatable {
  final String id;
  final DateTime date;
  final JournalMood? mood;
  final int? energy; // 0 to 4
  final List<QuickLog> quickLogs;
  final String longFormContent;

  const JournalEntry({
    required this.id,
    required this.date,
    this.mood,
    this.energy,
    this.quickLogs = const [],
    this.longFormContent = '',
  });

  int get wordCount {
    if (longFormContent.trim().isEmpty) return 0;
    return longFormContent.trim().split(RegExp(r'\s+')).length;
  }

  int get readingTimeMinutes {
    return (wordCount / 200).ceil().clamp(1, 999);
  }

  int get totalQuickNotes => quickLogs.length;

  @override
  List<Object?> get props => [
    id,
    date,
    mood,
    energy,
    quickLogs,
    longFormContent,
  ];
}

class JournalStats extends Equatable {
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

  @override
  List<Object?> get props => [
    totalEntries,
    totalWords,
    journaledDays,
    quickNotes,
    longForms,
    totalReadTime,
  ];
}
