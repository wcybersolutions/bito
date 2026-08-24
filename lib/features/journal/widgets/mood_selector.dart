// lib/features/journal/widgets/mood_selector.dart
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:bito/theme/theme_extensions.dart';

class MoodSelector extends StatelessWidget {
  final int? selectedMood;
  final Function(int) onSelect;

  const MoodSelector({
    super.key,
    required this.selectedMood,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<BitoColorScheme>()!;

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
        return GestureDetector(
          onTap: () => onSelect(index),
          child: Container(
            padding: const EdgeInsets.all(6),
            margin: const EdgeInsets.only(right: 4),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isSelected ? colors.signal : Colors.transparent,
            ),
            child: Icon(
              moodIcons[index],
              size: 20,
              color: isSelected ? colors.signalInk : colors.ink3,
            ),
          ),
        );
      }),
    );
  }
}

