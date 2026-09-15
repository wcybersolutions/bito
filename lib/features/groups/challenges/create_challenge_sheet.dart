// lib/features/groups/challenges/create_challenge_sheet.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:bito/theme/theme_extensions.dart';
import 'package:bito/data/groups/group_challenge.dart';
import 'package:bito/data/groups/group_challenges_provider.dart';

class CreateChallengeSheet extends ConsumerStatefulWidget {
  final String groupId;

  const CreateChallengeSheet({
    super.key,
    required this.groupId,
  });

  static Future<void> show(BuildContext context, String groupId) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      enableDrag: true,
      builder: (context) => CreateChallengeSheet(groupId: groupId),
    );
  }

  @override
  ConsumerState<CreateChallengeSheet> createState() =>
      _CreateChallengeSheetState();
}

class _CreateChallengeSheetState extends ConsumerState<CreateChallengeSheet> {
  int _currentStep = 0; // 0: DETAILS, 1: TARGET & HABIT, 2: SETTINGS
  final List<String> _steps = ['DETAILS', 'TARGET & HABIT', 'SETTINGS'];

  // Step 1: Details (Type & Basics)
  ChallengeType _selectedType = ChallengeType.streak;
  final TextEditingController _titleController =
      TextEditingController(text: '14-Day Morning Streak');
  final TextEditingController _descriptionController = TextEditingController(
      text: 'Maintain consecutive daily completions with the team');
  String _selectedDuration = '14 Days';
  final List<String> _durations = ['7 Days', '14 Days', '21 Days', '30 Days'];

  // Step 2: Target & Habit
  final TextEditingController _targetController =
      TextEditingController(text: '7');
  String _selectedUnit = 'Days';
  final List<String> _units = ['Days', 'Completions', 'Hours', '%', 'Km'];
  String _selectedHabitLink = 'Any habit';
  final List<String> _habitLinkOptions = [
    'Any habit',
    'Yoga',
    'Morning run',
    'Evening run'
  ];
  final TextEditingController _habitSlotController =
      TextEditingController(text: 'Any exercise or movement habit');
  String _selectedMatchMode = 'Single — one habit tracks progress';
  final List<String> _matchModes = [
    'Single — one habit tracks progress',
    'Multiple — combine all qualifying habits'
  ];

