// lib/domain/usecases/auth/google_sign_in_usecase.dart
import '../../entities/user.dart';
import '../../repositories/i_auth_repository.dart';
import '../../../core/utils/result.dart';

class GoogleSignInUseCase {
  final IAuthRepository _repository;

  GoogleSignInUseCase(this._repository);

  Future<Result<String>> getAuthUrl() async {
    try {
      final url = await _repository.getGoogleAuthUrl();
      return Result.success(url);
    } catch (e) {
      return Result.failure(e.toString());
    }
  }

  Future<Result<AuthUser>> handleCallback(String code) async {
    try {
      final user = await _repository.handleGoogleCallback(code);
      return Result.success(user);
    } catch (e) {
      return Result.failure(e.toString());
    }
  }
}

