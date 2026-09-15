// lib/data/models/verse_model.dart
import 'package:json_annotation/json_annotation.dart';

part 'verse_model.g.dart';

@JsonSerializable()
class VerseModel {
  final String text;
  final String reference;
  @JsonKey(name: 'translation_name')
  final String? translationName;

  VerseModel({
    required this.text,
    required this.reference,
    this.translationName,
  });

  factory VerseModel.fromJson(Map<String, dynamic> json) =>
      _$VerseModelFromJson(json);

  Map<String, dynamic> toJson() => _$VerseModelToJson(this);
}

