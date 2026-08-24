// lib/domain/usecases/auth/sign_out_usecase.dart
import '../../repositories/i_auth_repository.dart';
import '../../../core/utils/result.dart';

class SignOutUseCase {
  final IAuthRepository _repository;

  SignOutUseCase(this._repository);

  Future<Result<void>> execute() async {
    try {
      await _repository.logout();
      return Result.success(null);  // ← Remove 'const'
    } catch (e) {
      return Result.failure(e.toString());
    }
  }
}

