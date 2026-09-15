// lib/core/network/api_client.dart
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../constants/api_constants.dart';
import '../storage/secure_storage.dart';
import 'api_interceptor.dart';

class ApiClient {
  late Dio _dio;
  final SecureStorage _secureStorage = SecureStorage();

  static final ApiClient _instance = ApiClient._internal();

  factory ApiClient() => _instance;

  ApiClient._internal() {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseApiUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    // Add interceptors
    _dio.interceptors.add(ApiInterceptor(_secureStorage));

    // Add logging in debug mode
    if (kDebugMode) {
      _dio.interceptors.add(
        LogInterceptor(
          request: true,
          requestHeader: true,
          requestBody: true,
          responseHeader: true,
          responseBody: true,
          error: true,
        ),
      );
    }
  }

  Dio get dio => _dio;

  // Generic GET
  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      return await _dio.get(
        path,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
      );
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // Generic POST
  Future<Response> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      return await _dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // Generic PUT
  Future<Response> put(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      return await _dio.put(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // Generic PATCH
  Future<Response> patch(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      return await _dio.patch(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // Generic DELETE
  Future<Response> delete(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      return await _dio.delete(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // Helper: Replace path parameters
  String replacePathParam(String path, String param, String value) {
    return path.replaceAll(':$param', value);
  }

  // Error handling
  dynamic _handleError(DioException error) {
    if (error.response != null) {
      final statusCode = error.response?.statusCode;
      final data = error.response?.data;

      // Try to extract error message from response
      String message = 'Something went wrong';
      if (data is Map<String, dynamic>) {
        message = data['error'] ?? data['message'] ?? message;
      }

      // Handle specific status codes
      switch (statusCode) {
        case 400:
          throw BadRequestException(message);
        case 401:
          throw UnauthorizedException(message);
        case 403:
          throw ForbiddenException(message);
        case 404:
          throw NotFoundException(message);
        case 429:
          throw RateLimitException(message);
        case 500:
        case 502:
        case 503:
          throw ServerException(message);
        default:
          throw ApiException(message, statusCode: statusCode);
      }
    } else {
      // Network error
      throw NetworkException(error.message ?? 'Network error');
    }
  }
}

// Custom Exceptions
class ApiException implements Exception {
  final String message;
  final int? statusCode;

  ApiException(this.message, {this.statusCode});

  @override
  String toString() => 'ApiException: $message (Status: $statusCode)';
}

class BadRequestException extends ApiException {
  BadRequestException(super.message) : super(statusCode: 400);
}

class UnauthorizedException extends ApiException {
  UnauthorizedException(super.message) : super(statusCode: 401);
}

class ForbiddenException extends ApiException {
  ForbiddenException(super.message) : super(statusCode: 403);
}

class NotFoundException extends ApiException {
  NotFoundException(super.message) : super(statusCode: 404);
}

class RateLimitException extends ApiException {
  RateLimitException(super.message) : super(statusCode: 429);
}

class ServerException extends ApiException {
  ServerException(super.message) : super(statusCode: 500);
}

class NetworkException extends ApiException {
  NetworkException(super.message);
}
