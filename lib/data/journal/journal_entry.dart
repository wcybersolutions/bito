// lib/data/journal/journal_entry.dart
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

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
        return PhosphorIcons.smileyXEyes();
      case JournalMood.sad:
        return PhosphorIcons.smileySad();
      case JournalMood.neutral:
        return PhosphorIcons.smileyMeh();
      case JournalMood.happy:
        return PhosphorIcons.smiley();
      case JournalMood.ecstatic:
        return PhosphorIcons.smileyWink();
    }
  }

  Color get color {
    switch (this) {
      case JournalMood.terrible:
        return const Color(0xFFEF4444); // Red
      case JournalMood.sad:
        return const Color(0xFFF97316); // Orange (red fades)
      case JournalMood.neutral:
        return const Color(0xFFEAB308); // Yellow
      case JournalMood.happy:
        return const Color(0xFF84CC16); // Close to green (lime)
      case JournalMood.ecstatic:
        return const Color(0xFF22C55E); // Green
    }
  }
}

class QuickLog {
  final String id;
  final DateTime timestamp;
  final String content;

  QuickLog({
    required this.id,
    required this.timestamp,
    required this.content,
  });
}

class JournalEntry {
  final String id;
  final DateTime date;
  JournalMood? mood;
  int? energy; // 0 to 4 (5 battery levels)
  List<QuickLog> quickLogs;
  String longFormContent;

  JournalEntry({
    required this.id,
    required this.date,
    this.mood,
    this.energy,
    List<QuickLog>? quickLogs,
    this.longFormContent = '',
  }) : quickLogs = quickLogs ?? [];

  // Live calculated stats
  int get wordCount {
    if (longFormContent.trim().isEmpty) return 0;
    return longFormContent.trim().split(RegExp(r'\s+')).length;
  }

  int get readingTimeMinutes {
    // Average reading speed: 200 words per minute
    return (wordCount / 200).ceil().clamp(1, 999);
  }

  int get totalQuickNotes => quickLogs.length;
}

