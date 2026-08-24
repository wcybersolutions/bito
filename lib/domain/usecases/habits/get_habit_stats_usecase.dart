import '../../entities/habit.dart';
import '../../repositories/i_habit_repository.dart';
import '../../../core/utils/result.dart';

class GetHabitStatsUseCase {
  final IHabitRepository _repository;

  GetHabitStatsUseCase(this._repository);

  Future<Result<HabitStats>> execute() async {
    try {
      final stats = await _repository.getStats();
      return Result.success(stats);
    } catch (e) {
      return Result.failure(e.toString());
    }
  }
}

