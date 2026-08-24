// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'journal_entry_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

JournalEntryModel _$JournalEntryModelFromJson(Map<String, dynamic> json) =>
    JournalEntryModel(
      id: json['id'] as String,
      date: DateTime.parse(json['date'] as String),
      mood: json['mood'] as String?,
      energy: (json['energy'] as num?)?.toInt(),
      quickLogs: (json['quickLogs'] as List<dynamic>?)
              ?.map((e) => QuickLogModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      longFormContent: json['longFormContent'] as String? ?? '',
    );

Map<String, dynamic> _$JournalEntryModelToJson(JournalEntryModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'date': instance.date.toIso8601String(),
      'mood': instance.mood,
      'energy': instance.energy,
      'quickLogs': instance.quickLogs,
      'longFormContent': instance.longFormContent,
    };

QuickLogModel _$QuickLogModelFromJson(Map<String, dynamic> json) =>
    QuickLogModel(
      id: json['id'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      content: json['content'] as String,
    );

Map<String, dynamic> _$QuickLogModelToJson(QuickLogModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'timestamp': instance.timestamp.toIso8601String(),
      'content': instance.content,
    };
