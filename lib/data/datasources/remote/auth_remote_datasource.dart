// lib/data/datasources/remote/auth_remote_datasource.dart
import '../../../core/constants/api_constants.dart';
import '../../../core/network/api_client.dart';
import '../../models/auth/user_model.dart';

class AuthRemoteDataSource {
  final ApiClient _apiClient;

  AuthRemoteDataSource(this._apiClient);

  // POST /api/auth/magic-link - Send magic link email
  Future<void> sendMagicLink(String email) async {
    await _apiClient.post(
      ApiConstants.authMagicLink,
      data: {'email': email},
    );
  }

  // POST /api/auth/magic-link/verify - Verify magic link token
  Future<AuthUserModel> verifyMagicLink(String token) async {
    final response = await _apiClient.post(
      ApiConstants.authVerify,
      data: {'token': token},
    );
    return AuthUserModel.fromJson(response.data['data']);
  }

  // POST /api/auth/logout - Logout
  Future<void> logout() async {
    await _apiClient.post(ApiConstants.authLogout);
  }

  // GET /api/auth/me - Get current user
  Future<AuthUserModel> getCurrentUser() async {
    final response = await _apiClient.get(ApiConstants.authMe);
    return AuthUserModel.fromJson(response.data['data']);
  }

  // PUT /api/auth/refresh - Refresh token
  Future<AuthUserModel> refreshToken() async {
    final response = await _apiClient.put(ApiConstants.authRefresh);
    return AuthUserModel.fromJson(response.data['data']);
  }

  // GET /api/auth/google - Google OAuth
  Future<String> getGoogleAuthUrl() async {
    final response = await _apiClient.get(ApiConstants.authGoogle);
    return response.data['url'];
  }

  // GET /api/auth/google/callback - Google OAuth callback
  Future<AuthUserModel> handleGoogleCallback(String code) async {
    final response = await _apiClient.get(
      ApiConstants.authGoogleCallback,
      queryParameters: {'code': code},
    );
    return AuthUserModel.fromJson(response.data['data']);
  }
}
