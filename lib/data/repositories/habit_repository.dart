// lib/data/repositories/habit_repository.dart
import '../../domain/entities/habit.dart';
import '../../domain/repositories/i_habit_repository.dart';
import '../datasources/remote/habit_remote_datasource.dart';

class HabitRepository implements IHabitRepository {
  final HabitRemoteDataSource _remoteDataSource;

  static List<Habit> _mockHabits = [
    Habit(
      id: '1',
      name: 'Morning Meditation',
      description: 'Start the day with 10 minutes of mindfulness',
      cadence: HabitCadence.daily,
      block: HabitTimeBlock.morning,
      icon: 'brain',
      color: 0xFF6F4EE6,
      streak: 12,
      category: 'Mindfulness',
      createdAt: DateTime.now().subtract(const Duration(days: 30)),
    ),
    Habit(
      id: '2',
      name: 'Evening Run',
      description: 'Run 3km after work',
      cadence: HabitCadence.daily,
      block: HabitTimeBlock.evening,
      icon: 'running',
      color: 0xFFF97316,
      streak: 3,
      category: 'Fitness',
      createdAt: DateTime.now().subtract(const Duration(days: 14)),
    ),
    Habit(
      id: '3',
      name: 'Yoga',
      description: '15 minute yoga session',
      cadence: HabitCadence.daily,
      block: HabitTimeBlock.evening,
      icon: 'yoga',
      color: 0xFF22C55E,
      streak: 5,
      category: 'Health',
      createdAt: DateTime.now().subtract(const Duration(days: 20)),
    ),
    Habit(
      id: '4',
      name: 'Deep Work',
      description: '2 hours of focused work',
      cadence: HabitCadence.daily,
      block: HabitTimeBlock.afternoon,
      icon: 'target',
      color: 0xFF2563EB,
      streak: 2,
      category: 'Productivity',
      createdAt: DateTime.now().subtract(const Duration(days: 10)),
    ),
    Habit(
      id: '5',
      name: 'Read 30 Minutes',
      description: 'Read a book for 30 minutes',
      cadence: HabitCadence.daily,
      block: HabitTimeBlock.evening,
      icon: 'book',
      color: 0xFFEF4444,
      target: 30,
      progress: 15,
      streak: 8,
      category: 'Learning',
      createdAt: DateTime.now().subtract(const Duration(days: 25)),
    ),
    Habit(
      id: '6',
      name: 'Weekly Review',
      description: 'Review goals and progress',
      cadence: HabitCadence.weekly,
      block: HabitTimeBlock.morning,
      icon: 'chartBar',
      color: 0xFF8B5CF6,
      streak: 4,
      category: 'Productivity',
      createdAt: DateTime.now().subtract(const Duration(days: 21)),
    ),
  ];

  HabitRepository(this._remoteDataSource);

  @override
  Future<List<Habit>> getHabits() async {
    try {
      final models = await _remoteDataSource.getHabits();
      final remoteHabits = models.map((model) => model.toDomain()).toList();
      if (remoteHabits.isNotEmpty) {
        _mockHabits = remoteHabits;
      }
      return _mockHabits;
    } catch (_) {
      return List.unmodifiable(_mockHabits);
    }
  }

  @override
  Future<Habit> getHabit(String id) async {
    try {
      final model = await _remoteDataSource.getHabit(id);
      return model.toDomain();
    } catch (_) {
      final index = _mockHabits.indexWhere((h) => h.id == id);
      if (index != -1) {
        return _mockHabits[index];
      }
      return Habit(
        id: id,
        name: 'Habit $id',
        cadence: HabitCadence.daily,
        block: HabitTimeBlock.morning,
        icon: 'target',
        color: 0xFF6F4EE6,
        category: 'Productivity',
        createdAt: DateTime.now(),
      );
    }
  }

  @override
  Future<Habit> createHabit(CreateHabitParams params) async {
    try {
      final model = await _remoteDataSource.createHabit(params.toJson());
      final habit = model.toDomain();
      _mockHabits.add(habit);
      return habit;
    } catch (_) {
      final newHabit = Habit(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: params.name,
        description: params.description,
        cadence: params.cadence,
        block: params.block,
        icon: params.icon,
        color: params.color,
        target: params.target,
        category: params.category ?? 'Productivity',
        createdAt: DateTime.now(),
      );
      _mockHabits.add(newHabit);
      return newHabit;
    }
  }

