// lib/features/groups/create_group_step3.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:bito/theme/theme_extensions.dart';
import 'package:bito/shared/shared.dart';
import 'package:bito/data/groups/group.dart';

class CreateGroupStep3 extends StatefulWidget {
  const CreateGroupStep3({super.key});

  @override
  State<CreateGroupStep3> createState() => _CreateGroupStep3State();
}

class _CreateGroupStep3State extends State<CreateGroupStep3> {
  bool _privateGroup = true;
  GroupIntensity _intensity = GroupIntensity.supportive;

  void _updateIntensity(GroupIntensity intensity) {
    setState(() {
      _intensity = intensity;
    });
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
                              _buildPrivateToggle(context, colors),
                              const SizedBox(height: 24),
                              _buildIntensitySelector(context, colors),
                              const SizedBox(height: 24),
                              _buildSettingsList(context, colors),
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

  Widget _buildProgress(
      BuildContext context,
      BitoColorScheme colors,
      ) {
    final steps = ['DETAILS', 'STYLE', 'SETTINGS'];
    const activeStep = 2;

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
            style: textTheme.headlineSmall?.copyWith(
              color: colors.ink,
            ),
          ),
          IconButton(
            onPressed: () => context.go('/groups'),
            icon: Icon(
              PhosphorIcons.x(),
              size: 20,
              color: colors.ink2,
            ),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }

  Widget _buildPrivateToggle(
      BuildContext context,
      BitoColorScheme colors,
      ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Private group',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: colors.ink,
                  letterSpacing: 0.3,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                'Only invited members can join',
                style: TextStyle(
                  fontSize: 11,
                  color: colors.ink2,
                ),
              ),
            ],
          ),
        ),
        Switch(
          value: _privateGroup,
          onChanged: (val) {
            setState(() {
              _privateGroup = val;
            });
          },
          activeColor: colors.signal,
        ),
      ],
    );
  }

  Widget _buildIntensitySelector(
      BuildContext context,
      BitoColorScheme colors,
      ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'INTENSITY',
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w700,
            color: colors.ink3,
            letterSpacing: 1.2,
            fontFamily: 'SpaceMono',
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'GROUP INTENSITY',
          style: TextStyle(
            fontSize: 9,
            fontWeight: FontWeight.w700,
            color: colors.ink3,
            letterSpacing: 0.5,
            fontFamily: 'SpaceMono',
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Controls how much pressure this group applies. Changed by admins, applied to everyone.',
          style: TextStyle(
            fontSize: 12,
            color: colors.ink2,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            _buildIntensityButton(
              context,
              icon: PhosphorIcons.sun(),
              label: 'SUPPORTIVE',
              intensity: GroupIntensity.supportive,
              isSelected: _intensity == GroupIntensity.supportive,
              colors: colors,
            ),
            const SizedBox(width: 8),
            _buildIntensityButton(
              context,
              icon: PhosphorIcons.arrowsClockwise(),
              label: 'ACCOUNTABLE',
              intensity: GroupIntensity.accountable,
              isSelected: _intensity == GroupIntensity.accountable,
              colors: colors,
            ),
            const SizedBox(width: 8),
            _buildIntensityButton(
              context,
              icon: PhosphorIcons.lightning(),
              label: 'SHARP',
              intensity: GroupIntensity.sharp,
              isSelected: _intensity == GroupIntensity.sharp,
              colors: colors,
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          _intensity.description,
          style: TextStyle(
            fontSize: 12,
            color: colors.ink2,
          ),
        ),
      ],
    );
  }

  Widget _buildIntensityButton(
      BuildContext context, {
        required IconData icon,
        required String label,
        required GroupIntensity intensity,
        required bool isSelected,
        required BitoColorScheme colors,
      }) {
    return Expanded(
      child: GestureDetector(
        onTap: () => _updateIntensity(intensity),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? colors.signal2 : Colors.black,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isSelected ? colors.signal2 : colors.line,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 16,
                color: isSelected ? Colors.black : colors.ink2,
              ),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: isSelected ? Colors.black : colors.ink2,
                  letterSpacing: 0.5,
                  fontFamily: 'SpaceMono',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSettingsList(
      BuildContext context,
      BitoColorScheme colors,
      ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.bg2,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colors.line),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSettingItem(
            context,
            title: 'FEED EVENTS',
            value: _intensity.feedEvents,
            colors: colors,
          ),
          const SizedBox(height: 16),
          _buildSettingItem(
            context,
            title: 'MISSED DAYS',
            value: _intensity.missedDays,
            colors: colors,
          ),
          const SizedBox(height: 16),
          _buildSettingItem(
            context,
            title: 'NUDGES',
            value: _intensity.nudges,
            colors: colors,
          ),
          const SizedBox(height: 16),
          _buildSettingItem(
            context,
            title: 'LEADERBOARD',
            value: _intensity.leaderboard,
            colors: colors,
          ),
        ],
      ),
    );
  }

  Widget _buildSettingItem(
      BuildContext context, {
        required String title,
        required String value,
        required BitoColorScheme colors,
      }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: colors.ink3,
            letterSpacing: 0.5,
            fontFamily: 'SpaceMono',
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: colors.ink,
            fontFamily: 'SpaceMono',
          ),
        ),
      ],
    );
  }

  Widget _buildBottomActions(
      BuildContext context,
      BitoColorScheme colors,
      ) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: colors.line),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ActionButton(
            text: 'BACK',
            type: ButtonType.outline,
            icon: Icon(
              PhosphorIcons.arrowLeft(),
              size: 16,
              color: colors.ink2,
            ),
            onPressed: () => context.go('/groups/create/step2'),
            expanded: false,
          ),
          // Custom CREATE GROUP button with check icon on left
          ElevatedButton(
            onPressed: () {
              context.go('/groups/1');
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
                Icon(
                  PhosphorIcons.check(),
                  size: 16,
                  color: Colors.black,
                ),
                const SizedBox(width: 8),
                Text(
                  'CREATE GROUP',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
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
}

