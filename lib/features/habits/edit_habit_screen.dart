// lib/features/habits/edit_habit_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../theme/theme_extensions.dart';
import '../../shared/shared.dart';
import '../../domain/entities/habit.dart';
import '../../data/providers/habit_provider.dart';
import '../../data/providers/habit_creation_provider.dart';
import 'create_habit_step1.dart';
import 'create_habit_step2.dart';
import 'create_habit_step3.dart';
import 'create_habit_step4.dart';

class EditHabitScreen extends ConsumerStatefulWidget {
  final String habitId;

  const EditHabitScreen({
    super.key,
    required this.habitId,
  });

  @override
  ConsumerState<EditHabitScreen> createState() => _EditHabitScreenState();
}

class _EditHabitScreenState extends ConsumerState<EditHabitScreen> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadHabit();
  }

  Future<void> _loadHabit() async {
    try {
      final repository = ref.read(habitRepositoryProvider);
      final habit = await repository.getHabit(widget.habitId);

      if (mounted) {
        // Load habit into creation state
        ref.read(habitCreationProvider.notifier).loadHabitForEditing(habit);
        setState(() => _isLoading = false);
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading habit: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<BitoColorScheme>()!;

    if (_isLoading) {
      return Scaffold(
        backgroundColor: colors.bg,
        body: const Center(child: LoadingIndicator()),
      );
    }

    // Start from step 1 with editing mode
    return const CreateHabitStep1(isEditing: true);
  }
}
