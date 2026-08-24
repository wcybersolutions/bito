// lib/domain/repositories/i_auth_repository.dart
import '../entities/user.dart';

class SendMagicLinkParams {
  final String email;

  const SendMagicLinkParams({required this.email});

  Map<String, dynamic> toJson() => {'email': email};
}

class VerifyMagicLinkParams {
  final String token;

  const VerifyMagicLinkParams({required this.token});

  Map<String, dynamic> toJson() => {'token': token};
}

abstract class IAuthRepository {
  // Magic Link Auth
  Future<void> sendMagicLink(SendMagicLinkParams params);
  Future<AuthUser> verifyMagicLink(VerifyMagicLinkParams params);

  // Session Management
  Future<void> logout();
  Future<AuthUser?> getCurrentUser();
  Future<bool> isAuthenticated();
  Future<AuthUser> refreshToken();

  // Google OAuth
  Future<String> getGoogleAuthUrl();
  Future<AuthUser> handleGoogleCallback(String code);
}
