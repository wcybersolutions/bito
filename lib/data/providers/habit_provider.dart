// lib/data/providers/habit_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/network/api_client.dart';
import '../../domain/entities/habit.dart';
import '../../domain/repositories/i_habit_repository.dart';
import '../../domain/usecases/habits/get_habits_usecase.dart';
import '../../domain/usecases/habits/create_habit_usecase.dart';
import '../../domain/usecases/habits/toggle_habit_usecase.dart';
import '../../domain/usecases/habits/get_habit_stats_usecase.dart';
import '../../domain/usecases/habits/delete_habit_usecase.dart';
import '../datasources/remote/habit_remote_datasource.dart';
import '../repositories/habit_repository.dart';

// Data Sources
final habitRemoteDataSourceProvider = Provider<HabitRemoteDataSource>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return HabitRemoteDataSource(apiClient);
});

// Repositories
final habitRepositoryProvider = Provider<IHabitRepository>((ref) {
  final remoteDataSource = ref.watch(habitRemoteDataSourceProvider);
  return HabitRepository(remoteDataSource);
});

// Use Cases
final getHabitsUseCaseProvider = Provider<GetHabitsUseCase>((ref) {
  final repository = ref.watch(habitRepositoryProvider);
  return GetHabitsUseCase(repository);
});

final createHabitUseCaseProvider = Provider<CreateHabitUseCase>((ref) {
  final repository = ref.watch(habitRepositoryProvider);
  return CreateHabitUseCase(repository);
});

final toggleHabitUseCaseProvider = Provider<ToggleHabitUseCase>((ref) {
  final repository = ref.watch(habitRepositoryProvider);
  return ToggleHabitUseCase(repository);
});

final getHabitStatsUseCaseProvider = Provider<GetHabitStatsUseCase>((ref) {
  final repository = ref.watch(habitRepositoryProvider);
  return GetHabitStatsUseCase(repository);
});

final deleteHabitUseCaseProvider = Provider<DeleteHabitUseCase>((ref) {
  final repository = ref.watch(habitRepositoryProvider);
  return DeleteHabitUseCase(repository);
});

// API Client Provider
final apiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient();
});

// State Providers
final habitsProvider = FutureProvider<List<Habit>>((ref) async {
  final useCase = ref.watch(getHabitsUseCaseProvider);
  final result = await useCase.execute();
  return result.data ?? [];
});

final habitStatsProvider = FutureProvider<HabitStats>((ref) async {
  final useCase = ref.watch(getHabitStatsUseCaseProvider);
  final result = await useCase.execute();
  return result.data ??
      HabitStats(
        totalHabits: 0,
        completedToday: 0,
        weeklyCompleted: 0,
        streak: 0,
        completionRate: 0,
      );
});

// Individual habit provider (with family)
final habitProvider = FutureProvider.family<Habit, String>((ref, id) async {
  final repository = ref.watch(habitRepositoryProvider);
  return await repository.getHabit(id);
});

// Habit completion state notifier
class HabitCompletionNotifier extends StateNotifier<Map<String, bool>> {
  final IHabitRepository _repository;
  final Ref _ref;

  HabitCompletionNotifier(this._repository, this._ref) : super({});

  Future<void> toggleHabit(String id) async {
    try {
      final habit = await _repository.toggleHabit(id);
      state = {...state, id: habit.isCompleted};
      // Refresh habits list
      _ref.refresh(habitsProvider);
    } catch (e) {
      // Handle error
    }
  }

  void setInitialStates(List<Habit> habits) {
    final states = <String, bool>{};
    for (final habit in habits) {
      states[habit.id] = habit.isCompleted;
    }
    state = states;
  }
}

final habitCompletionProvider =
    StateNotifierProvider<HabitCompletionNotifier, Map<String, bool>>((ref) {
      final repository = ref.watch(habitRepositoryProvider);
      return HabitCompletionNotifier(repository, ref);
    });
