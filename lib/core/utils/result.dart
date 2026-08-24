// lib/core/utils/result.dart
import 'package:equatable/equatable.dart';

class Result<T> extends Equatable {
  final T? data;
  final String? error;
  final bool isSuccess;

  const Result._({
    this.data,
    this.error,
    required this.isSuccess,
  });

  factory Result.success(T data) {
    return Result._(
      data: data,
      isSuccess: true,
    );
  }

  factory Result.failure(String error) {
    return Result._(
      error: error,
      isSuccess: false,
    );
  }

  @override
  List<Object?> get props => [data, error, isSuccess];

  bool get hasData => data != null;
  bool get hasError => error != null && error!.isNotEmpty;
}

extension ResultExtension<T> on Result<T> {
  void when({
    required Function(T data) success,
    required Function(String error) failure,
  }) {
    if (isSuccess && data != null) {
      success(data as T);
    } else if (!isSuccess && error != null) {
      failure(error!);
    }
  }
}

