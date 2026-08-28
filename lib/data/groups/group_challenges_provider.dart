// lib/data/groups/group_challenges_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bito/data/groups/group_challenge.dart';

class GroupChallengesNotifier
    extends StateNotifier<Map<String, List<GroupChallenge>>> {
  GroupChallengesNotifier() : super({});

  void addChallenge(String groupId, GroupChallenge challenge) {
    final current = state[groupId] ?? [];
    state = {
      ...state,
      groupId: [challenge, ...current],
    };
  }

  void toggleJoin(String groupId, String challengeId) {
    final current = state[groupId] ?? [];
    final updated = current.map((c) {
      if (c.id == challengeId) {
        final newJoined = !c.isJoined;
        return c.copyWith(
          isJoined: newJoined,
          totalParticipants:
              newJoined ? c.totalParticipants + 1 : c.totalParticipants - 1,
        );
      }
      return c;
    }).toList();

    state = {
      ...state,
      groupId: updated,
    };
  }
}

final groupChallengesProvider = StateNotifierProvider<
    GroupChallengesNotifier,
    Map<String, List<GroupChallenge>>>(
  (ref) => GroupChallengesNotifier(),
);

final groupChallengesListProvider =
    Provider.family<List<GroupChallenge>, String>((ref, groupId) {
  final map = ref.watch(groupChallengesProvider);
  return map[groupId] ?? [];
});
