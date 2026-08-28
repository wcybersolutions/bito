import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'group.dart';
import 'groups_repository.dart';

class GroupDraftState {
  final String name;
  final String description;
  final GroupType type;
  final Color color;
  final bool isPrivate;
  final GroupIntensity intensity;

  const GroupDraftState({
    this.name = '',
    this.description = '',
    this.type = GroupType.personal,
    this.color = const Color(0xFF6F4EE6),
    this.isPrivate = true,
    this.intensity = GroupIntensity.supportive,
  });

  GroupDraftState copyWith({
    String? name,
    String? description,
    GroupType? type,
    Color? color,
    bool? isPrivate,
    GroupIntensity? intensity,
  }) {
    return GroupDraftState(
      name: name ?? this.name,
      description: description ?? this.description,
      type: type ?? this.type,
      color: color ?? this.color,
      isPrivate: isPrivate ?? this.isPrivate,
      intensity: intensity ?? this.intensity,
    );
  }
}

class GroupDraftNotifier extends StateNotifier<GroupDraftState> {
  GroupDraftNotifier() : super(const GroupDraftState());

  void updateName(String name) => state = state.copyWith(name: name);
  void updateDescription(String desc) => state = state.copyWith(description: desc);
  void updateType(GroupType type) => state = state.copyWith(type: type);
  void updateColor(Color color) => state = state.copyWith(color: color);
  void updatePrivate(bool isPrivate) => state = state.copyWith(isPrivate: isPrivate);
  void updateIntensity(GroupIntensity intensity) => state = state.copyWith(intensity: intensity);

  void reset() => state = const GroupDraftState();
}

final groupDraftProvider =
    StateNotifierProvider<GroupDraftNotifier, GroupDraftState>((ref) {
  return GroupDraftNotifier();
});

final groupsRepositoryProvider = Provider<GroupsRepository>((ref) {
  return GroupsRepository();
});

class GroupsListNotifier extends StateNotifier<AsyncValue<List<Group>>> {
  final GroupsRepository _repository;

  GroupsListNotifier(this._repository) : super(const AsyncValue.loading()) {
    loadGroups();
  }

  Future<void> loadGroups() async {
    try {
      final groups = await _repository.getGroups();
      state = AsyncValue.data(List<Group>.from(groups));
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<Group> createGroup(Group group) async {
    final created = await _repository.createGroup(group);
    await loadGroups();
    return created;
  }
}

final groupsProvider =
    StateNotifierProvider<GroupsListNotifier, AsyncValue<List<Group>>>((ref) {
  final repository = ref.read(groupsRepositoryProvider);
  return GroupsListNotifier(repository);
});

final groupProvider = FutureProvider.family<Group, String>((ref, id) async {
  final repository = ref.read(groupsRepositoryProvider);
  return repository.getGroup(id);
});

class GroupCreationNotifier extends StateNotifier<Group?> {
  final Ref _ref;

  GroupCreationNotifier(this._ref) : super(null);

  Future<Group> createGroup(Group group) async {
    final groupsNotifier = _ref.read(groupsProvider.notifier);
    final created = await groupsNotifier.createGroup(group);
    state = created;
    return created;
  }

  Future<Group> updateGroup(Group group) async {
    final repository = _ref.read(groupsRepositoryProvider);
    final updated = await repository.updateGroup(group);
    await _ref.read(groupsProvider.notifier).loadGroups();
    state = updated;
    return updated;
  }

  Future<void> deleteGroup(String id) async {
    final repository = _ref.read(groupsRepositoryProvider);
    await repository.deleteGroup(id);
    await _ref.read(groupsProvider.notifier).loadGroups();
    state = null;
  }

  Future<String> generateInviteCode(String groupId) async {
    final repository = _ref.read(groupsRepositoryProvider);
    return await repository.generateInviteCode(groupId);
  }

  Future<Group> joinGroup(String inviteCode) async {
    final repository = _ref.read(groupsRepositoryProvider);
    final group = await repository.joinGroup(inviteCode);
    await _ref.read(groupsProvider.notifier).loadGroups();
    state = group;
    return group;
  }
}

final groupCreationProvider =
    StateNotifierProvider<GroupCreationNotifier, Group?>((ref) {
  return GroupCreationNotifier(ref);
});
