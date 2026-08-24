// lib/core/network/api_response.dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'api_response.freezed.dart';
part 'api_response.g.dart';

@Freezed(genericArgumentFactories: true)
class ApiResponse<T> with _$ApiResponse<T> {
  const ApiResponse._();

  const factory ApiResponse.success(T data) = ApiSuccess<T>;

  const factory ApiResponse.error({
    required String message,
    int? statusCode,
  }) = ApiError<T>;

  const factory ApiResponse.loading() = ApiLoading<T>;

  factory ApiResponse.fromJson(
      Map<String, dynamic> json,
      T Function(Object? json) fromJsonT,
      ) => _$ApiResponseFromJson(json, fromJsonT);

  bool get isSuccess => this is ApiSuccess<T>;
  bool get isLoading => this is ApiLoading<T>;
  bool get isError => this is ApiError<T>;

  T? get data => isSuccess ? (this as ApiSuccess<T>).data : null;
  String? get errorMessage => isError ? (this as ApiError<T>).message : null;
}

