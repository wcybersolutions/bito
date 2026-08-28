// lib/features/habits/create_habit_step4.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:go_router/go_router.dart';

import '../../shared/shared.dart';
import '../../data/providers/habit_creation_provider.dart';
import '../../data/providers/habit_provider.dart';
import '../../domain/entities/habit.dart';
import '../../domain/repositories/i_habit_repository.dart';

class CreateHabitStep4 extends ConsumerStatefulWidget {
  final bool isEditing;

  const CreateHabitStep4({
    super.key,
    this.isEditing = false,
  });

  @override
  ConsumerState<CreateHabitStep4> createState() => _CreateHabitStep4State();
}

class _CreateHabitStep4State extends ConsumerState<CreateHabitStep4> {
  bool _hasReminder = true;
  TimeOfDay _selectedTime = const TimeOfDay(hour: 8, minute: 0);
  bool _isCreating = false;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<BitoColorScheme>()!;
    final textTheme = Theme.of(context).textTheme;
    final creationState = ref.watch(habitCreationProvider);

    return Scaffold(
      backgroundColor: colors.bg,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  decoration: BoxDecoration(
                    color: colors.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: colors.line),
                  ),
                  child: Column(
                    children: [
                      _buildCardHeader(context, colors, textTheme),
                      _buildProgress(context),
                      Expanded(
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Looking good!',
                                style: textTheme.headlineSmall?.copyWith(
                                  color: colors.ink,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                widget.isEditing
                                    ? 'Review your changes and save'
                                    : 'Confirm your habit and set a reminder if you\'d like.',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: colors.ink2,
                                ),
                              ),
                              const SizedBox(height: 16),
                              _buildHabitSummary(context, colors, creationState),
                              const SizedBox(height: 16),
                              _buildReminderSection(context, colors),
                            ],
                          ),
                        ),
                      ),
                      _buildBottomActions(context),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCardHeader(
      BuildContext context,
      BitoColorScheme colors,
      TextTheme textTheme,
      ) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            widget.isEditing ? 'Edit Habit' : 'New Habit',
            style: textTheme.headlineSmall?.copyWith(
              color: colors.ink,
            ),
          ),
          IconButton(
            onPressed: () => context.go('/habits'),
            icon: Icon(
              PhosphorIcons.x(),
              size: 20,
              color: colors.ink2,
            ),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }

  Widget _buildHabitSummary(
      BuildContext context,
      BitoColorScheme colors,
      HabitCreationState state,
      ) {
    final color = Color(state.color);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.surface2,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: colors.line),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  _getIconData(state.icon),
                  size: 22,
                  color: color,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      state.name.isEmpty ? 'Habit name' : state.name,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: colors.ink,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        Icon(
                          PhosphorIcons.clock(),
                          size: 12,
                          color: colors.ink3,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          state.cadence == HabitCadence.daily
                              ? 'Every day'
                              : 'Weekly',
                          style: TextStyle(
                            fontSize: 12,
                            color: colors.ink2,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (state.description != null && state.description!.isNotEmpty) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: colors.bg,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                state.description!,
                style: TextStyle(
                  fontSize: 13,
                  color: colors.ink2,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildReminderSection(
      BuildContext context,
      BitoColorScheme colors,
      ) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'REMINDER',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: colors.ink3,
                    letterSpacing: 1.2,
                    fontFamily: 'SpaceMono',
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Get a nudge at the right time',
                  style: TextStyle(
                    fontSize: 13,
                    color: colors.ink2,
                  ),
                ),
              ],
            ),
            Switch(
              value: _hasReminder,
              onChanged: (value) {
                setState(() {
                  _hasReminder = value;
                  ref.read(habitCreationProvider.notifier).updateReminder(value);
                });
              },
              activeThumbColor: colors.signal2,
              activeTrackColor: colors.signal2.withValues(alpha: 0.3),
            ),
          ],
        ),
        if (_hasReminder) ...[
          const SizedBox(height: 12),
          GestureDetector(
            onTap: () async {
              final picked = await DigitalTimePicker.show(
                context,
                initialTime: _selectedTime,
              );
              if (picked != null) {
                setState(() {
                  _selectedTime = picked;
                  ref
                      .read(habitCreationProvider.notifier)
                      .updateReminderTime(picked);
                });
              }
            },
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
              decoration: BoxDecoration(
                color: colors.surface,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: colors.line),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        PhosphorIcons.clock(),
                        size: 18,
                        color: colors.ink2,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        'Reminder time',
                        style: TextStyle(
                          fontSize: 14,
                          color: colors.ink,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        _selectedTime.format(context),
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: colors.signal2,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Icon(
                        PhosphorIcons.caretDown(),
                        size: 14,
                        color: colors.ink3,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }

  IconData _getIconData(String iconName) {
    switch (iconName) {
      case 'target':
        return PhosphorIcons.target();
      case 'barbell':
        return PhosphorIcons.barbell();
      case 'heart':
        return PhosphorIcons.heart();
      case 'book':
        return PhosphorIcons.book();
      case 'coffee':
        return PhosphorIcons.coffee();
      case 'brain':
        return PhosphorIcons.brain();
      case 'running':
        return PhosphorIcons.personSimpleRun();
      case 'bicycle':
        return PhosphorIcons.bicycle();
      case 'swimming':
        return PhosphorIcons.personSimpleSwim();
      case 'walking':
        return PhosphorIcons.personSimpleWalk();
      case 'yoga':
        return PhosphorIcons.personSimpleTaiChi();
      case 'apple':
        return PhosphorIcons.appleLogo();
      case 'drop':
        return PhosphorIcons.drop();
      case 'lightbulb':
        return PhosphorIcons.lightbulb();
      case 'smiley':
        return PhosphorIcons.smiley();
      case 'clock':
        return PhosphorIcons.clock();
      case 'calendar':
        return PhosphorIcons.calendar();
      case 'checkSquare':
        return PhosphorIcons.checkSquare();
      case 'list':
        return PhosphorIcons.list();
      case 'chartBar':
        return PhosphorIcons.chartBar();
      case 'house':
        return PhosphorIcons.house();
      case 'musicNotes':
        return PhosphorIcons.musicNotes();
      case 'camera':
        return PhosphorIcons.camera();
      case 'palette':
        return PhosphorIcons.palette();
      case 'globe':
        return PhosphorIcons.globe();
      case 'moon':
        return PhosphorIcons.moon();
      case 'bed':
        return PhosphorIcons.bed();
      case 'star':
        return PhosphorIcons.star();
      case 'sun':
        return PhosphorIcons.sun();
      case 'cloud':
        return PhosphorIcons.cloud();
      default:
        return PhosphorIcons.target();
    }
  }

  Widget _buildHeader(BuildContext context) {
    final colors = Theme.of(context).extension<BitoColorScheme>()!;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'HABIT SETUP',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: colors.ink3,
              letterSpacing: 1.2,
              fontFamily: 'SpaceMono',
            ),
          ),
          const SizedBox(),
        ],
      ),
    );
  }

  Widget _buildProgress(BuildContext context) {
    final colors = Theme.of(context).extension<BitoColorScheme>()!;
    final steps = ['WHAT', 'WHEN', 'STYLE', 'GO'];
    const activeStep = 3;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(steps.length, (index) {
          final isActive = index <= activeStep;
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 4),
            child: Column(
              children: [
                Container(
                  width: 60,
                  height: 3,
                  decoration: BoxDecoration(
                    color: isActive ? colors.signal2 : colors.line2,
                    borderRadius: BorderRadius.circular(1.5),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  steps[index],
                  style: TextStyle(
                    fontSize: 7,
                    fontWeight: FontWeight.w700,
                    color: isActive ? colors.signal2 : colors.ink3,
                    letterSpacing: 0.5,
                    fontFamily: 'SpaceMono',
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildBottomActions(BuildContext context) {
    final colors = Theme.of(context).extension<BitoColorScheme>()!;

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: colors.line),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ActionButton(
            text: 'BACK',
            type: ButtonType.outline,
            icon: Icon(
              PhosphorIcons.arrowLeft(),
              size: 16,
              color: colors.ink2,
            ),
            onPressed: () {
              final isEditing = widget.isEditing;
              context.go(isEditing
                  ? '/habits/edit/step3'
                  : '/habits/create/step3'
              );
            },
            expanded: false,
          ),
          ElevatedButton(
            onPressed: _isCreating ? null : () => _saveHabit(colors),
            style: ElevatedButton.styleFrom(
              backgroundColor: colors.signal2,
              foregroundColor: Colors.black,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(11),
              ),
              elevation: 0,
            ),
            child: _isCreating
                ? const SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.black,
              ),
            )
                : Row(
              children: [
                Icon(
                  PhosphorIcons.check(),
                  size: 16,
                  color: Colors.black,
                ),
                const SizedBox(width: 8),
                Text(
                  widget.isEditing ? 'SAVE CHANGES' : 'CREATE HABIT',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                    letterSpacing: 0.5,
                    fontFamily: 'SpaceMono',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _saveHabit(BitoColorScheme colors) async {
    if (!mounted) return;

    setState(() => _isCreating = true);

    final creationState = ref.read(habitCreationProvider);
    final params = CreateHabitParams(
      name: creationState.name,
      description: creationState.description,
      cadence: creationState.cadence,
      block: creationState.block,
      icon: creationState.icon,
      color: creationState.color,
      target: creationState.target,
      category: creationState.category,
    );

    try {
      if (widget.isEditing) {
        final updateParams = UpdateHabitParams(
          name: params.name,
          description: params.description,
          cadence: params.cadence,
          block: params.block,
          icon: params.icon,
          color: params.color,
          target: params.target,
          category: creationState.category,
        );
        final repository = ref.read(habitRepositoryProvider);
        await repository.updateHabit(creationState.id, updateParams);
      } else {
        final result = await ref.read(createHabitUseCaseProvider).execute(params);
        if (!result.isSuccess) {
          throw Exception(result.error);
        }
      }

      if (!mounted) return;

      ref.read(habitCreationProvider.notifier).reset();
      ref.invalidate(habitsProvider);
      context.go('/habits');
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: colors.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isCreating = false);
      }
    }
  }
}


