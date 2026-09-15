// lib/features/groups/widgets/add_group_habit_sheet.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:bito/theme/theme_extensions.dart';
import 'package:bito/data/groups/group_habit.dart';
import 'package:bito/data/groups/group_habits_provider.dart';
import 'package:bito/shared/components/inputs/digital_time_picker.dart';

class AddGroupHabitSheet extends ConsumerStatefulWidget {
  final String groupId;

  const AddGroupHabitSheet({super.key, required this.groupId});

  static Future<void> show(BuildContext context, String groupId) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AddGroupHabitSheet(groupId: groupId),
    );
  }

  @override
  ConsumerState<AddGroupHabitSheet> createState() => _AddGroupHabitSheetState();
}

class _AddGroupHabitSheetState extends ConsumerState<AddGroupHabitSheet> {
  int _currentStep = 0; // 0: DETAILS, 1: STYLE, 2: SETTINGS

  // Form State - Details
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  String _selectedCategory = 'Health & Fitness';
  final TextEditingController _targetController = TextEditingController(
    text: '1',
  );
  String _selectedTargetUnit = 'Times';

  // Form State - Style
  String _selectedIconCategory = 'ALL';
  String _selectedIcon = 'barbell';
  int _selectedColor = 0xFF6F4EE6;

  // Form State - Settings
  final List<String> _days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
  final Set<int> _selectedDays = {0, 1, 2, 3, 4, 5, 6};
  bool _requireForAll = false;
  bool _enableReminders = false;
  TimeOfDay _reminderTime = const TimeOfDay(hour: 7, minute: 0);

  final List<String> _categories = [
    'Health & Fitness',
    'Productivity',
    'Mind',
    'Lifestyle',
    'Study',
  ];

  final List<String> _targetUnits = ['Times', 'km', 'mins', 'hours', 'pages'];

  final List<String> _iconCategories = [
    'ALL',
    'FITNESS',
    'HEALTH',
    'MIND',
    'PRODUCTIVITY',
  ];

  final List<Map<String, dynamic>> _iconList = [
    {'name': 'barbell', 'icon': PhosphorIcons.barbell(), 'cat': 'FITNESS'},
    {
      'name': 'sneakerMove',
      'icon': PhosphorIcons.sneakerMove(),
      'cat': 'FITNESS',
    },
    {'name': 'heart', 'icon': PhosphorIcons.heart(), 'cat': 'HEALTH'},
    {'name': 'drop', 'icon': PhosphorIcons.drop(), 'cat': 'HEALTH'},
    {'name': 'bookOpen', 'icon': PhosphorIcons.bookOpen(), 'cat': 'MIND'},
    {'name': 'brain', 'icon': PhosphorIcons.brain(), 'cat': 'MIND'},
    {'name': 'sparkle', 'icon': PhosphorIcons.sparkle(), 'cat': 'PRODUCTIVITY'},
    {
      'name': 'checkCircle',
      'icon': PhosphorIcons.checkCircle(),
      'cat': 'PRODUCTIVITY',
    },
    {'name': 'fire', 'icon': PhosphorIcons.fire(), 'cat': 'ALL'},
    {'name': 'sun', 'icon': PhosphorIcons.sun(), 'cat': 'ALL'},
    {'name': 'moon', 'icon': PhosphorIcons.moon(), 'cat': 'ALL'},
    {'name': 'trophy', 'icon': PhosphorIcons.trophy(), 'cat': 'ALL'},
  ];

  final List<int> _colorPalette = [
    0xFF6F4EE6, // Purple
    0xFF3B82F6, // Blue
    0xFF06B6D4, // Cyan
    0xFF10B981, // Teal
    0xFF22C55E, // Green
    0xFFEAB308, // Yellow
    0xFFF97316, // Orange
    0xFFEF4444, // Red
    0xFFEC4899, // Pink
    0xFF8B5CF6, // Violet
    0xFF6366F1, // Indigo
    0xFF14B8A6, // Emerald
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _targetController.dispose();
    super.dispose();
  }

  IconData _getIconData(String name) {
    final match = _iconList.firstWhere(
      (item) => item['name'] == name,
      orElse: () => {'icon': PhosphorIcons.barbell()},
    );
    return match['icon'] as IconData;
  }

