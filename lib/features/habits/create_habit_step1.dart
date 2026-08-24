// lib/features/habits/create_habit_step1.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:go_router/go_router.dart';

import '../../theme/theme_extensions.dart';
import '../../shared/shared.dart';
import '../../data/providers/habit_creation_provider.dart';
import '../../domain/entities/habit.dart';

class CreateHabitStep1 extends ConsumerStatefulWidget {
  final bool isEditing;

  const CreateHabitStep1({
    super.key,
    this.isEditing = false,
  });

  @override
  ConsumerState<CreateHabitStep1> createState() => _CreateHabitStep1State();
}

class _CreateHabitStep1State extends ConsumerState<CreateHabitStep1> {
  late String _habitName;
  late String _selectedCategory;
  late String _selectedIcon;

  final List<String> _categories = [
    'Activity', 'Health', 'Mind', 'Productivity', 'Life', 'Sleep'
  ];

  final Map<String, List<Map<String, dynamic>>> _categoryIcons = {
    'Activity': [
      {'name': 'running', 'icon': PhosphorIcons.personSimpleRun()},
      {'name': 'dumbbell', 'icon': PhosphorIcons.barbell()},
      {'name': 'bicycle', 'icon': PhosphorIcons.bicycle()},
      {'name': 'swimming', 'icon': PhosphorIcons.personSimpleSwim()},
      {'name': 'walking', 'icon': PhosphorIcons.personSimpleWalk()},
      {'name': 'yoga', 'icon': PhosphorIcons.personSimpleTaiChi()},
    ],
    'Health': [
      {'name': 'heart', 'icon': PhosphorIcons.heart()},
      {'name': 'apple', 'icon': PhosphorIcons.appleLogo()},
      {'name': 'drop', 'icon': PhosphorIcons.drop()},
      {'name': 'brain', 'icon': PhosphorIcons.brain()},
      {'name': 'tooth', 'icon': PhosphorIcons.tooth()},
    ],
    'Mind': [
      {'name': 'brain', 'icon': PhosphorIcons.brain()},
      {'name': 'book', 'icon': PhosphorIcons.book()},
      {'name': 'lightbulb', 'icon': PhosphorIcons.lightbulb()},
      {'name': 'smiley', 'icon': PhosphorIcons.smiley()},
      {'name': 'target', 'icon': PhosphorIcons.target()},
    ],
    'Productivity': [
      {'name': 'target', 'icon': PhosphorIcons.target()},
      {'name': 'clock', 'icon': PhosphorIcons.clock()},
      {'name': 'calendar', 'icon': PhosphorIcons.calendar()},
      {'name': 'checkSquare', 'icon': PhosphorIcons.checkSquare()},
      {'name': 'list', 'icon': PhosphorIcons.list()},
      {'name': 'chartBar', 'icon': PhosphorIcons.chartBar()},
    ],
    'Life': [
      {'name': 'coffee', 'icon': PhosphorIcons.coffee()},
      {'name': 'house', 'icon': PhosphorIcons.house()},
      {'name': 'musicNotes', 'icon': PhosphorIcons.musicNotes()},
      {'name': 'camera', 'icon': PhosphorIcons.camera()},
      {'name': 'palette', 'icon': PhosphorIcons.palette()},
      {'name': 'globe', 'icon': PhosphorIcons.globe()},
    ],
    'Sleep': [
      {'name': 'moon', 'icon': PhosphorIcons.moon()},
      {'name': 'bed', 'icon': PhosphorIcons.bed()},
      {'name': 'star', 'icon': PhosphorIcons.star()},
      {'name': 'sun', 'icon': PhosphorIcons.sun()},
      {'name': 'cloud', 'icon': PhosphorIcons.cloud()},
    ],
  };

