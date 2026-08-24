// lib/features/habits/create_habit_step3.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:go_router/go_router.dart';

import '../../shared/shared.dart';
import '../../data/providers/habit_creation_provider.dart';

class CreateHabitStep3 extends ConsumerStatefulWidget {
  final bool isEditing;

  const CreateHabitStep3({
    super.key,
    this.isEditing = false,
  });

  @override
  ConsumerState<CreateHabitStep3> createState() => _CreateHabitStep3State();
}

class _CreateHabitStep3State extends ConsumerState<CreateHabitStep3> {
  late TextEditingController _descriptionController;
  late String _selectedCategory;
  late int _selectedColor;

  final List<String> _categories = [
    'Health',
    'Fitness',
    'Productivity',
    'Learning',
    'Mindfulness',
    'Social',
    'Creative',
    'Other'
  ];

  final List<int> _colors = [
    0xFF6F4EE6,
    0xFF2563EB,
    0xFF22C55E,
    0xFFF97316,
    0xFFEF4444,
    0xFFE11D48,
    0xFF8B5CF6,
    0xFF06B6D4,
  ];

  @override
  void initState() {
    super.initState();
    final state = ref.read(habitCreationProvider);
    _descriptionController = TextEditingController(text: state.description ?? '');
    _selectedCategory = state.category.isNotEmpty ? state.category : 'Productivity';
    _selectedColor = state.color;
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

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
                    // REMOVED: duplicate "STEP 3 OF 4" text - header already shows it
                    Text(
                      'Make it yours.',
                      style: textTheme.headlineSmall?.copyWith(
                        color: colors.ink,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Pick a category and color for your dashboard.',
                      style: TextStyle(
                        fontSize: 14,
                        color: colors.ink2,
                      ),
                    ),
                    const SizedBox(height: 24),
                    _buildHabitPreview(context, colors, creationState),
                    const SizedBox(height: 24),
                    _buildCategorySelector(context, colors),
                    const SizedBox(height: 24),
                    _buildColorSelector(context, colors),
                    const SizedBox(height: 24),
                    _buildDescriptionField(context, colors),
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

  Widget _buildHabitPreview(
      BuildContext context,
      BitoColorScheme colors,
      HabitCreationState state,
      ) {
    final color = Color(_selectedColor);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(11),
        border: Border.all(color: colors.line),
      ),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              _getIconData(state.icon),
              size: 18,
              color: color,
            ),
          ),
          const SizedBox(width: 12),
          Text(
            state.name.isEmpty ? 'Habit name' : state.name,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: colors.ink,
            ),
          ),
          const Spacer(),
          Icon(
            PhosphorIcons.pencil(),
            size: 16,
            color: colors.ink3,
          ),
        ],
      ),
    );
  }

  Widget _buildCategorySelector(
      BuildContext context,
      BitoColorScheme colors,
      ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'CATEGORY',
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: colors.ink3,
            letterSpacing: 1.2,
            fontFamily: 'SpaceMono',
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _categories.map((category) {
            final isSelected = _selectedCategory == category;
            return GestureDetector(
              onTap: () {
                setState(() {
                  _selectedCategory = category;
                  ref.read(habitCreationProvider.notifier).updateCategory(category);
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: isSelected ? colors.signal2 : colors.surface,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected ? colors.signal2 : colors.line,
                  ),
                ),
                child: Text(
                  category.toUpperCase(),
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: isSelected ? colors.signalInk : colors.ink2,
                    letterSpacing: 0.5,
                    fontFamily: 'SpaceMono',
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildColorSelector(
      BuildContext context,
      BitoColorScheme colors,
      ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'COLOUR',
          style: TextStyle(
            fontSize: 11,
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
          children: _colors.map((colorValue) {
            final isSelected = _selectedColor == colorValue;
            return GestureDetector(
              onTap: () {
                setState(() {
                  _selectedColor = colorValue;
                  ref.read(habitCreationProvider.notifier).updateColor(colorValue);
                });
              },
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(colorValue),
                  border: isSelected
                      ? Border.all(color: colors.ink, width: 3)
                      : null,
                ),
              ),
            );
          }).toList(),
        ),
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

  Widget _buildDescriptionField(
      BuildContext context,
      BitoColorScheme colors,
      ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'DESCRIPTION',
          style: TextStyle(
            fontSize: 11,
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
            controller: _descriptionController,
            onChanged: (value) {
              ref.read(habitCreationProvider.notifier).updateDescription(value);
            },
            maxLines: 3,
            style: TextStyle(
              fontSize: 14,
              color: colors.ink,
            ),
            decoration: InputDecoration(
              hintText: 'Work mathematics for 2 hours',
              hintStyle: TextStyle(
                color: colors.ink3,
                fontSize: 14,
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
            ),
          ),
        ),
      ],
    );
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
    const activeStep = 2;

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
                  ? '/habits/edit/step2'
                  : '/habits/create/step2'
              );
            },
            expanded: false,
          ),
          ElevatedButton(
            onPressed: () {
              final isEditing = widget.isEditing;
              context.go(isEditing
                  ? '/habits/edit/step4'
                  : '/habits/create/step4'
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
