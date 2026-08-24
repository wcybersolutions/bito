// lib/data/repositories/habit_repository.dart
import '../../domain/entities/habit.dart';
import '../../domain/repositories/i_habit_repository.dart';
import '../datasources/remote/habit_remote_datasource.dart';
import '../models/habits/habit_model.dart';
import '../models/habits/habit_stats_model.dart';

class HabitRepository implements IHabitRepository {
  final HabitRemoteDataSource _remoteDataSource;

  HabitRepository(this._remoteDataSource);

  @override
  Future<List<Habit>> getHabits() async {
    try {
      final models = await _remoteDataSource.getHabits();
      return models.map((model) => model.toDomain()).toList();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Habit> getHabit(String id) async {
    try {
      final model = await _remoteDataSource.getHabit(id);
      return model.toDomain();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Habit> createHabit(CreateHabitParams params) async {
    try {
      final model = await _remoteDataSource.createHabit(params.toJson());
      return model.toDomain();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Habit> updateHabit(String id, UpdateHabitParams params) async {
    try {
      final model = await _remoteDataSource.updateHabit(id, params.toJson());
      return model.toDomain();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> deleteHabit(String id) async {
    try {
      await _remoteDataSource.deleteHabit(id);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Habit> toggleHabit(String id) async {
    try {
      final model = await _remoteDataSource.toggleHabit(id);
      return model.toDomain();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<HabitStats> getStats() async {
    try {
      final model = await _remoteDataSource.getStats();
      return model.toDomain();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<Habit>> getHabitsByBlock(HabitTimeBlock block) async {
    try {
      final allHabits = await getHabits();
      return allHabits.where((h) => h.block == block).toList();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<Habit>> getDailyHabits() async {
    try {
      final habits = await getHabits();
      return habits.where((h) => h.isDaily).toList();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<Habit>> getWeeklyHabits() async {
    try {
      final habits = await getHabits();
      return habits.where((h) => h.isWeekly).toList();
    } catch (e) {
      rethrow;
    }
  }
}

