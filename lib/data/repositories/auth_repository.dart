// lib/data/repositories/auth_repository.dart
import '../../core/storage/secure_storage.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/i_auth_repository.dart';
import '../datasources/remote/auth_remote_datasource.dart';

class AuthRepository implements IAuthRepository {
  final AuthRemoteDataSource _remoteDataSource;
  final SecureStorage _secureStorage;

  AuthRepository(this._remoteDataSource, this._secureStorage);

  @override
  Future<void> sendMagicLink(SendMagicLinkParams params) async {
    try {
      await _remoteDataSource.sendMagicLink(params.email);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<AuthUser> verifyMagicLink(VerifyMagicLinkParams params) async {
    try {
      final model = await _remoteDataSource.verifyMagicLink(params.token);
      final user = model.toDomain();
      await _secureStorage.saveTokens(
        accessToken: user.accessToken,
        refreshToken: user.refreshToken,
      );
      await _secureStorage.saveUser(user);
      return user;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> logout() async {
    try {
      await _remoteDataSource.logout();
    } catch (e) {
      // Ignore errors on logout
    } finally {
      await _secureStorage.clearAll();
    }
  }

  @override
  Future<AuthUser?> getCurrentUser() async {
    try {
      final user = await _secureStorage.getUser();
      if (user == null) return null;
      // Optionally refresh user data from server
      return user;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<bool> isAuthenticated() async {
    try {
      final token = await _secureStorage.getAccessToken();
      return token != null && token.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<AuthUser> refreshToken() async {
    try {
      final model = await _remoteDataSource.refreshToken();
      final user = model.toDomain();
      await _secureStorage.saveTokens(
        accessToken: user.accessToken,
        refreshToken: user.refreshToken,
      );
      await _secureStorage.saveUser(user);
      return user;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<String> getGoogleAuthUrl() async {
    try {
      return await _remoteDataSource.getGoogleAuthUrl();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<AuthUser> handleGoogleCallback(String code) async {
    try {
      final model = await _remoteDataSource.handleGoogleCallback(code);
      final user = model.toDomain();
      await _secureStorage.saveTokens(
        accessToken: user.accessToken,
        refreshToken: user.refreshToken,
      );
      await _secureStorage.saveUser(user);
      return user;
    } catch (e) {
      rethrow;
    }
  }
}
