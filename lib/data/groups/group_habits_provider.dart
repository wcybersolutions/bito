import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'group_habit.dart';

class GroupHabitsNotifier extends StateNotifier<Map<String, List<GroupHabit>>> {
  GroupHabitsNotifier() : super(_initialSampleHabits());

  static Map<String, List<GroupHabit>> _initialSampleHabits() {
    final now = DateTime.now();
    return {
      '1': [
        GroupHabit(
          id: 'gh-1',
          groupId: '1',
          name: 'Yoga',
          description: '30 mins daily mobility & yoga',
          category: 'Health & Fitness',
          target: 1,
          targetUnit: 'Times',
          icon: 'barbell',
          color: 0xFFEF4444, // Red / warm tone like Figma
          selectedDays: const ['M', 'T', 'W', 'T', 'F', 'S', 'S'],
          requireForAll: true,
          hasReminder: false,
          createdBy: 'JOHN',
          adoptedBy: const ['user1'],
          isAdopted: true,
          createdAt: now.subtract(const Duration(days: 3)),
        ),
        GroupHabit(
          id: 'gh-2',
          groupId: '1',
          name: 'Morning run',
          description: 'Run at least 2km every morning',
          category: 'Health & Fitness',
          target: 2,
          targetUnit: 'km',
          icon: 'sneakerMove',
          color: 0xFF3B82F6, // Blue tone like Figma
          selectedDays: const ['M', 'T', 'W', 'T', 'F', 'S', 'S'],
          requireForAll: false,
          hasReminder: true,
          createdBy: 'JOHN',
          adoptedBy: const [],
          isAdopted: false,
          createdAt: now.subtract(const Duration(days: 2)),
        ),
      ],
    };
  }

  List<GroupHabit> getHabitsForGroup(String groupId) {
    return state[groupId] ?? [];
  }

  void addHabit(GroupHabit habit) {
    final currentList = List<GroupHabit>.from(state[habit.groupId] ?? []);
    currentList.add(habit);
    state = {
      ...state,
      habit.groupId: currentList,
    };
  }

  void toggleAdopt(String groupId, String habitId) {
    final currentList = List<GroupHabit>.from(state[groupId] ?? []);
    final index = currentList.indexWhere((h) => h.id == habitId);
    if (index != -1) {
      final habit = currentList[index];
      final newAdopted = !habit.isAdopted;
      currentList[index] = habit.copyWith(
        isAdopted: newAdopted,
        adoptedBy: newAdopted
            ? [...habit.adoptedBy, 'user1']
            : habit.adoptedBy.where((u) => u != 'user1').toList(),
      );
      state = {
        ...state,
        groupId: currentList,
      };
    }
  }
}

final groupHabitsProvider =
    StateNotifierProvider<GroupHabitsNotifier, Map<String, List<GroupHabit>>>((ref) {
  return GroupHabitsNotifier();
});

final groupHabitsListProvider =
    Provider.family<List<GroupHabit>, String>((ref, groupId) {
  final allHabits = ref.watch(groupHabitsProvider);
  return allHabits[groupId] ?? [];
});
