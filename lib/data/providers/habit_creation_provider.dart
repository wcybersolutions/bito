// lib/data/providers/habit_creation_provider.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/habit.dart';
import '../../domain/repositories/i_habit_repository.dart';

class HabitCreationState {
  final String id; // ← Added for editing
  final String name;
  final String? description;
  final HabitCadence cadence;
  final HabitTimeBlock block;
  final String icon;
  final int color;
  final int? target;
  final List<String> selectedDays;
  final bool hasReminder;
  final TimeOfDay? reminderTime;
  final String category;
  final bool isEditing; // ← Added to track edit mode

  const HabitCreationState({
    this.id = '',
    this.name = '',
    this.description,
    this.cadence = HabitCadence.daily,
    this.block = HabitTimeBlock.morning,
    this.icon = 'target',
    this.color = 0xFF6F4EE6,
    this.target,
    this.selectedDays = const [],
    this.hasReminder = false,
    this.reminderTime,
    this.category = 'Productivity',
    this.isEditing = false,
  });

  HabitCreationState copyWith({
    String? id,
    String? name,
    String? description,
    HabitCadence? cadence,
    HabitTimeBlock? block,
    String? icon,
    int? color,
    int? target, // ← Keep as int? not Null
    List<String>? selectedDays,
    bool? hasReminder,
    TimeOfDay? reminderTime,
    String? category,
    bool? isEditing,
  }) {
    return HabitCreationState(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      cadence: cadence ?? this.cadence,
      block: block ?? this.block,
      icon: icon ?? this.icon,
      color: color ?? this.color,
      target: target ?? this.target, // ← This handles null correctly
      selectedDays: selectedDays ?? this.selectedDays,
      hasReminder: hasReminder ?? this.hasReminder,
      reminderTime: reminderTime ?? this.reminderTime,
      category: category ?? this.category,
      isEditing: isEditing ?? this.isEditing,
    );
  }

  CreateHabitParams toParams() {
    return CreateHabitParams(
      name: name,
      description: description,
      cadence: cadence,
      block: block,
      icon: icon,
      color: color,
      target: target,
      category: category,
    );
  }

  // For editing - convert from Habit entity
  factory HabitCreationState.fromHabit(Habit habit) {
    // Map icon to icon name (you might need a reverse mapping)
    return HabitCreationState(
      id: habit.id,
      name: habit.name,
      description: habit.description,
      cadence: habit.cadence,
      block: habit.block,
      icon: habit.icon,
      color: habit.color,
      target: habit.target,
      category: habit.category ?? 'Productivity',
      isEditing: true,
    );
  }
}

class HabitCreationNotifier extends StateNotifier<HabitCreationState> {
  HabitCreationNotifier() : super(HabitCreationState());

  void loadHabitForEditing(Habit habit) {
    state = HabitCreationState.fromHabit(habit);
  }

  void updateName(String name) {
    state = state.copyWith(name: name);
  }

  void updateDescription(String description) {
    state = state.copyWith(description: description);
  }

  void updateCadence(HabitCadence cadence) {
    state = state.copyWith(cadence: cadence);
  }

  void updateBlock(HabitTimeBlock block) {
    state = state.copyWith(block: block);
  }

  void updateIcon(String icon) {
    state = state.copyWith(icon: icon);
  }

  void updateColor(int color) {
    state = state.copyWith(color: color);
  }

  void updateCategory(String category) {
    state = state.copyWith(category: category);
  }

  void updateTarget(int target) {
    state = state.copyWith(target: target);
  }

  void toggleDay(String day) {
    final days = List<String>.from(state.selectedDays);
    if (days.contains(day)) {
      days.remove(day);
    } else {
      days.add(day);
    }
    state = state.copyWith(selectedDays: days);
  }

  void updateReminder(bool hasReminder) {
    state = state.copyWith(hasReminder: hasReminder);
  }

  void updateReminderTime(TimeOfDay time) {
    state = state.copyWith(reminderTime: time);
  }

  void reset() {
    state = HabitCreationState();
  }

  void resetForEditing() {
    state = HabitCreationState(isEditing: false);
  }
}

final habitCreationProvider =
    StateNotifierProvider<HabitCreationNotifier, HabitCreationState>((ref) {
      return HabitCreationNotifier();
    });
