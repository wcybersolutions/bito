import 'group.dart';
import 'package:flutter/material.dart';


class GroupsRepository {
  static List<Group> _groups = [];

  GroupsRepository() {
    if (_groups.isEmpty) {
      _groups = _getSampleGroups();
    }
  }

  Future<List<Group>> getGroups() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _groups;
  }

  Future<Group> getGroup(String id) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return _groups.firstWhere((g) => g.id == id);
  }

  Future<Group> createGroup(Group group) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _groups.insert(0, group);
    return group;
  }

  Future<Group> updateGroup(Group group) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final index = _groups.indexWhere((g) => g.id == group.id);
    if (index != -1) {
      _groups[index] = group;
    }
    return group;
  }

  Future<void> deleteGroup(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _groups.removeWhere((g) => g.id == id);
  }

  Future<String> generateInviteCode(String groupId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    // Generate a random 6-character code
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final code = List.generate(6, (_) => chars[DateTime.now().millisecondsSinceEpoch % chars.length]).join();
    return code;
  }

  Future<Group> joinGroup(String inviteCode) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final group = _groups.firstWhere((g) => g.inviteCode == inviteCode);
    final updated = group.copyWith(
      memberCount: group.memberCount + 1,
      updatedAt: DateTime.now(),
    );
    final index = _groups.indexWhere((g) => g.id == group.id);
    if (index != -1) {
      _groups[index] = updated;
    }
    return updated;
  }

  List<Group> _getSampleGroups() {
    final now = DateTime.now();
    return [
      Group(
        id: '1',
        name: 'Morning Grind',
        description: 'Morning run group',
        type: GroupType.team,
        intensity: GroupIntensity.accountable,
        color: const Color(0xFF6F4EE6),
        isPrivate: true,
        feedEvents: true,
        missedDays: true,
        nudges: true,
        leaderboard: true,
        inviteCode: 'ABC123',
        memberCount: 2,
        createdAt: now.subtract(const Duration(days: 7)),
      ),
    ];
  }
}
