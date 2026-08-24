// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'habit_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HabitModel _$HabitModelFromJson(Map<String, dynamic> json) => HabitModel(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      cadence: json['cadence'] as String,
      block: json['block'] as String,
      icon: json['icon'] as String,
      color: (json['color'] as num).toInt(),
      isCompleted: json['isCompleted'] as bool? ?? false,
      streak: (json['streak'] as num?)?.toInt() ?? 0,
      target: (json['target'] as num?)?.toInt(),
      progress: (json['progress'] as num?)?.toInt(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$HabitModelToJson(HabitModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'cadence': instance.cadence,
      'block': instance.block,
      'icon': instance.icon,
      'color': instance.color,
      'isCompleted': instance.isCompleted,
      'streak': instance.streak,
      'target': instance.target,
      'progress': instance.progress,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };
