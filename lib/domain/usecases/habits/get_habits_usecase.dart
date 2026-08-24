// lib/domain/usecases/habits/get_habits_usecase.dart
import '../../entities/habit.dart';
import '../../repositories/i_habit_repository.dart';
import '../../../core/utils/result.dart';

class GetHabitsUseCase {
  final IHabitRepository _repository;

  GetHabitsUseCase(this._repository);

  Future<Result<List<Habit>>> execute() async {
    try {
      final habits = await _repository.getHabits();
      return Result.success(habits);
    } catch (e) {
      return Result.failure(e.toString());
    }
  }
}

