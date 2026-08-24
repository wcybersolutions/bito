// lib/domain/usecases/habits/create_habit_usecase.dart
import '../../entities/habit.dart';
import '../../repositories/i_habit_repository.dart';
import '../../../core/utils/result.dart';

class CreateHabitUseCase {
  final IHabitRepository _repository;

  CreateHabitUseCase(this._repository);

  Future<Result<Habit>> execute(CreateHabitParams params) async {
    try {
      final habit = await _repository.createHabit(params);
      return Result.success(habit);
    } catch (e) {
      return Result.failure(e.toString());
    }
  }
}

