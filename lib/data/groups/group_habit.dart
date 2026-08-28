import 'package:flutter/material.dart';

class GroupHabit {
  final String id;
  final String groupId;
  final String name;
  final String? description;
  final String category;
  final int target;
  final String targetUnit;
  final String icon;
  final int color;
  final List<String> selectedDays;
  final bool requireForAll;
  final bool hasReminder;
  final TimeOfDay? reminderTime;
  final String createdBy;
  final List<String> adoptedBy;
  final bool isAdopted;
  final DateTime createdAt;

  const GroupHabit({
    required this.id,
    required this.groupId,
    required this.name,
    this.description,
    this.category = 'Health & Fitness',
    this.target = 1,
    this.targetUnit = 'Times',
    this.icon = 'barbell',
    this.color = 0xFF6F4EE6,
    this.selectedDays = const ['M', 'T', 'W', 'T', 'F', 'S', 'S'],
    this.requireForAll = false,
    this.hasReminder = false,
    this.reminderTime,
    this.createdBy = 'John',
    this.adoptedBy = const [],
    this.isAdopted = false,
    required this.createdAt,
  });

  GroupHabit copyWith({
    String? id,
    String? groupId,
    String? name,
    String? description,
    String? category,
    int? target,
    String? targetUnit,
    String? icon,
    int? color,
    List<String>? selectedDays,
    bool? requireForAll,
    bool? hasReminder,
    TimeOfDay? reminderTime,
    String? createdBy,
    List<String>? adoptedBy,
    bool? isAdopted,
    DateTime? createdAt,
  }) {
    return GroupHabit(
      id: id ?? this.id,
      groupId: groupId ?? this.groupId,
      name: name ?? this.name,
      description: description ?? this.description,
      category: category ?? this.category,
      target: target ?? this.target,
      targetUnit: targetUnit ?? this.targetUnit,
      icon: icon ?? this.icon,
      color: color ?? this.color,
      selectedDays: selectedDays ?? this.selectedDays,
      requireForAll: requireForAll ?? this.requireForAll,
      hasReminder: hasReminder ?? this.hasReminder,
      reminderTime: reminderTime ?? this.reminderTime,
      createdBy: createdBy ?? this.createdBy,
      adoptedBy: adoptedBy ?? this.adoptedBy,
      isAdopted: isAdopted ?? this.isAdopted,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
