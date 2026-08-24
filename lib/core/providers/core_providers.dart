// lib/core/providers/core_providers.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../network/api_client.dart';
import '../storage/secure_storage.dart';

// API Client - Singleton
final apiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient();
});

// Secure Storage - Singleton
final secureStorageProvider = Provider<SecureStorage>((ref) {
  return SecureStorage();
});
