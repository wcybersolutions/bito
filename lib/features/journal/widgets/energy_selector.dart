// lib/features/journal/widgets/energy_selector.dart
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

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

  static const List<Color> energyColors = [
    Color(0xFFEF4444), // Empty / Red
    Color(0xFFF97316), // Low / Orange (red fades)
    Color(0xFFEAB308), // Medium / Yellow
    Color(0xFF84CC16), // High / Lime (close to green)
    Color(0xFF22C55E), // Full / Green
  ];

  @override
  Widget build(BuildContext context) {
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
        final color = energyColors[index];
        return GestureDetector(
          onTap: () => onSelect(index),
          child: Container(
            padding: const EdgeInsets.all(4),
            margin: const EdgeInsets.only(left: 2),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isSelected ? color.withValues(alpha: 0.2) : Colors.transparent,
              border: isSelected ? Border.all(color: color, width: 1.5) : null,
            ),
            child: Icon(
              batteryIcons[index],
              size: iconSize,
              color: isSelected ? color : color.withValues(alpha: 0.4),
            ),
          ),
        );
      }),
    );
  }
}

