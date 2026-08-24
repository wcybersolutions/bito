import '../../repositories/i_habit_repository.dart';
import '../../../core/utils/result.dart';

class DeleteHabitUseCase {
  final IHabitRepository _repository;

  DeleteHabitUseCase(this._repository);

  Future<Result<void>> execute(String habitId) async {
    try {
      await _repository.deleteHabit(habitId);
      return Result.success(null);
    } catch (e) {
      return Result.failure(e.toString());
    }
  }
}