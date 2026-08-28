// lib/data/groups/group_challenge.dart

enum ChallengeType {
  streak,
  cumulative,
  consistency,
  teamGoal;

  String get label {
    switch (this) {
      case ChallengeType.streak:
        return 'Streak';
      case ChallengeType.cumulative:
        return 'Cumulative';
      case ChallengeType.consistency:
        return 'Consistency';
      case ChallengeType.teamGoal:
        return 'Team Goal';
    }
  }

  String get sublabel {
    switch (this) {
      case ChallengeType.streak:
        return 'MAINTAIN CONSECUTIVE DAYS';
      case ChallengeType.cumulative:
        return 'REACH A TOTAL TARGET';
      case ChallengeType.consistency:
        return 'HIT A COMPLETION-RATE %';
      case ChallengeType.teamGoal:
        return 'GROUP WORKS TOWARD ONE TOTAL';
    }
  }

  String get aiDescription {
    switch (this) {
      case ChallengeType.streak:
        return 'With perfect completion on daily health habits, a two-week streak challenge will push you to keep that momentum going.';
      case ChallengeType.cumulative:
        return 'Target a total milestone together to build collective consistency over time.';
      case ChallengeType.consistency:
        return "Since you're nailing daily completions, aiming for 90% consistency over a month is a solid way to stay sharp.";
      case ChallengeType.teamGoal:
        return 'Every member contributes completions to hit a combined team goal.';
    }
  }
}

class GroupChallenge {
  final String id;
  final String groupId;
  final String title;
  final String description;
  final ChallengeType type;
  final int targetValue;
  final String unit;
  final String? linkedHabit;
  final String? habitSlot;
  final String matchMode;
  final bool allowLateJoin;
  final bool showLeaderboard;
  final int? maxParticipants;
  final int currentProgress;
  final int totalParticipants;
  final bool isJoined;
  final DateTime createdAt;
  final DateTime endDate;

  const GroupChallenge({
    required this.id,
    required this.groupId,
    required this.title,
    required this.description,
    required this.type,
    required this.targetValue,
    required this.unit,
    this.linkedHabit,
    this.habitSlot,
    this.matchMode = 'Single — one habit tracks progress',
    this.allowLateJoin = true,
    this.showLeaderboard = true,
    this.maxParticipants,
    this.currentProgress = 0,
    this.totalParticipants = 1,
    this.isJoined = true,
    required this.createdAt,
    required this.endDate,
  });

  GroupChallenge copyWith({
    String? id,
    String? groupId,
    String? title,
    String? description,
    ChallengeType? type,
    int? targetValue,
    String? unit,
    String? linkedHabit,
    String? habitSlot,
    String? matchMode,
    bool? allowLateJoin,
    bool? showLeaderboard,
    int? maxParticipants,
    int? currentProgress,
    int? totalParticipants,
    bool? isJoined,
    DateTime? createdAt,
    DateTime? endDate,
  }) {
    return GroupChallenge(
      id: id ?? this.id,
      groupId: groupId ?? this.groupId,
      title: title ?? this.title,
      description: description ?? this.description,
      type: type ?? this.type,
      targetValue: targetValue ?? this.targetValue,
      unit: unit ?? this.unit,
      linkedHabit: linkedHabit ?? this.linkedHabit,
      habitSlot: habitSlot ?? this.habitSlot,
      matchMode: matchMode ?? this.matchMode,
      allowLateJoin: allowLateJoin ?? this.allowLateJoin,
      showLeaderboard: showLeaderboard ?? this.showLeaderboard,
      maxParticipants: maxParticipants ?? this.maxParticipants,
      currentProgress: currentProgress ?? this.currentProgress,
      totalParticipants: totalParticipants ?? this.totalParticipants,
      isJoined: isJoined ?? this.isJoined,
      createdAt: createdAt ?? this.createdAt,
      endDate: endDate ?? this.endDate,
    );
  }
}
