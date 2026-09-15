// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'verse_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VerseModel _$VerseModelFromJson(Map<String, dynamic> json) => VerseModel(
      text: json['text'] as String,
      reference: json['reference'] as String,
      translationName: json['translation_name'] as String?,
    );

Map<String, dynamic> _$VerseModelToJson(VerseModel instance) =>
    <String, dynamic>{
      'text': instance.text,
      'reference': instance.reference,
      'translation_name': instance.translationName,
    };
