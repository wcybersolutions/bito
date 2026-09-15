// lib/features/groups/create_group_step2.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:bito/shared/shared.dart';
import 'package:bito/data/groups/groups_provider.dart';

class CreateGroupStep2 extends ConsumerStatefulWidget {
  const CreateGroupStep2({super.key});

  @override
  ConsumerState<CreateGroupStep2> createState() => _CreateGroupStep2State();
}

class _CreateGroupStep2State extends ConsumerState<CreateGroupStep2> {
  late Color _selectedColor;
  final List<Color> _colors = [
    const Color(0xFF6F4EE6),
    const Color(0xFF2563EB),
    const Color(0xFF22C55E),
    const Color(0xFFF59E0B),
    const Color(0xFFF97316),
    const Color(0xFFEF4444),
    const Color(0xFFE11D48),
    const Color(0xFF8B5CF6),
    const Color(0xFF06B6D4),
    const Color(0xFF10B981),
    const Color(0xFFF472B6),
    const Color(0xFF6366F1),
  ];

  @override
  void initState() {
    super.initState();
    _selectedColor = ref.read(groupDraftProvider).color;
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<BitoColorScheme>()!;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: colors.bg,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context, colors, textTheme),
            _buildProgress(context, colors),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  decoration: BoxDecoration(
                    color: colors.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: colors.line),
                  ),
                  child: Column(
                    children: [
                      _buildCardHeader(context, colors, textTheme),
                      Expanded(
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildColorSelector(context, colors, textTheme),
                              const SizedBox(height: 16),
                            ],
                          ),
                        ),
                      ),
                      _buildBottomActions(context, colors),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(
    BuildContext context,
    BitoColorScheme colors,
    TextTheme textTheme,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'GROUP SETUP',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: colors.ink3,
              letterSpacing: 1.2,
              fontFamily: 'SpaceMono',
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: colors.line2,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              'QUICK MODE',
              style: TextStyle(
                fontSize: 8,
                fontWeight: FontWeight.w700,
                color: colors.ink3,
                letterSpacing: 0.5,
                fontFamily: 'SpaceMono',
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgress(BuildContext context, BitoColorScheme colors) {
    final steps = ['DETAILS', 'STYLE', 'SETTINGS'];
    const activeStep = 1;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(steps.length, (index) {
          final isActive = index <= activeStep;
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 4),
            child: Column(
              children: [
                Container(
                  width: 60,
                  height: 3,
                  decoration: BoxDecoration(
                    color: isActive ? colors.signal : colors.line2,
                    borderRadius: BorderRadius.circular(1.5),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  steps[index],
                  style: TextStyle(
                    fontSize: 7,
                    fontWeight: FontWeight.w700,
                    color: isActive ? colors.signal : colors.ink3,
                    letterSpacing: 0.5,
                    fontFamily: 'SpaceMono',
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildCardHeader(
    BuildContext context,
    BitoColorScheme colors,
    TextTheme textTheme,
  ) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'New Group',
            style: textTheme.headlineSmall?.copyWith(color: colors.ink),
          ),
          IconButton(
            onPressed: () => context.go('/groups'),
            icon: Icon(PhosphorIcons.x(), size: 20, color: colors.ink2),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }

  Widget _buildColorSelector(
    BuildContext context,
    BitoColorScheme colors,
    TextTheme textTheme,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'COLORS',
          style: TextStyle(
            fontSize: 10,
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
          children: _colors.map((color) {
            final isSelected = _selectedColor == color;
            return GestureDetector(
              onTap: () {
                setState(() {
                  _selectedColor = color;
                });
              },
              child: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: color,
                  border: isSelected
                      ? Border.all(color: colors.ink, width: 2)
                      : null,
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 16),
        _buildGroupPreview(context, colors, textTheme),
      ],
    );
  }

  Widget _buildGroupPreview(
    BuildContext context,
    BitoColorScheme colors,
    TextTheme textTheme,
  ) {
    final lightColor = _selectedColor.withOpacity(0.15);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: lightColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colors.line),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: _selectedColor.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(PhosphorIcons.users(), size: 24, color: _selectedColor),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Morning Grind',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: colors.ink,
                  ),
                ),
                Text(
                  'MORNING RUN',
                  style: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                    color: colors.ink3,
                    letterSpacing: 0.5,
                    fontFamily: 'SpaceMono',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomActions(BuildContext context, BitoColorScheme colors) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: colors.line)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ActionButton(
            text: 'BACK',
            type: ButtonType.outline,
            icon: Icon(PhosphorIcons.arrowLeft(), size: 16, color: colors.ink2),
            onPressed: () => context.go('/groups/create/step1'),
            expanded: false,
          ),
          // Custom CONTINUE button with arrow on right
          ElevatedButton(
            onPressed: () {
              ref.read(groupDraftProvider.notifier).updateColor(_selectedColor);
              context.go('/groups/create/step3');
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
                Icon(PhosphorIcons.arrowRight(), size: 16, color: Colors.black),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