  @override
  void initState() {
    super.initState();
    final state = ref.read(habitCreationProvider);
    _habitName = state.name;
    _selectedCategory = state.category.isNotEmpty ? state.category : 'Productivity';
    _selectedIcon = state.icon.isNotEmpty ? state.icon : 'target';
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
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),
                    Text(
                      widget.isEditing ? 'EDIT HABIT' : 'STEP 1 OF 4',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: colors.signal2,
                        letterSpacing: 1.2,
                        fontFamily: 'SpaceMono',
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.isEditing
                          ? 'Update your habit details'
                          : 'What habit do you want to build?',
                      style: textTheme.headlineSmall?.copyWith(
                        color: colors.ink,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.isEditing
                          ? 'Edit the name, category, and icon'
                          : 'Name it, pick an icon, and you\'re off.',
                      style: TextStyle(
                        fontSize: 14,
                        color: colors.ink2,
                      ),
                    ),
                    const SizedBox(height: 24),
                    _buildNameField(context, colors),
                    const SizedBox(height: 24),
                    _buildCategorySelector(context, colors),
                    const SizedBox(height: 24),
                    _buildIconSelector(context, colors),
                    const SizedBox(height: 24),
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

  Widget _buildHeader(BuildContext context) {
    final colors = Theme.of(context).extension<BitoColorScheme>()!;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
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
    );
  }

  Widget _buildProgress(BuildContext context) {
    final colors = Theme.of(context).extension<BitoColorScheme>()!;
    final steps = ['WHAT', 'WHEN', 'STYLE', 'GO'];
    const activeStep = 0;

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

  Widget _buildNameField(BuildContext context, BitoColorScheme colors) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'NAME*',
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w700,
            color: colors.ink3,
            letterSpacing: 1.2,
            fontFamily: 'SpaceMono',
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(11),
            border: Border.all(color: colors.line),
            color: colors.surface,
          ),
          child: TextField(
            onChanged: (value) {
              setState(() {
                _habitName = value;
              });
            },
            controller: TextEditingController(text: _habitName)
              ..selection = TextSelection.fromPosition(
                TextPosition(offset: _habitName.length),
              ),
            style: TextStyle(
              fontSize: 16,
              color: colors.ink,
            ),
            decoration: InputDecoration(
              hintText: 'Deep work',
              hintStyle: TextStyle(
                color: colors.ink3,
                fontSize: 16,
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCategorySelector(BuildContext context, BitoColorScheme colors) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'CATEGORY',
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
          children: _categories.map((category) {
            final isSelected = _selectedCategory == category;
            return Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedCategory = category;
                      _selectedIcon = _categoryIcons[category]!.first['name'];
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      color: isSelected ? colors.signal2 : colors.surface,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: isSelected ? colors.signal2 : colors.line,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        category.toUpperCase(),
                        style: TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.w700,
                          color: isSelected ? colors.signalInk : colors.ink2,
                          letterSpacing: 0.3,
                          fontFamily: 'SpaceMono',
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildIconSelector(BuildContext context, BitoColorScheme colors) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'ICON',
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w700,
            color: colors.ink3,
            letterSpacing: 1.2,
            fontFamily: 'SpaceMono',
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: _categoryIcons[_selectedCategory]!.map((iconData) {
            final isSelected = _selectedIcon == iconData['name'];
            return GestureDetector(
              onTap: () {
                setState(() {
                  _selectedIcon = iconData['name'];
                });
              },
              child: Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: isSelected ? colors.signal2 : colors.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected ? colors.signal2 : colors.line,
                  ),
                ),
                child: Icon(
                  iconData['icon'],
                  size: 24,
                  color: isSelected ? colors.signalInk : colors.ink2,
                ),
              ),
            );
          }).toList(),
        ),
      ],
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
            text: widget.isEditing ? 'CANCEL' : 'CANCEL',
            type: ButtonType.cancel,
            icon: Icon(
              PhosphorIcons.x(),
              size: 16,
              color: colors.ink2,
            ),
            onPressed: () => context.go('/habits'),
            expanded: false,
          ),
          ElevatedButton(
            onPressed: () {
              if (_habitName.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Please enter a habit name'),
                    backgroundColor: Colors.red,
                  ),
                );
                return;
              }
              // Store habit data in provider
              ref.read(habitCreationProvider.notifier).updateName(_habitName);
              ref.read(habitCreationProvider.notifier).updateIcon(_selectedIcon);
              ref.read(habitCreationProvider.notifier).updateCategory(_selectedCategory);

              final isEditing = widget.isEditing;
              context.go(isEditing
                  ? '/habits/edit/step2'
                  : '/habits/create/step2'
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
