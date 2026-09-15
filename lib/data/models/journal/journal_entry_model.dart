// lib/data/models/journal/journal_entry_model.dart
import 'package:json_annotation/json_annotation.dart';
import '../../../domain/entities/journal_entry.dart';

part 'journal_entry_model.g.dart';

@JsonSerializable()
class JournalEntryModel {
  final String id;
  final DateTime date;
  final String? mood;
  final int? energy;
  final List<QuickLogModel> quickLogs;
  final String longFormContent;

  JournalEntryModel({
    required this.id,
    required this.date,
    this.mood,
    this.energy,
    this.quickLogs = const [],
    this.longFormContent = '',
  });

  factory JournalEntryModel.fromJson(Map<String, dynamic> json) =>
      _$JournalEntryModelFromJson(json);
  Map<String, dynamic> toJson() => _$JournalEntryModelToJson(this);

  JournalEntry toDomain() {
    return JournalEntry(
      id: id,
      date: date,
      mood: mood != null ? _stringToMood(mood!) : null,
      energy: energy,
      quickLogs: quickLogs.map((q) => q.toDomain()).toList(),
      longFormContent: longFormContent,
    );
  }

  factory JournalEntryModel.fromDomain(JournalEntry entry) {
    return JournalEntryModel(
      id: entry.id,
      date: entry.date,
      mood: entry.mood?.toString().split('.').last,
      energy: entry.energy,
      quickLogs: entry.quickLogs
          .map((q) => QuickLogModel.fromDomain(q))
          .toList(),
      longFormContent: entry.longFormContent,
    );
  }

  static JournalMood _stringToMood(String mood) {
    switch (mood) {
      case 'terrible':
        return JournalMood.terrible;
      case 'sad':
        return JournalMood.sad;
      case 'neutral':
        return JournalMood.neutral;
      case 'happy':
        return JournalMood.happy;
      case 'ecstatic':
        return JournalMood.ecstatic;
      default:
        return JournalMood.neutral;
    }
  }
}

@JsonSerializable()
class QuickLogModel {
  final String id;
  final DateTime timestamp;
  final String content;

  QuickLogModel({
    required this.id,
    required this.timestamp,
    required this.content,
  });

  factory QuickLogModel.fromJson(Map<String, dynamic> json) =>
      _$QuickLogModelFromJson(json);
  Map<String, dynamic> toJson() => _$QuickLogModelToJson(this);

  QuickLog toDomain() {
    return QuickLog(id: id, timestamp: timestamp, content: content);
  }

  factory QuickLogModel.fromDomain(QuickLog log) {
    return QuickLogModel(
      id: log.id,
      timestamp: log.timestamp,
      content: log.content,
    );
  }
}
