// lib/shared/components/theme_dropdown.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../core/providers/theme_provider.dart';
import '../../theme/theme_extensions.dart';

class ThemeDropdown extends ConsumerStatefulWidget {
  const ThemeDropdown({super.key});

  @override
  ConsumerState<ThemeDropdown> createState() => _ThemeDropdownState();
}

class _ThemeDropdownState extends ConsumerState<ThemeDropdown> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<BitoColorScheme>()!;
    final currentTheme = ref.watch(themeProvider);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              _isExpanded = !_isExpanded;
            });
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: colors.surface2,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(
                  PhosphorIcons.palette(),
                  size: 18,
                  color: colors.ink2,
                ),
                const SizedBox(width: 10),
                Text(
                  'Theme',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: colors.ink,
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: colors.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: colors.line),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        currentTheme.icon,
                        size: 14,
                        color: colors.signal2,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        currentTheme.label,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: colors.ink3,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Icon(
                        _isExpanded
                            ? PhosphorIcons.caretUp()
                            : PhosphorIcons.caretDown(),
                        size: 12,
                        color: colors.ink3,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        if (_isExpanded) ...[
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              color: colors.surface,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: colors.line),
            ),
            child: Column(
              children: AppThemeMode.values.map((mode) {
                final isSelected = currentTheme == mode;
                return InkWell(
                  onTap: () {
                    ref.read(themeProvider.notifier).setTheme(mode);
                    setState(() {
                      _isExpanded = false;
                    });
                  },
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? colors.signal.withValues(alpha: 0.08)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          mode.icon,
                          size: 18,
                          color: isSelected ? colors.signal : colors.ink2,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          mode.label,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: isSelected ? colors.signal : colors.ink,
                          ),
                        ),
                        const Spacer(),
                        if (isSelected)
                          Icon(
                            PhosphorIcons.check(),
                            size: 16,
                            color: colors.signal,
                          ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ],
    );
  }
}

