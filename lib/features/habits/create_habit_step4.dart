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
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),
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
                    const SizedBox(height: 24),
                    _buildHabitSummary(context, colors, creationState),
                    const SizedBox(height: 24),
                    _buildReminderSection(context, colors),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
            _buildBottomActions(context),
          ],
        ),
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
        color: colors.surface,
        borderRadius: BorderRadius.circular(11),
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
                    fontSize: 11,
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
          const SizedBox(height: 16),
          GestureDetector(
            onTap: () async {
              await showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                enableDrag: true,
                barrierColor: Colors.black.withValues(alpha: 0.3),
                builder: (context) {
                  return Padding(
                    padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom,
                    ),
                    child: _DigitalTimePicker(
                      initialTime: _selectedTime,
                      onTimeSelected: (time) {
                        setState(() {
                          _selectedTime = time;
                          ref
                              .read(habitCreationProvider.notifier)
                              .updateReminderTime(time);
                        });
                      },
                    ),
                  );
                },
              );
            },
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
              decoration: BoxDecoration(
                color: colors.surface,
                borderRadius: BorderRadius.circular(11),
                border: Border.all(color: colors.line),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        PhosphorIcons.clock(),
                        size: 20,
                        color: colors.ink2,
                      ),
                      const SizedBox(width: 12),
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
                        size: 16,
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: () => context.go('/habits'),
                    icon: Icon(
                      PhosphorIcons.arrowLeft(),
                      size: 20,
                      color: colors.ink,
                    ),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                  const SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.isEditing ? 'Edit • Tracker' : 'New Entry • Tracker',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: colors.ink3,
                          letterSpacing: 0.5,
                          fontFamily: 'SpaceMono',
                        ),
                      ),
                      Text(
                        'Habits',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: colors.ink,
                          letterSpacing: -0.5,
                        ),
                      ),
                    ],
                  ),
                ],
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
          const SizedBox(height: 8),
          _buildProgress(context),
        ],
      ),
    );
  }

  Widget _buildProgress(BuildContext context) {
    final colors = Theme.of(context).extension<BitoColorScheme>()!;
    final steps = ['WHAT', 'WHEN', 'STYLE', 'GO'];
    const activeStep = 3;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(steps.length, (index) {
        final isActive = index <= activeStep;
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 6),
          child: Column(
            children: [
              Container(
                width: 28,
                height: isActive ? 3 : 2,
                decoration: BoxDecoration(
                  color: isActive ? colors.signal2 : colors.line2,
                  borderRadius: BorderRadius.circular(1.5),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                steps[index],
                style: TextStyle(
                  fontSize: 8,
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
    );
  }

  Widget _buildBottomActions(BuildContext context) {
    final colors = Theme.of(context).extension<BitoColorScheme>()!;

    return Container(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
      decoration: BoxDecoration(
        color: colors.bg,
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

// ============================================================
// Digital Time Picker - Small Floating Card
// ============================================================

class _DigitalTimePicker extends StatefulWidget {
  final TimeOfDay initialTime;
  final ValueChanged<TimeOfDay> onTimeSelected;

  const _DigitalTimePicker({
    required this.initialTime,
    required this.onTimeSelected,
  });

  @override
  State<_DigitalTimePicker> createState() => _DigitalTimePickerState();
}

class _DigitalTimePickerState extends State<_DigitalTimePicker> {
  late int _hour;
  late int _minute;
  late bool _isAM;

  @override
  void initState() {
    super.initState();
    _hour = widget.initialTime.hour;
    _minute = widget.initialTime.minute;
    _isAM = _hour < 12;
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<BitoColorScheme>()!;
    final screenWidth = MediaQuery.of(context).size.width;

    return Center(
      child: Container(
        width: screenWidth * 0.85,
        constraints: const BoxConstraints(maxWidth: 360), // Fixed: use constraints
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: colors.line, width: 0.5),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar
            Container(
              width: 36,
              height: 4,
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: colors.line2,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: Text(
                    'Cancel',
                    style: TextStyle(
                      fontSize: 13,
                      color: colors.ink3,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Text(
                  'Select Time',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: colors.ink,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    widget.onTimeSelected(TimeOfDay(hour: _hour, minute: _minute));
                    Navigator.pop(context);
                  },
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: Text(
                    'Done',
                    style: TextStyle(
                      fontSize: 13,
                      color: colors.signal,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            // Digital time display - Compact
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Hour
                _buildCompactNumberPicker(
                  value: _hour,
                  min: 0,
                  max: 23,
                  onChanged: (value) {
                    setState(() {
                      _hour = value;
                      _isAM = _hour < 12;
                    });
                  },
                  showHourFormat: true,
                ),
                const SizedBox(width: 4),
                Text(
                  ':',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                    color: colors.ink,
                  ),
                ),
                const SizedBox(width: 4),
                // Minute
                _buildCompactNumberPicker(
                  value: _minute,
                  min: 0,
                  max: 59,
                  onChanged: (value) {
                    setState(() {
                      _minute = value;
                    });
                  },
                  showHourFormat: false,
                ),
                const SizedBox(width: 12),
                // AM/PM toggle - Compact
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildAMPMButton(
                      label: 'AM',
                      isSelected: _isAM,
                      onTap: () {
                        setState(() {
                          if (_hour >= 12 && !_isAM) {
                            _hour -= 12;
                          }
                          _isAM = true;
                        });
                      },
                    ),
                    const SizedBox(height: 4),
                    _buildAMPMButton(
                      label: 'PM',
                      isSelected: !_isAM,
                      onTap: () {
                        setState(() {
                          if (_hour < 12 && _isAM) {
                            _hour += 12;
                          }
                          _isAM = false;
                        });
                      },
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Widget _buildAMPMButton({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    final colors = Theme.of(context).extension<BitoColorScheme>()!;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 26,
        decoration: BoxDecoration(
          color: isSelected ? colors.signal : colors.surface2,
          borderRadius: BorderRadius.circular(6),
          border: isSelected
              ? null
              : Border.all(color: colors.line2, width: 0.5),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: isSelected ? colors.signalInk : colors.ink3,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCompactNumberPicker({
    required int value,
    required int min,
    required int max,
    required ValueChanged<int> onChanged,
    bool showHourFormat = false,
  }) {
    final colors = Theme.of(context).extension<BitoColorScheme>()!;

    return Container(
      height: 100,
      width: 44,
      decoration: BoxDecoration(
        color: colors.bg,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: colors.line2, width: 0.5),
      ),
      child: ListWheelScrollView(
        itemExtent: 28,
        diameterRatio: 1.2,
        perspective: 0.005,
        offAxisFraction: 0,
        children: List.generate(max - min + 1, (index) {
          final number = min + index;
          final isSelected = number == value;
          final displayNumber = showHourFormat
              ? (number == 0 ? 12 : (number > 12 ? number - 12 : number))
              : number;
          return Center(
            child: Text(
              displayNumber.toString().padLeft(2, '0'),
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: isSelected ? colors.signal : colors.ink3,
              ),
            ),
          );
        }),
        onSelectedItemChanged: (index) {
          final newValue = min + index;
          if (newValue != value) {
            onChanged(newValue);
          }
        },
        controller: FixedExtentScrollController(
          initialItem: value - min,
        ),
      ),
    );
  }
}