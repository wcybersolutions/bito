// lib/domain/usecases/auth/send_magic_link_usecase.dart
import '../../repositories/i_auth_repository.dart';
import '../../../core/utils/result.dart';

class SendMagicLinkUseCase {
  final IAuthRepository _repository;

  SendMagicLinkUseCase(this._repository);

  Future<Result<void>> execute(SendMagicLinkParams params) async {
    try {
      await _repository.sendMagicLink(params);
      return Result.success(null);  // ← Remove 'const'
    } catch (e) {
      return Result.failure(e.toString());
    }
  }
}

