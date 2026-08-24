// lib/data/models/journal/journal_stats_model.dart
import 'package:json_annotation/json_annotation.dart';
import '../../../domain/entities/journal_entry.dart';

part 'journal_stats_model.g.dart';

@JsonSerializable()
class JournalStatsModel {
  final int totalEntries;
  final int totalWords;
  final int journaledDays;
  final int quickNotes;
  final int longForms;
  final int totalReadTime;

  JournalStatsModel({
    required this.totalEntries,
    required this.totalWords,
    required this.journaledDays,
    this.quickNotes = 0,
    this.longForms = 0,
    this.totalReadTime = 0,
  });

  factory JournalStatsModel.fromJson(Map<String, dynamic> json) => _$JournalStatsModelFromJson(json);
  Map<String, dynamic> toJson() => _$JournalStatsModelToJson(this);

  JournalStats toDomain() {
    return JournalStats(
      totalEntries: totalEntries,
      totalWords: totalWords,
      journaledDays: journaledDays,
      quickNotes: quickNotes,
      longForms: longForms,
      totalReadTime: totalReadTime,
    );
  }

  factory JournalStatsModel.fromDomain(JournalStats stats) {
    return JournalStatsModel(
      totalEntries: stats.totalEntries,
      totalWords: stats.totalWords,
      journaledDays: stats.journaledDays,
      quickNotes: stats.quickNotes,
      longForms: stats.longForms,
      totalReadTime: stats.totalReadTime,
    );
  }
}

