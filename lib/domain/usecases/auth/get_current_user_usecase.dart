// lib/domain/usecases/auth/get_current_user_usecase.dart
import '../../entities/user.dart';
import '../../repositories/i_auth_repository.dart';
import '../../../core/utils/result.dart';

class GetCurrentUserUseCase {
  final IAuthRepository _repository;

  GetCurrentUserUseCase(this._repository);

  Future<Result<AuthUser?>> execute() async {
    try {
      final user = await _repository.getCurrentUser();
      return Result.success(user);  // ← Remove 'const'
    } catch (e) {
      return Result.failure(e.toString());
    }
  }
}
