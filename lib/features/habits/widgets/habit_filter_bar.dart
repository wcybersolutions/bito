// lib/features/habits/widgets/habit_filter_bar.dart
import 'package:flutter/material.dart';
import '../../../theme/theme_extensions.dart';

class HabitFilterBar extends StatefulWidget {
  final List<String> filters;
  final String selectedFilter;
  final ValueChanged<String> onFilterChanged;

  const HabitFilterBar({
    super.key,
    required this.filters,
    required this.selectedFilter,
    required this.onFilterChanged,
  });

  @override
  State<HabitFilterBar> createState() => _HabitFilterBarState();
}

class _HabitFilterBarState extends State<HabitFilterBar> {
  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<BitoColorScheme>()!;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: widget.filters.map((filter) {
          final isSelected = filter == widget.selectedFilter;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              label: Text(
                filter,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: isSelected ? colors.signalInk : colors.ink2,
                  letterSpacing: 0.5,
                ),
              ),
              selected: isSelected,
              onSelected: (_) => widget.onFilterChanged(filter),
              backgroundColor: colors.surface,
              selectedColor: colors.signal,
              side: BorderSide(
                color: isSelected ? colors.signal : colors.line,
                width: 1,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            ),
          );
        }).toList(),
      ),
    );
  }
}
