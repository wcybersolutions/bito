// lib/core/storage/secure_storage.dart
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';
import '../../domain/entities/user.dart';

class SecureStorage {
  static const String _tokenKey = 'auth_token';
  static const String _refreshTokenKey = 'refresh_token';
  static const String _userIdKey = 'user_id';
  static const String _userKey = 'user';  // Added for user storage

  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  // ============================================================
  // Existing Methods (keep as is)
  // ============================================================

  Future<void> saveAuthToken(String token) async {
    await _storage.write(key: _tokenKey, value: token);
  }

  Future<String?> getAuthToken() async {
    return await _storage.read(key: _tokenKey);
  }

  Future<void> saveRefreshToken(String token) async {
    await _storage.write(key: _refreshTokenKey, value: token);
  }

  Future<String?> getRefreshToken() async {
    return await _storage.read(key: _refreshTokenKey);
  }

  Future<void> saveUserId(String userId) async {
    await _storage.write(key: _userIdKey, value: userId);
  }

  Future<String?> getUserId() async {
    return await _storage.read(key: _userIdKey);
  }

  Future<void> clearAll() async {
    await _storage.deleteAll();
  }

  Future<void> clearAuth() async {
    await _storage.delete(key: _tokenKey);
    await _storage.delete(key: _refreshTokenKey);
  }

  Future<bool> hasAuthToken() async {
    final token = await getAuthToken();
    return token != null && token.isNotEmpty;
  }

  // ============================================================
  // New Methods for Auth Repository
  // ============================================================

  /// Save both tokens at once (used by auth_repository)
  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    await saveAuthToken(accessToken);
    await saveRefreshToken(refreshToken);
  }

  /// Get access token (alias for getAuthToken)
  Future<String?> getAccessToken() async {
    return await getAuthToken();
  }

  /// Save user data
  Future<void> saveUser(AuthUser user) async {
    final userJson = jsonEncode({
      'id': user.id,
      'email': user.email,
      'name': user.name,
      'avatar': user.avatar,
      'isEmailVerified': user.isEmailVerified,
      'accessToken': user.accessToken,
      'refreshToken': user.refreshToken,
      'createdAt': user.createdAt?.toIso8601String(),
      'lastLoginAt': user.lastLoginAt?.toIso8601String(),
    });
    await _storage.write(key: _userKey, value: userJson);

    // Also save userId separately for quick access
    await saveUserId(user.id);
  }

  /// Get user data
  Future<AuthUser?> getUser() async {
    final userJson = await _storage.read(key: _userKey);
    if (userJson == null) return null;
    try {
      final data = jsonDecode(userJson);
      return AuthUser(
        id: data['id'] ?? '',
        email: data['email'] ?? '',
        name: data['name'],
        avatar: data['avatar'],
        isEmailVerified: data['isEmailVerified'] ?? false,
        createdAt: data['createdAt'] != null
            ? DateTime.parse(data['createdAt'])
            : null,
        lastLoginAt: data['lastLoginAt'] != null
            ? DateTime.parse(data['lastLoginAt'])
            : null,
        accessToken: data['accessToken'] ?? '',
        refreshToken: data['refreshToken'] ?? '',
      );
    } catch (e) {
      return null;
    }
  }

  /// Clear user data
  Future<void> clearUser() async {
    await _storage.delete(key: _userKey);
  }

  /// Clear everything (alias for clearAll)
  Future<void> clearAllData() async {
    await clearAll();
  }
}