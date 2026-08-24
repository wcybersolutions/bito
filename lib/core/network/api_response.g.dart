// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ApiSuccessImpl<T> _$$ApiSuccessImplFromJson<T>(
  Map<String, dynamic> json,
  T Function(Object? json) fromJsonT,
) =>
    _$ApiSuccessImpl<T>(
      fromJsonT(json['data']),
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$$ApiSuccessImplToJson<T>(
  _$ApiSuccessImpl<T> instance,
  Object? Function(T value) toJsonT,
) =>
    <String, dynamic>{
      'data': toJsonT(instance.data),
      'runtimeType': instance.$type,
    };

_$ApiErrorImpl<T> _$$ApiErrorImplFromJson<T>(
  Map<String, dynamic> json,
  T Function(Object? json) fromJsonT,
) =>
    _$ApiErrorImpl<T>(
      message: json['message'] as String,
      statusCode: (json['statusCode'] as num?)?.toInt(),
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$$ApiErrorImplToJson<T>(
  _$ApiErrorImpl<T> instance,
  Object? Function(T value) toJsonT,
) =>
    <String, dynamic>{
      'message': instance.message,
      'statusCode': instance.statusCode,
      'runtimeType': instance.$type,
    };

_$ApiLoadingImpl<T> _$$ApiLoadingImplFromJson<T>(
  Map<String, dynamic> json,
  T Function(Object? json) fromJsonT,
) =>
    _$ApiLoadingImpl<T>(
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$$ApiLoadingImplToJson<T>(
  _$ApiLoadingImpl<T> instance,
  Object? Function(T value) toJsonT,
) =>
    <String, dynamic>{
      'runtimeType': instance.$type,
    };
