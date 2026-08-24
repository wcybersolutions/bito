import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'group.dart';
import 'groups_repository.dart';

final groupsRepositoryProvider = Provider<GroupsRepository>((ref) {
  return GroupsRepository();
});

final groupsProvider = FutureProvider<List<Group>>((ref) async {
  final repository = ref.read(groupsRepositoryProvider);
  return repository.getGroups();
});

final groupProvider = FutureProvider.family<Group, String>((ref, id) async {
  final repository = ref.read(groupsRepositoryProvider);
  return repository.getGroup(id);
});

class GroupCreationNotifier extends StateNotifier<Group?> {
  final GroupsRepository _repository;

  GroupCreationNotifier(this._repository) : super(null);

  Future<Group> createGroup(Group group) async {
    final created = await _repository.createGroup(group);
    state = created;
    return created;
  }

  Future<Group> updateGroup(Group group) async {
    final updated = await _repository.updateGroup(group);
    state = updated;
    return updated;
  }

  Future<void> deleteGroup(String id) async {
    await _repository.deleteGroup(id);
    state = null;
  }

  Future<String> generateInviteCode(String groupId) async {
    return await _repository.generateInviteCode(groupId);
  }

  Future<Group> joinGroup(String inviteCode) async {
    final group = await _repository.joinGroup(inviteCode);
    state = group;
    return group;
  }
}

final groupCreationProvider = StateNotifierProvider<GroupCreationNotifier, Group?>((ref) {
  final repository = ref.read(groupsRepositoryProvider);
  return GroupCreationNotifier(repository);
});