  @override
  Future<Habit> updateHabit(String id, UpdateHabitParams params) async {
    try {
      final model = await _remoteDataSource.updateHabit(id, params.toJson());
      final updated = model.toDomain();
      final index = _mockHabits.indexWhere((h) => h.id == id);
      if (index != -1) {
        _mockHabits[index] = updated;
      }
      return updated;
    } catch (_) {
      final index = _mockHabits.indexWhere((h) => h.id == id);
      if (index != -1) {
        final existing = _mockHabits[index];
        final updated = existing.copyWith(
          name: params.name ?? existing.name,
          description: params.description ?? existing.description,
          cadence: params.cadence ?? existing.cadence,
          block: params.block ?? existing.block,
          icon: params.icon ?? existing.icon,
          color: params.color ?? existing.color,
          target: params.target ?? existing.target,
          category: params.category ?? existing.category,
          updatedAt: DateTime.now(),
        );
        _mockHabits[index] = updated;
        return updated;
      } else {
        final created = Habit(
          id: id,
          name: params.name ?? 'Habit',
          description: params.description,
          cadence: params.cadence ?? HabitCadence.daily,
          block: params.block ?? HabitTimeBlock.morning,
          icon: params.icon ?? 'target',
          color: params.color ?? 0xFF6F4EE6,
          target: params.target,
          category: params.category ?? 'Productivity',
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );
        _mockHabits.add(created);
        return created;
      }
    }
  }

  @override
  Future<void> deleteHabit(String id) async {
    try {
      await _remoteDataSource.deleteHabit(id);
    } catch (_) {}
    _mockHabits.removeWhere((h) => h.id == id);
  }

  @override
  Future<Habit> toggleHabit(String id) async {
    try {
      final model = await _remoteDataSource.toggleHabit(id);
      final habit = model.toDomain();
      final index = _mockHabits.indexWhere((h) => h.id == id);
      if (index != -1) {
        _mockHabits[index] = habit;
      }
      return habit;
    } catch (_) {
      final index = _mockHabits.indexWhere((h) => h.id == id);
      if (index != -1) {
        final h = _mockHabits[index];
        final toggled = h.copyWith(
          isCompleted: !h.isCompleted,
          streak: h.isCompleted ? (h.streak > 0 ? h.streak - 1 : 0) : h.streak + 1,
          updatedAt: DateTime.now(),
        );
        _mockHabits[index] = toggled;
        return toggled;
      }
      throw Exception('Habit not found');
    }
  }

  @override
  Future<HabitStats> getStats() async {
    try {
      final model = await _remoteDataSource.getStats();
      return model.toDomain();
    } catch (_) {
      final habits = _mockHabits;
      final completed = habits.where((h) => h.isCompleted).length;
      final daily = habits.where((h) => h.isDaily);
      final completedToday = daily.where((h) => h.isCompleted).length;
      final weekly = habits.where((h) => h.isWeekly);
      final weeklyCompleted = weekly.where((h) => h.isCompleted).length;
      final total = habits.length;
      final rate = total > 0 ? (completed / total) * 100 : 0.0;
      final streak = habits.fold(0, (max, h) => h.streak > max ? h.streak : max);

      return HabitStats(
        totalHabits: total,
        completedToday: completedToday,
        weeklyCompleted: weeklyCompleted,
        streak: streak,
        completionRate: rate,
      );
    }
  }

  @override
  Future<List<Habit>> getHabitsByBlock(HabitTimeBlock block) async {
    final allHabits = await getHabits();
    return allHabits.where((h) => h.block == block).toList();
  }

  @override
  Future<List<Habit>> getDailyHabits() async {
    final habits = await getHabits();
    return habits.where((h) => h.isDaily).toList();
  }

  @override
  Future<List<Habit>> getWeeklyHabits() async {
    final habits = await getHabits();
    return habits.where((h) => h.isWeekly).toList();
  }
}