  // Step 3: Settings & Personal Habit
  bool _allowLateJoin = true;
  bool _showLeaderboard = true;
  final TextEditingController _maxParticipantsController =
      TextEditingController();
  String _personalHabit = 'Morning run';

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _targetController.dispose();
    _habitSlotController.dispose();
    _maxParticipantsController.dispose();
    super.dispose();
  }

  void _nextStep() {
    if (_currentStep < _steps.length - 1) {
      setState(() => _currentStep++);
    } else {
      _saveChallenge();
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
    } else {
      Navigator.pop(context);
    }
  }

  void _saveChallenge() {
    final target = int.tryParse(_targetController.text.trim()) ?? 7;
    final maxP = int.tryParse(_maxParticipantsController.text.trim());

    final challenge = GroupChallenge(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      groupId: widget.groupId,
      title: _titleController.text.trim().isNotEmpty
          ? _titleController.text.trim()
          : '${_selectedType.label} Challenge',
      description: _descriptionController.text.trim(),
      type: _selectedType,
      targetValue: target,
      unit: _selectedUnit,
      linkedHabit: _selectedHabitLink,
      habitSlot: _habitSlotController.text.trim(),
      matchMode: _selectedMatchMode,
      allowLateJoin: _allowLateJoin,
      showLeaderboard: _showLeaderboard,
      maxParticipants: maxP,
      createdAt: DateTime.now(),
      endDate: DateTime.now().add(const Duration(days: 14)),
    );

    ref
        .read(groupChallengesProvider.notifier)
        .addChallenge(widget.groupId, challenge);

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<BitoColorScheme>()!;
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.88,
        ),
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          border: Border.all(color: colors.line),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle Bar
            const SizedBox(height: 12),
            Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: colors.line2,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 14),

            // Header Row: CHALLENGE SETUP / New Challenge / QUICK MODE + X
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'CHALLENGE SETUP',
                    style: TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.w700,
                      color: colors.ink3,
                      letterSpacing: 1.0,
                      fontFamily: 'SpaceMono',
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'New Challenge',
                        style: textTheme.titleLarge?.copyWith(
                          color: colors.ink,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'QUICK MODE',
                            style: TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.w700,
                              color: colors.ink3,
                              letterSpacing: 0.5,
                              fontFamily: 'SpaceMono',
                            ),
                          ),
                          const SizedBox(width: 8),
                          GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: Icon(
                              PhosphorIcons.x(),
                              size: 16,
                              color: colors.ink2,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),

                  // Step Indicators Bar
                  _buildStepIndicators(colors),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Divider(height: 1, color: colors.line),

            // Step Content (Scrollable)
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
                child: _buildCurrentStep(colors, textTheme),
              ),
            ),

            // Bottom Actions Bar (BACK / CONTINUE)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: colors.surface,
                border: Border(top: BorderSide(color: colors.line)),
              ),
              child: Row(
                children: [
                  OutlinedButton.icon(
                    onPressed: _previousStep,
                    icon: Icon(
                      _currentStep == 0
                          ? PhosphorIcons.x()
                          : PhosphorIcons.arrowLeft(),
                      size: 14,
                      color: colors.ink,
                    ),
                    label: Text(
                      _currentStep == 0 ? 'CANCEL' : 'BACK',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: colors.ink,
                        letterSpacing: 0.5,
                        fontFamily: 'SpaceMono',
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      side: BorderSide(color: colors.line),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _nextStep,
                      icon: Icon(
                        _currentStep == _steps.length - 1
                            ? PhosphorIcons.trophy()
                            : PhosphorIcons.arrowRight(),
                        size: 16,
                        color: Colors.black,
                      ),
                      label: Text(
                        _currentStep == _steps.length - 1
                            ? 'LAUNCH CHALLENGE'
                            : 'CONTINUE',
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                          color: Colors.black,
                          letterSpacing: 0.5,
                          fontFamily: 'SpaceMono',
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colors.signal2,
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(vertical: 13),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 0,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStepIndicators(BitoColorScheme colors) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(_steps.length, (index) {
        final isActive = index == _currentStep;
        final isCompleted = index < _currentStep;

        return Expanded(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 2),
            child: Column(
              children: [
                Container(
                  height: 3,
                  decoration: BoxDecoration(
                    color: isActive || isCompleted
                        ? colors.signal2
                        : colors.line2,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _steps[index],
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
          ),
        );
      }),
    );
  }

  Widget _buildCurrentStep(BitoColorScheme colors, TextTheme textTheme) {
    switch (_currentStep) {
      case 0:
        return _buildStep1Details(colors);
      case 1:
        return _buildStep2TargetAndHabit(colors);
      case 2:
        return _buildStep3Settings(colors);
      default:
        return const SizedBox.shrink();
    }
  }

  // -------------------------------------------------------------
  // STEP 1: DETAILS (Merged Type & Basics)
  // -------------------------------------------------------------
  Widget _buildStep1Details(BitoColorScheme colors) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(PhosphorIcons.sparkle(), size: 12, color: colors.signal2),
            const SizedBox(width: 6),
            Text(
              'SELECT CHALLENGE TYPE',
              style: TextStyle(
                fontSize: 9,
                fontWeight: FontWeight.w700,
                color: colors.signal2,
                letterSpacing: 0.6,
                fontFamily: 'SpaceMono',
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // 2x2 Grid of Challenge Types
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: _buildTypeCard(
                colors,
                type: ChallengeType.streak,
                icon: PhosphorIcons.fire(),
                hasAiBadge: true,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _buildTypeCard(
                colors,
                type: ChallengeType.cumulative,
                icon: PhosphorIcons.trendUp(),
                hasAiBadge: false,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: _buildTypeCard(
                colors,
                type: ChallengeType.consistency,
                icon: PhosphorIcons.calendar(),
                hasAiBadge: true,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _buildTypeCard(
                colors,
                type: ChallengeType.teamGoal,
                icon: PhosphorIcons.handshake(),
                hasAiBadge: false,
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),

        // Basics Fields
        _buildFieldLabel('CHALLENGE NAME *', colors),
        const SizedBox(height: 6),
        _buildTextInput(
          controller: _titleController,
          hint: 'e.g. 14-Day Morning Streak',
          colors: colors,
        ),
        const SizedBox(height: 16),

        _buildFieldLabel('DESCRIPTION (OPTIONAL)', colors),
        const SizedBox(height: 6),
        _buildTextInput(
          controller: _descriptionController,
          hint: 'Describe the challenge goal for the group...',
          maxLines: 2,
          colors: colors,
        ),
        const SizedBox(height: 16),

        _buildFieldLabel('DURATION', colors),
        const SizedBox(height: 6),
        Row(
          children: _durations.map((duration) {
            final isSelected = _selectedDuration == duration;
            return Expanded(
              child: GestureDetector(
                onTap: () => setState(() => _selectedDuration = duration),
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? colors.signal2.withValues(alpha: 0.15)
                        : colors.bg,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: isSelected ? colors.signal2 : colors.line,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      duration,
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: isSelected ? colors.signal2 : colors.ink2,
                        fontFamily: 'SpaceMono',
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

  Widget _buildTypeCard(
    BitoColorScheme colors, {
    required ChallengeType type,
    required IconData icon,
    required bool hasAiBadge,
  }) {
    final isSelected = _selectedType == type;

    return GestureDetector(
      onTap: () => setState(() {
        _selectedType = type;
        if (_titleController.text.isEmpty ||
            _titleController.text.contains('Challenge') ||
            _titleController.text.contains('Streak')) {
          _titleController.text = '14-Day ${type.label} Challenge';
        }
      }),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected
              ? colors.signal2.withValues(alpha: 0.1)
              : colors.bg,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? colors.signal2 : colors.line,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(
                  icon,
                  size: 20,
                  color: isSelected ? colors.signal2 : colors.ink2,
                ),
                if (hasAiBadge)
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                    decoration: BoxDecoration(
                      color: colors.signal2.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      '✦ AI',
                      style: TextStyle(
                        fontSize: 8,
                        fontWeight: FontWeight.w800,
                        color: colors.signal2,
                        fontFamily: 'SpaceMono',
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              type.label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: colors.ink,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              type.sublabel,
              style: TextStyle(
                fontSize: 8,
                fontWeight: FontWeight.w700,
                color: colors.ink3,
                letterSpacing: 0.4,
                fontFamily: 'SpaceMono',
              ),
            ),
          ],
        ),
      ),
    );
  }

  // -------------------------------------------------------------
  // STEP 2: TARGET & HABIT (Merged Targets, Habit Link & Match Mode)
  // -------------------------------------------------------------
  Widget _buildStep2TargetAndHabit(BitoColorScheme colors) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Target & Unit Row
        Row(
          children: [
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildFieldLabel('TARGET', colors),
                  const SizedBox(height: 6),
                  _buildTextInput(
                    controller: _targetController,
                    hint: '7',
                    keyboardType: TextInputType.number,
                    colors: colors,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildFieldLabel('UNIT', colors),
                  const SizedBox(height: 6),
                  _buildDropdown(
                    value: _selectedUnit,
                    items: _units,
                    onChanged: (v) => setState(() => _selectedUnit = v!),
                    colors: colors,
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 18),

        // LINK TO HABIT (Consolidated)
        _buildFieldLabel('LINK TO GROUP HABIT (OPTIONAL)', colors),
        const SizedBox(height: 6),
        _buildDropdown(
          value: _selectedHabitLink,
          items: _habitLinkOptions,
          onChanged: (v) {
            if (v != null) {
              setState(() {
                _selectedHabitLink = v;
                if (v != 'Any habit') {
                  _personalHabit = v;
                }
              });
            }
          },
          colors: colors,
        ),
        const SizedBox(height: 18),

        // HABIT SLOT (describe qualifying habits)
        _buildFieldLabel('HABIT SLOT (describe qualifying habits)', colors),
        const SizedBox(height: 6),
        _buildTextInput(
          controller: _habitSlotController,
          hint: 'e.g. Any exercise or movement habit',
          colors: colors,
        ),
        const SizedBox(height: 18),

        // HABIT MATCH MODE
        _buildFieldLabel('HABIT MATCH MODE', colors),
        const SizedBox(height: 6),
        _buildDropdown(
          value: _selectedMatchMode,
          items: _matchModes,
          onChanged: (v) => setState(() => _selectedMatchMode = v!),
          colors: colors,
        ),
      ],
    );
  }

  // -------------------------------------------------------------
  // STEP 3: SETTINGS & PERSONAL HABIT
  // -------------------------------------------------------------
  Widget _buildStep3Settings(BitoColorScheme colors) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Allow late join checkbox
        _buildCheckboxTile(
          label: 'Allow late join',
          value: _allowLateJoin,
          onChanged: (v) => setState(() => _allowLateJoin = v ?? true),
          colors: colors,
        ),
        const SizedBox(height: 12),

        // Show leaderboard checkbox
        _buildCheckboxTile(
          label: 'Show leaderboard',
          value: _showLeaderboard,
          onChanged: (v) => setState(() => _showLeaderboard = v ?? true),
          colors: colors,
        ),
        const SizedBox(height: 20),

        // MAX PARTICIPANTS (EMPTY = UNLIMITED)
        _buildFieldLabel('MAX PARTICIPANTS (EMPTY = UNLIMITED)', colors),
        const SizedBox(height: 6),
        _buildTextInput(
          controller: _maxParticipantsController,
          hint: 'Unlimited',
          keyboardType: TextInputType.number,
          colors: colors,
        ),
        const SizedBox(height: 24),

        // PERSONAL HABIT TRACKING (Unified & Auto-synced)
        _buildFieldLabel('YOUR HABIT TO TRACK THIS CHALLENGE', colors),
        const SizedBox(height: 8),

        if (_selectedHabitLink != 'Any habit') ...[
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: colors.signal2.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: colors.signal2),
            ),
            child: Row(
              children: [
                Icon(PhosphorIcons.link(), size: 18, color: colors.signal2),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Synced with Linked Habit',
                        style: TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.w700,
                          color: colors.signal2,
                          fontFamily: 'SpaceMono',
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        _personalHabit,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: colors.ink,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(PhosphorIcons.checkCircle(),
                    color: colors.signal2, size: 18),
              ],
            ),
          ),
        ] else ...[
          ...['Morning run', 'Yoga', 'Evening run', 'Create new habit'].map((h) {
            final isSelected = _personalHabit == h;
            return GestureDetector(
              onTap: () => setState(() => _personalHabit = h),
              child: Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: isSelected
                      ? colors.signal2.withValues(alpha: 0.12)
                      : colors.bg,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: isSelected ? colors.signal2 : colors.line,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      h,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: isSelected ? colors.signal2 : colors.ink,
                      ),
                    ),
                    if (isSelected)
                      Icon(PhosphorIcons.checkCircle(),
                          color: colors.signal2, size: 18),
                  ],
                ),
              ),
            );
          }),
        ],
      ],
    );
  }

  // -------------------------------------------------------------
  // Helper Widgets
  // -------------------------------------------------------------
  Widget _buildFieldLabel(String label, BitoColorScheme colors) {
    return Text(
      label,
      style: TextStyle(
        fontSize: 9,
        fontWeight: FontWeight.w700,
        color: colors.ink3,
        letterSpacing: 0.8,
        fontFamily: 'SpaceMono',
      ),
    );
  }

  Widget _buildTextInput({
    required TextEditingController controller,
    required String hint,
    required BitoColorScheme colors,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: colors.bg,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: colors.line),
      ),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        keyboardType: keyboardType,
        style: TextStyle(color: colors.ink, fontSize: 13),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(
            color: colors.ink3,
            fontSize: 12,
            fontFamily: 'SpaceMono',
          ),
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        ),
      ),
    );
  }

  Widget _buildDropdown({
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
    required BitoColorScheme colors,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: colors.bg,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: colors.line),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: items.contains(value) ? value : items.first,
          isExpanded: true,
          dropdownColor: colors.surface,
          icon: Icon(PhosphorIcons.caretDown(), color: colors.ink3, size: 16),
          items: items.map((item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(
                item,
                style: TextStyle(color: colors.ink, fontSize: 13),
              ),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _buildCheckboxTile({
    required String label,
    required bool value,
    required ValueChanged<bool?> onChanged,
    required BitoColorScheme colors,
  }) {
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: Row(
        children: [
          Container(
            width: 22,
            height: 22,
            decoration: BoxDecoration(
              color: value ? colors.signal2 : colors.bg,
              borderRadius: BorderRadius.circular(4),
              border: Border.all(
                color: value ? colors.signal2 : colors.line,
              ),
            ),
            child: value
                ? const Icon(Icons.check, size: 16, color: Colors.black)
                : null,
          ),
          const SizedBox(width: 10),
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: colors.ink,
            ),
          ),
        ],
      ),
    );
  }
}
