// lib/features/journal/widgets/mood_selector.dart
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class MoodSelector extends StatelessWidget {
  final int? selectedMood;
  final Function(int) onSelect;

  const MoodSelector({
    super.key,
    required this.selectedMood,
    required this.onSelect,
  });

  static const List<Color> moodColors = [
    Color(0xFFEF4444), // Terrible / Red
    Color(0xFFF97316), // Sad / Orange (red fades)
    Color(0xFFEAB308), // Neutral / Yellow
    Color(0xFF84CC16), // Happy / Lime (close to green)
    Color(0xFF22C55E), // Ecstatic / Green
  ];

  @override
  Widget build(BuildContext context) {
    final moodIcons = [
      PhosphorIcons.smileyXEyes(),
      PhosphorIcons.smileySad(),
      PhosphorIcons.smileyMeh(),
      PhosphorIcons.smiley(),
      PhosphorIcons.smileyWink(),
    ];

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        final isSelected = selectedMood == index;
        final color = moodColors[index];
        return GestureDetector(
          onTap: () => onSelect(index),
          child: Container(
            padding: const EdgeInsets.all(6),
            margin: const EdgeInsets.only(right: 4),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isSelected ? color.withValues(alpha: 0.2) : Colors.transparent,
              border: isSelected ? Border.all(color: color, width: 1.5) : null,
            ),
            child: Icon(
              moodIcons[index],
              size: 20,
              color: isSelected ? color : color.withValues(alpha: 0.4),
            ),
          ),
        );
      }),
    );
  }
}

