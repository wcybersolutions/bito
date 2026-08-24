// lib/domain/usecases/auth/check_auth_status_usecase.dart
import '../../repositories/i_auth_repository.dart';
import '../../../core/utils/result.dart';

class CheckAuthStatusUseCase {
  final IAuthRepository _repository;

  CheckAuthStatusUseCase(this._repository);

  Future<Result<bool>> execute() async {
    try {
      final isAuthenticated = await _repository.isAuthenticated();
      return Result.success(isAuthenticated);  // ← Remove 'const'
    } catch (e) {
      return Result.failure(e.toString());
    }
  }
}
