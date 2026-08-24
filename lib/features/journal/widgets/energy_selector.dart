// lib/features/journal/widgets/energy_selector.dart
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:bito/theme/theme_extensions.dart';

class EnergySelector extends StatelessWidget {
  final int? selectedEnergy;
  final Function(int) onSelect;
  final double iconSize;

  const EnergySelector({
    super.key,
    required this.selectedEnergy,
    required this.onSelect,
    this.iconSize = 18,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<BitoColorScheme>()!;

    final batteryIcons = [
      PhosphorIcons.batteryEmpty(),
      PhosphorIcons.batteryLow(),
      PhosphorIcons.batteryMedium(),
      PhosphorIcons.batteryHigh(),
      PhosphorIcons.batteryFull(),
    ];

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        final isSelected = selectedEnergy == index;
        return GestureDetector(
          onTap: () => onSelect(index),
          child: Container(
            padding: const EdgeInsets.all(4),
            margin: const EdgeInsets.only(left: 2),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isSelected ? colors.signal.withOpacity(0.15) : Colors.transparent,
            ),
            child: Icon(
              batteryIcons[index],
              size: iconSize,
              color: isSelected ? colors.signal : colors.ink3,
            ),
          ),
        );
      }),
    );
  }
}