  void _saveHabit() {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a habit name')),
      );
      setState(() {
        _currentStep = 0;
      });
      return;
    }

    final targetVal = int.tryParse(_targetController.text.trim()) ?? 1;
    final selectedDayLabels = _selectedDays.map((i) => _days[i]).toList();

    final newHabit = GroupHabit(
      id: 'gh-${DateTime.now().millisecondsSinceEpoch}',
      groupId: widget.groupId,
      name: name,
      description: _descriptionController.text.trim().isNotEmpty
          ? _descriptionController.text.trim()
          : null,
      category: _selectedCategory,
      target: targetVal,
      targetUnit: _selectedTargetUnit,
      icon: _selectedIcon,
      color: _selectedColor,
      selectedDays: selectedDayLabels,
      requireForAll: _requireForAll,
      hasReminder: _enableReminders,
      reminderTime: _enableReminders ? _reminderTime : null,
      createdBy: 'YOU',
      adoptedBy: const ['user1'],
      isAdopted: true,
      createdAt: DateTime.now(),
    );

    ref.read(groupHabitsProvider.notifier).addHabit(newHabit);
    Navigator.pop(context);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Group habit "$name" created!'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<BitoColorScheme>()!;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      height: MediaQuery.of(context).size.height * 0.88,
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        border: Border.all(color: colors.line),
      ),
      child: Column(
        children: [
          // Drag handle
          const SizedBox(height: 12),
          Center(
            child: Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: colors.line2,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: Color(_selectedColor).withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: Color(_selectedColor).withValues(alpha: 0.3),
                    ),
                  ),
                  child: Icon(
                    _getIconData(_selectedIcon),
                    color: Color(_selectedColor),
                    size: 18,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Add Group Habit',
                    style: textTheme.titleMedium?.copyWith(
                      color: colors.ink,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(PhosphorIcons.x(), color: colors.ink3, size: 20),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Step Tabs
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                _buildStepTab(0, 'DETAILS', colors),
                const SizedBox(width: 8),
                _buildStepTab(1, 'STYLE', colors),
                const SizedBox(width: 8),
                _buildStepTab(2, 'SETTINGS', colors),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Divider(height: 1, color: colors.line),

          // Body Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: _buildCurrentStepContent(colors, textTheme),
            ),
          ),

          // Bottom Buttons
          _buildBottomBar(colors),
        ],
      ),
    );
  }

  Widget _buildStepTab(int stepIndex, String title, BitoColorScheme colors) {
    final isActive = _currentStep == stepIndex;
    final isDone = _currentStep > stepIndex;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _currentStep = stepIndex;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: isActive
                ? colors.signal.withValues(alpha: 0.12)
                : colors.surface2,
            borderRadius: BorderRadius.circular(6),
            border: Border.all(
              color: isActive
                  ? colors.signal
                  : (isDone ? colors.line2 : colors.line),
            ),
          ),
          child: Center(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 9,
                fontWeight: FontWeight.w700,
                color: isActive
                    ? colors.signal
                    : (isDone ? colors.ink2 : colors.ink3),
                letterSpacing: 0.6,
                fontFamily: 'SpaceMono',
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCurrentStepContent(BitoColorScheme colors, TextTheme textTheme) {
    switch (_currentStep) {
      case 0:
        return _buildDetailsStep(colors, textTheme);
      case 1:
        return _buildStyleStep(colors, textTheme);
      case 2:
        return _buildSettingsStep(colors, textTheme);
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildDetailsStep(BitoColorScheme colors, TextTheme textTheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildFieldLabel('HABIT NAME *', colors),
        const SizedBox(height: 6),
        Container(
          decoration: BoxDecoration(
            color: colors.bg,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: colors.line),
          ),
          child: TextField(
            controller: _nameController,
            style: TextStyle(color: colors.ink, fontSize: 14),
            decoration: InputDecoration(
              hintText: 'e.g. Morning run, Daily reading',
              hintStyle: TextStyle(color: colors.ink3, fontSize: 14),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 12,
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),

        _buildFieldLabel('DESCRIPTION', colors),
        const SizedBox(height: 6),
        Container(
          decoration: BoxDecoration(
            color: colors.bg,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: colors.line),
          ),
          child: TextField(
            controller: _descriptionController,
            maxLines: 3,
            style: TextStyle(color: colors.ink, fontSize: 14),
            decoration: InputDecoration(
              hintText: 'Run at least 2km every morning with the group',
              hintStyle: TextStyle(color: colors.ink3, fontSize: 14),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 12,
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),

        _buildFieldLabel('CATEGORY', colors),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
            color: colors.bg,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: colors.line),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _selectedCategory,
              isExpanded: true,
              dropdownColor: colors.surface,
              icon: Icon(
                PhosphorIcons.caretDown(),
                color: colors.ink3,
                size: 16,
              ),
              items: _categories.map((cat) {
                return DropdownMenuItem<String>(
                  value: cat,
                  child: Text(
                    cat,
                    style: TextStyle(color: colors.ink, fontSize: 14),
                  ),
                );
              }).toList(),
              onChanged: (val) {
                if (val != null) {
                  setState(() {
                    _selectedCategory = val;
                  });
                }
              },
            ),
          ),
        ),
        const SizedBox(height: 16),

        _buildFieldLabel('DEFAULT TARGET', colors),
        const SizedBox(height: 6),
        Row(
          children: [
            Expanded(
              flex: 2,
              child: Container(
                decoration: BoxDecoration(
                  color: colors.bg,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: colors.line),
                ),
                child: TextField(
                  controller: _targetController,
                  keyboardType: TextInputType.number,
                  style: TextStyle(color: colors.ink, fontSize: 14),
                  decoration: InputDecoration(
                    hintText: '1',
                    hintStyle: TextStyle(color: colors.ink3, fontSize: 14),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 12,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              flex: 3,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: colors.bg,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: colors.line),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _selectedTargetUnit,
                    isExpanded: true,
                    dropdownColor: colors.surface,
                    icon: Icon(
                      PhosphorIcons.caretDown(),
                      color: colors.ink3,
                      size: 16,
                    ),
                    items: _targetUnits.map((unit) {
                      return DropdownMenuItem<String>(
                        value: unit,
                        child: Text(
                          unit,
                          style: TextStyle(color: colors.ink, fontSize: 14),
                        ),
                      );
                    }).toList(),
                    onChanged: (val) {
                      if (val != null) {
                        setState(() {
                          _selectedTargetUnit = val;
                        });
                      }
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStyleStep(BitoColorScheme colors, TextTheme textTheme) {
    final filteredIcons = _selectedIconCategory == 'ALL'
        ? _iconList
        : _iconList
              .where(
                (item) =>
                    item['cat'] == _selectedIconCategory ||
                    item['cat'] == 'ALL',
              )
              .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildFieldLabel('CATEGORY ICON', colors),
        const SizedBox(height: 8),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: _iconCategories.map((cat) {
              final isSelected = _selectedIconCategory == cat;
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedIconCategory = cat;
                  });
                },
                child: Container(
                  margin: const EdgeInsets.only(right: 8),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected ? colors.signal : colors.bg,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                      color: isSelected ? colors.signal : colors.line,
                    ),
                  ),
                  child: Text(
                    cat,
                    style: TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.w700,
                      color: isSelected ? Colors.black : colors.ink2,
                      letterSpacing: 0.5,
                      fontFamily: 'SpaceMono',
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 20),

        _buildFieldLabel('ICON', colors),
        const SizedBox(height: 8),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 6,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemCount: filteredIcons.length,
          itemBuilder: (context, index) {
            final item = filteredIcons[index];
            final name = item['name'] as String;
            final iconData = item['icon'] as IconData;
            final isSelected = _selectedIcon == name;

            return GestureDetector(
              onTap: () {
                setState(() {
                  _selectedIcon = name;
                });
              },
              child: Container(
                decoration: BoxDecoration(
                  color: isSelected
                      ? Color(_selectedColor).withValues(alpha: 0.2)
                      : colors.bg,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: isSelected ? Color(_selectedColor) : colors.line,
                    width: isSelected ? 1.5 : 1,
                  ),
                ),
                child: Icon(
                  iconData,
                  size: 20,
                  color: isSelected ? Color(_selectedColor) : colors.ink2,
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 24),

        _buildFieldLabel('COLOR', colors),
        const SizedBox(height: 8),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 6,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemCount: _colorPalette.length,
          itemBuilder: (context, index) {
            final colorVal = _colorPalette[index];
            final isSelected = _selectedColor == colorVal;

            return GestureDetector(
              onTap: () {
                setState(() {
                  _selectedColor = colorVal;
                });
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Color(colorVal),
                  shape: BoxShape.circle,
                  border: isSelected
                      ? Border.all(color: Colors.white, width: 2.5)
                      : Border.all(color: colors.line, width: 1),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: Color(colorVal).withValues(alpha: 0.4),
                            blurRadius: 6,
                            spreadRadius: 2,
                          ),
                        ]
                      : null,
                ),
                child: isSelected
                    ? const Icon(Icons.check, size: 16, color: Colors.white)
                    : null,
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildSettingsStep(BitoColorScheme colors, TextTheme textTheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildFieldLabel('SCHEDULE', colors),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(_days.length, (index) {
            final isSelected = _selectedDays.contains(index);
            return GestureDetector(
              onTap: () {
                setState(() {
                  if (isSelected) {
                    if (_selectedDays.length > 1) {
                      _selectedDays.remove(index);
                    }
                  } else {
                    _selectedDays.add(index);
                  }
                });
              },
              child: Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: isSelected ? Color(_selectedColor) : colors.bg,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isSelected ? Color(_selectedColor) : colors.line,
                  ),
                ),
                child: Center(
                  child: Text(
                    _days[index],
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: isSelected ? Colors.white : colors.ink2,
                      fontFamily: 'SpaceMono',
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
        const SizedBox(height: 24),

        // Require for all members toggle
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: colors.bg,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: colors.line),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Require for all members',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: colors.ink,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'All group members must adopt this habit',
                      style: TextStyle(fontSize: 11, color: colors.ink3),
                    ),
                  ],
                ),
              ),
              Switch(
                value: _requireForAll,
                activeThumbColor: Color(_selectedColor),
                onChanged: (val) {
                  setState(() {
                    _requireForAll = val;
                  });
                },
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),

        // Enable reminders toggle
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: colors.bg,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: colors.line),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Enable reminders',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: colors.ink,
                    ),
                  ),
                  Switch(
                    value: _enableReminders,
                    activeThumbColor: Color(_selectedColor),
                    onChanged: (val) {
                      setState(() {
                        _enableReminders = val;
                      });
                    },
                  ),
                ],
              ),
              if (_enableReminders) ...[
                const SizedBox(height: 12),
                Divider(height: 1, color: colors.line),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'REMINDER TIME',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: colors.ink3,
                        letterSpacing: 0.6,
                        fontFamily: 'SpaceMono',
                      ),
                    ),
                    GestureDetector(
                      onTap: () async {
                        final picked = await DigitalTimePicker.show(
                          context,
                          initialTime: _reminderTime,
                        );
                        if (picked != null) {
                          setState(() {
                            _reminderTime = picked;
                          });
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: colors.surface2,
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: colors.line),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              PhosphorIcons.clock(),
                              size: 14,
                              color: colors.ink,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              _reminderTime.format(context),
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: colors.ink,
                                fontFamily: 'SpaceMono',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

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

  Widget _buildBottomBar(BitoColorScheme colors) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: colors.line)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (_currentStep == 0)
            OutlinedButton(
              onPressed: () => Navigator.pop(context),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                side: BorderSide(color: colors.line),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                'CANCEL',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: colors.ink2,
                  fontFamily: 'SpaceMono',
                ),
              ),
            )
          else
            OutlinedButton(
              onPressed: () {
                setState(() {
                  _currentStep--;
                });
              },
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                side: BorderSide(color: colors.line),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                'BACK',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: colors.ink2,
                  fontFamily: 'SpaceMono',
                ),
              ),
            ),
          ElevatedButton(
            onPressed: () {
              if (_currentStep < 2) {
                if (_currentStep == 0 && _nameController.text.trim().isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please enter a habit name')),
                  );
                  return;
                }
                setState(() {
                  _currentStep++;
                });
              } else {
                _saveHabit();
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(_selectedColor),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              elevation: 0,
            ),
            child: Text(
              _currentStep < 2 ? 'NEXT' : 'CREATE HABIT',
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.5,
                fontFamily: 'SpaceMono',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
