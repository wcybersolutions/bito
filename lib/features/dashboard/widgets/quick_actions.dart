// lib/features/widgets/quick_actions.dart
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:bito/theme/theme_extensions.dart';

class QuickActions extends StatefulWidget {
  const QuickActions({super.key});

  @override
  State<QuickActions> createState() => _QuickActionsState();
}

class _QuickActionsState extends State<QuickActions> {
  final Map<String, bool> _habitStatus = {
    'Evening run': false,
    'Yoga': false,
    'Deep work': false,
  };

  // Map habits to their icons - using available Phosphor icons
  final Map<String, IconData> _habitIcons = {
    'Evening run': PhosphorIcons.barbell(),
    'Yoga': PhosphorIcons.heart(),
    'Deep work': PhosphorIcons.target(),
  };

  void _toggleHabit(String habitName) {
    setState(() {
      _habitStatus[habitName] = !(_habitStatus[habitName] ?? false);
    });
  }

  void _checkAllHabits() {
    setState(() {
      for (var key in _habitStatus.keys) {
        _habitStatus[key] = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<BitoColorScheme>()!;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Today',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: colors.ink,
                  letterSpacing: -0.3,
                ),
              ),
              Row(
                children: [
                  // Check All button with double ticks
                  OutlinedButton(
                    onPressed: _checkAllHabits,
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                      side: BorderSide(color: colors.line),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                      minimumSize: const Size(32, 32),
                    ),
                    child: Icon(
                      PhosphorIcons.checks(),
                      size: 16,
                      color: colors.ink2,
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Add Habit button - Navigate to habits creation
                  OutlinedButton.icon(
                    onPressed: () {
                      context.go('/habits/create/step1');
                    },
                    icon: Icon(
                      Icons.add,
                      size: 16,
                      color: Colors.black,
                    ),
                    label: Text(
                      'Add HABIT',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                        letterSpacing: 0.5,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      side: BorderSide(color: colors.line),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                      minimumSize: const Size(0, 32),
                      backgroundColor: colors.signal2,  // This works inside styleFrom
                      foregroundColor: Colors.black,    // Text and icon color
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            decoration: BoxDecoration(
              color: colors.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: colors.line),
            ),
            child: Column(
              children: [
                _buildHabitTile(
                  label: 'Evening run',
                  icon: _habitIcons['Evening run']!,
                  isCompleted: _habitStatus['Evening run'] ?? false,
                  colors: colors,
                ),
                Divider(height: 1, indent: 52, color: colors.line),
                _buildHabitTile(
                  label: 'Yoga',
                  icon: _habitIcons['Yoga']!,
                  isCompleted: _habitStatus['Yoga'] ?? false,
                  colors: colors,
                ),
                Divider(height: 1, indent: 52, color: colors.line),
                _buildHabitTile(
                  label: 'Deep work',
                  icon: _habitIcons['Deep work']!,
                  isCompleted: _habitStatus['Deep work'] ?? false,
                  colors: colors,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHabitTile({
    required String label,
    required IconData icon,
    required bool isCompleted,
    required BitoColorScheme colors,
  }) {
    return InkWell(
      onTap: () => _toggleHabit(label),
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            // Rectangle checkbox with rounded corners
            GestureDetector(
              onTap: () => _toggleHabit(label),
              child: Container(
                width: 22,
                height: 22,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(
                    color: isCompleted ? colors.signal : colors.line2,
                    width: 2,
                  ),
                  color: isCompleted ? colors.signal : Colors.transparent,
                ),
                child: isCompleted
                    ? Icon(
                  Icons.check,
                  size: 14,
                  color: colors.signalInk,
                )
                    : null,
              ),
            ),
            const SizedBox(width: 12),
            // Habit icon
            Icon(
              icon,
              size: 20,
              color: colors.ink2,
            ),
            const SizedBox(width: 12),
            // Habit label
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: isCompleted ? colors.ink3 : colors.ink,
                  decoration: isCompleted ? TextDecoration.lineThrough : null,
                ),
              ),
            ),
            // Edit icon only
            IconButton(
              onPressed: () {},
              icon: Icon(
                PhosphorIcons.pencil(),
                size: 16,
                color: colors.ink3,
              ),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              style: IconButton.styleFrom(
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

