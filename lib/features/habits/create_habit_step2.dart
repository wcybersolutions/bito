// lib/features/habits/create_habit_step2.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:go_router/go_router.dart';

import '../../shared/shared.dart';
import '../../data/providers/habit_creation_provider.dart';
import '../../domain/entities/habit.dart';

class CreateHabitStep2 extends ConsumerStatefulWidget {
  final bool isEditing;

  const CreateHabitStep2({
    super.key,
    this.isEditing = false,
  });

  @override
  ConsumerState<CreateHabitStep2> createState() => _CreateHabitStep2State();
}

class _CreateHabitStep2State extends ConsumerState<CreateHabitStep2> {
  late String _frequency;
  late List<String> _selectedDays;
  late int _weeklyTarget;

  final List<Map<String, String>> _allDays = [
    {'label': 'M', 'value': 'Mon'},
    {'label': 'T', 'value': 'Tue'},
    {'label': 'W', 'value': 'Wed'},
    {'label': 'T', 'value': 'Thu'},
    {'label': 'F', 'value': 'Fri'},
    {'label': 'S', 'value': 'Sat'},
    {'label': 'S', 'value': 'Sun'},
  ];

  @override
  void initState() {
    super.initState();
    final state = ref.read(habitCreationProvider);
    _frequency = state.cadence == HabitCadence.daily ? 'Daily' : 'Weekly target';
    _selectedDays = state.selectedDays.isNotEmpty
        ? state.selectedDays
        : ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
    _weeklyTarget = state.target ?? 3;
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<BitoColorScheme>()!;
    final textTheme = Theme.of(context).textTheme;

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
                                'FREQUENCY',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                  color: colors.ink3,
                                  letterSpacing: 1.2,
                                  fontFamily: 'SpaceMono',
                                ),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  _buildFrequencyButton('Daily', _frequency == 'Daily'),
                                  const SizedBox(width: 12),
                                  _buildFrequencyButton('Weekly target', _frequency == 'Weekly target'),
                                ],
                              ),
                              const SizedBox(height: 16),

                              if (_frequency == 'Daily') ...[
                                Text(
                                  'WHICH DAYS?',
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w700,
                                    color: colors.ink3,
                                    letterSpacing: 1.2,
                                    fontFamily: 'SpaceMono',
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: _allDays.map((day) {
                                    final isSelected = _selectedDays.contains(day['value']);
                                    return GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          if (isSelected) {
                                            _selectedDays.remove(day['value']);
                                          } else {
                                            _selectedDays.add(day['value']!);
                                          }
                                        });
                                      },
                                      child: Container(
                                        width: 40,
                                        height: 40,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: isSelected ? colors.signal : colors.surface,
                                          border: isSelected
                                              ? null
                                              : Border.all(color: colors.line2),
                                        ),
                                        child: Center(
                                          child: Text(
                                            day['label']!,
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w700,
                                              color: isSelected ? colors.signalInk : colors.ink2,
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ],

                              if (_frequency == 'Weekly target') ...[
                                Text(
                                  'COMPLETE ON ANY',
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w700,
                                    color: colors.ink3,
                                    letterSpacing: 1.2,
                                    fontFamily: 'SpaceMono',
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: 44,
                                      height: 44,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(11),
                                        border: Border.all(color: colors.line),
                                        color: colors.surface,
                                      ),
                                      child: InkWell(
                                        onTap: () {
                                          setState(() {
                                            if (_weeklyTarget > 1) {
                                              _weeklyTarget--;
                                            }
                                          });
                                        },
                                        borderRadius: BorderRadius.circular(11),
                                        child: Center(
                                          child: Icon(
                                            PhosphorIcons.minus(),
                                            size: 20,
                                            color: _weeklyTarget > 1 ? colors.ink : colors.ink3,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 20),
                                    Text(
                                      '$_weeklyTarget',
                                      style: TextStyle(
                                        fontSize: 32,
                                        fontWeight: FontWeight.w700,
                                        color: colors.ink,
                                      ),
                                    ),
                                    const SizedBox(width: 20),
                                    Container(
                                      width: 44,
                                      height: 44,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(11),
                                        border: Border.all(color: colors.line),
                                        color: colors.surface,
                                      ),
                                      child: InkWell(
                                        onTap: () {
                                          setState(() {
                                            if (_weeklyTarget < 7) {
                                              _weeklyTarget++;
                                            }
                                          });
                                        },
                                        borderRadius: BorderRadius.circular(11),
                                        child: Center(
                                          child: Icon(
                                            PhosphorIcons.plus(),
                                            size: 20,
                                            color: _weeklyTarget < 7 ? colors.ink : colors.ink3,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Center(
                                  child: Text(
                                    'days/week',
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w500,
                                      color: colors.ink3,
                                      letterSpacing: 0.3,
                                      fontFamily: 'SpaceMono',
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Container(
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: colors.surface2,
                                    borderRadius: BorderRadius.circular(11),
                                    border: Border.all(color: colors.line),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(
                                        PhosphorIcons.info(),
                                        size: 16,
                                        color: colors.ink3,
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Text(
                                          'No fixed schedule — pick any $_weeklyTarget days each week. Your streak counts consecutive weeks where you meet the target.',
                                          style: TextStyle(
                                            fontSize: 13,
                                            height: 1.5,
                                            color: colors.ink2,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
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
    const activeStep = 1;

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

  Widget _buildFrequencyButton(String label, bool selected) {
    final colors = Theme.of(context).extension<BitoColorScheme>()!;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _frequency = label;
            final cadence = label == 'Daily'
                ? HabitCadence.daily
                : HabitCadence.weekly;
            ref.read(habitCreationProvider.notifier).updateCadence(cadence);
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: selected ? colors.signal2 : colors.surface,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: selected ? colors.signal2 : colors.line,
            ),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: selected ? colors.signalInk : colors.ink2,
                letterSpacing: 0.3,
              ),
            ),
          ),
        ),
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
                  ? '/habits/edit/step1'
                  : '/habits/create/step1'
              );
            },
            expanded: false,
          ),
          ElevatedButton(
            onPressed: () {
              final cadence = _frequency == 'Daily'
                  ? HabitCadence.daily
                  : HabitCadence.weekly;
              ref.read(habitCreationProvider.notifier).updateCadence(cadence);
              if (_frequency == 'Daily') {
                ref.read(habitCreationProvider.notifier).updateTarget(0);
              } else {
                ref.read(habitCreationProvider.notifier).updateTarget(_weeklyTarget);
              }

              final isEditing = widget.isEditing;
              context.go(isEditing
                  ? '/habits/edit/step3'
                  : '/habits/create/step3'
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: colors.signal2,
              foregroundColor: Colors.black,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(11),
              ),
              elevation: 0,
            ),
            child: Row(
              children: [
                Text(
                  'CONTINUE',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                    letterSpacing: 0.5,
                    fontFamily: 'SpaceMono',
                  ),
                ),
                const SizedBox(width: 8),
                Icon(
                  PhosphorIcons.arrowRight(),
                  size: 16,
                  color: Colors.black,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}