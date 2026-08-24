// lib/domain/usecases/auth/verify_magic_link_usecase.dart
import '../../entities/user.dart';
import '../../repositories/i_auth_repository.dart';
import '../../../core/utils/result.dart';

class VerifyMagicLinkUseCase {
  final IAuthRepository _repository;

  VerifyMagicLinkUseCase(this._repository);

  Future<Result<AuthUser>> execute(VerifyMagicLinkParams params) async {
    try {
      final user = await _repository.verifyMagicLink(params);
      return Result.success(user);
    } catch (e) {
      return Result.failure(e.toString());
    }
  }
}

