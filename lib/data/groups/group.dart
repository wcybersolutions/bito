import 'package:flutter/material.dart';
import "package:phosphor_flutter/phosphor_flutter.dart";

enum GroupType {
  personal,
  team,
  family,
  fitness,
  study,
  community,
}

extension GroupTypeExtension on GroupType {
  String get label {
    switch (this) {
      case GroupType.personal:
        return 'PERSONAL';
      case GroupType.team:
        return 'TEAM';
      case GroupType.family:
        return 'FAMILY';
      case GroupType.fitness:
        return 'FITNESS';
      case GroupType.study:
        return 'STUDY';
      case GroupType.community:
        return 'COMMUNITY';
    }
  }

  IconData get icon {
    switch (this) {
      case GroupType.personal:
        return PhosphorIcons.user();
      case GroupType.team:
        return PhosphorIcons.users();
      case GroupType.family:
        return PhosphorIcons.house();
      case GroupType.fitness:
        return PhosphorIcons.barbell();
      case GroupType.study:
        return PhosphorIcons.bookOpen();
      case GroupType.community:
        return PhosphorIcons.globe();
    }
  }
}

enum GroupIntensity {
  supportive,
  accountable,
  sharp,
}

extension GroupIntensityExtension on GroupIntensity {
  String get label {
    switch (this) {
      case GroupIntensity.supportive:
        return 'SUPPORTIVE';
      case GroupIntensity.accountable:
        return 'ACCOUNTABLE';
      case GroupIntensity.sharp:
        return 'SHARP';
    }
  }

  String get description {
    switch (this) {
      case GroupIntensity.supportive:
        return 'The gentlest mode. Encouragement-first, no pressure.';
      case GroupIntensity.accountable:
        return 'The default. Honest visibility without public shaming.';
      case GroupIntensity.sharp:
        return 'Maximum accountability. All data is public.';
    }
  }

  String get feedEvents {
    switch (this) {
      case GroupIntensity.supportive:
        return 'Completions only';
      case GroupIntensity.accountable:
        return 'Completions, milestones, streak-at-risk';
      case GroupIntensity.sharp:
        return 'All events including missed days';
    }
  }

  String get missedDays {
    switch (this) {
      case GroupIntensity.supportive:
        return 'Hidden from everyone';
      case GroupIntensity.accountable:
        return 'Visible on your member dashboard only';
      case GroupIntensity.sharp:
        return 'Public in feed and leaderboard';
    }
  }

  String get nudges {
    switch (this) {
      case GroupIntensity.supportive:
        return '1 per sender per recipient per day';
      case GroupIntensity.accountable:
        return '1 per sender per recipient per day';
      case GroupIntensity.sharp:
        return 'Unlimited';
    }
  }

  String get leaderboard {
    switch (this) {
      case GroupIntensity.supportive:
        return 'Anonymous, opt-in';
      case GroupIntensity.accountable:
        return 'Named, members can opt out';
      case GroupIntensity.sharp:
        return 'Mandatory, fully named';
    }
  }
}

class Group {
  final String id;
  final String name;
  final String? description;
  final GroupType type;
  final GroupIntensity intensity;
  final Color color;
  final bool isPrivate;
  final bool feedEvents;
  final bool missedDays;
  final bool nudges;
  final bool leaderboard;
  final String? inviteCode;
  final int memberCount;
  final DateTime createdAt;
  final DateTime? updatedAt;

  Group({
    required this.id,
    required this.name,
    this.description,
    required this.type,
    required this.intensity,
    required this.color,
    this.isPrivate = true,
    this.feedEvents = true,
    this.missedDays = true,
    this.nudges = true,
    this.leaderboard = true,
    this.inviteCode,
    this.memberCount = 1,
    required this.createdAt,
    this.updatedAt,
  });

  Group copyWith({
    String? id,
    String? name,
    String? description,
    GroupType? type,
    GroupIntensity? intensity,
    Color? color,
    bool? isPrivate,
    bool? feedEvents,
    bool? missedDays,
    bool? nudges,
    bool? leaderboard,
    String? inviteCode,
    int? memberCount,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Group(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      type: type ?? this.type,
      intensity: intensity ?? this.intensity,
      color: color ?? this.color,
      isPrivate: isPrivate ?? this.isPrivate,
      feedEvents: feedEvents ?? this.feedEvents,
      missedDays: missedDays ?? this.missedDays,
      nudges: nudges ?? this.nudges,
      leaderboard: leaderboard ?? this.leaderboard,
      inviteCode: inviteCode ?? this.inviteCode,
      memberCount: memberCount ?? this.memberCount,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  factory Group.fromJson(Map<String, dynamic> json) {
    return Group(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      type: GroupType.values.firstWhere(
            (e) => e.toString() == json['type'],
      ),
      intensity: GroupIntensity.values.firstWhere(
            (e) => e.toString() == json['intensity'],
      ),
      color: Color(json['color']),
      isPrivate: json['isPrivate'] ?? true,
      feedEvents: json['feedEvents'] ?? true,
      missedDays: json['missedDays'] ?? true,
      nudges: json['nudges'] ?? true,
      leaderboard: json['leaderboard'] ?? true,
      inviteCode: json['inviteCode'],
      memberCount: json['memberCount'] ?? 1,
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'type': type.toString(),
      'intensity': intensity.toString(),
      'color': color.value,
      'isPrivate': isPrivate,
      'feedEvents': feedEvents,
      'missedDays': missedDays,
      'nudges': nudges,
      'leaderboard': leaderboard,
      'inviteCode': inviteCode,
      'memberCount': memberCount,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }
}
