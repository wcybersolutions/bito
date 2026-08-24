// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'journal_stats_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

JournalStatsModel _$JournalStatsModelFromJson(Map<String, dynamic> json) =>
    JournalStatsModel(
      totalEntries: (json['totalEntries'] as num).toInt(),
      totalWords: (json['totalWords'] as num).toInt(),
      journaledDays: (json['journaledDays'] as num).toInt(),
      quickNotes: (json['quickNotes'] as num?)?.toInt() ?? 0,
      longForms: (json['longForms'] as num?)?.toInt() ?? 0,
      totalReadTime: (json['totalReadTime'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$JournalStatsModelToJson(JournalStatsModel instance) =>
    <String, dynamic>{
      'totalEntries': instance.totalEntries,
      'totalWords': instance.totalWords,
      'journaledDays': instance.journaledDays,
      'quickNotes': instance.quickNotes,
      'longForms': instance.longForms,
      'totalReadTime': instance.totalReadTime,
    };
