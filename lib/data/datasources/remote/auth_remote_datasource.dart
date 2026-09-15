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
    final data = (response.data is Map<String, dynamic> && response.data.containsKey('data'))
        ? response.data['data']
        : response.data;
    return AuthUserModel.fromJson(data as Map<String, dynamic>);
  }

  // POST /api/auth/logout - Logout
  Future<void> logout() async {
    await _apiClient.post(ApiConstants.authLogout);
  }

  // GET /api/auth/me - Get current user
  Future<AuthUserModel> getCurrentUser() async {
    final response = await _apiClient.get(ApiConstants.authMe);
    final data = (response.data is Map<String, dynamic> && response.data.containsKey('data'))
        ? response.data['data']
        : response.data;
    return AuthUserModel.fromJson(data as Map<String, dynamic>);
  }

  // PUT /api/auth/refresh - Refresh token
  Future<AuthUserModel> refreshToken() async {
    final response = await _apiClient.put(ApiConstants.authRefresh);
    final data = (response.data is Map<String, dynamic> && response.data.containsKey('data'))
        ? response.data['data']
        : response.data;
    return AuthUserModel.fromJson(data as Map<String, dynamic>);
  }

  // GET /api/auth/google - Google OAuth
  Future<String> getGoogleAuthUrl() async {
    final response = await _apiClient.get(ApiConstants.authGoogle);
    return response.data['url'] ?? response.data['data']?['url'] ?? '';
  }

  // GET /api/auth/google/callback - Google OAuth callback
  Future<AuthUserModel> handleGoogleCallback(String code) async {
    final response = await _apiClient.get(
      ApiConstants.authGoogleCallback,
      queryParameters: {'code': code},
    );
    final data = (response.data is Map<String, dynamic> && response.data.containsKey('data'))
        ? response.data['data']
        : response.data;
    return AuthUserModel.fromJson(data as Map<String, dynamic>);
  }
}
