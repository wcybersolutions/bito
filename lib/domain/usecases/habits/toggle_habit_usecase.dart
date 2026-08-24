import '../../entities/habit.dart';
import '../../repositories/i_habit_repository.dart';
import '../../../core/utils/result.dart';

class ToggleHabitUseCase {
  final IHabitRepository _repository;

  ToggleHabitUseCase(this._repository);

  Future<Result<Habit>> execute(String habitId) async {
    try {
      final habit = await _repository.toggleHabit(habitId);
      return Result.success(habit);
    } catch (e) {
      return Result.failure(e.toString());
    }
  }
}
