// lib/features/groups/create_group_step1.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:bito/theme/theme_extensions.dart';
import 'package:bito/shared/shared.dart';
import 'package:bito/data/groups/group.dart';

class CreateGroupStep1 extends StatefulWidget {
  const CreateGroupStep1({super.key});

  @override
  State<CreateGroupStep1> createState() => _CreateGroupStep1State();
}

class _CreateGroupStep1State extends State<CreateGroupStep1> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  GroupType _selectedType = GroupType.personal;

  final List<GroupType> _groupTypes = [
    GroupType.personal,
    GroupType.team,
    GroupType.family,
    GroupType.fitness,
    GroupType.study,
    GroupType.community,
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
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
                              _buildNameField(context, colors),
                              const SizedBox(height: 16),
                              _buildDescriptionField(context, colors),
                              const SizedBox(height: 16),
                              _buildGroupTypeSelector(context, colors),
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
    const activeStep = 0;

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

  Widget _buildNameField(
      BuildContext context,
      BitoColorScheme colors,
      ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'GROUP NAME*',
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w700,
            color: colors.ink3,
            letterSpacing: 1.2,
            fontFamily: 'SpaceMono',
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: colors.line),
            color: Colors.black,
          ),
          child: TextField(
            controller: _nameController,
            style: TextStyle(
              fontSize: 16,
              color: colors.ink,
            ),
            decoration: InputDecoration(
              hintText: 'Morning Grind',
              hintStyle: TextStyle(
                color: colors.ink3,
                fontSize: 16,
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDescriptionField(
      BuildContext context,
      BitoColorScheme colors,
      ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'DESCRIPTION',
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w700,
            color: colors.ink3,
            letterSpacing: 1.2,
            fontFamily: 'SpaceMono',
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: colors.line),
            color: Colors.black,
          ),
          child: TextField(
            controller: _descriptionController,
            maxLines: 3,
            style: TextStyle(
              fontSize: 16,
              color: colors.ink,
            ),
            decoration: InputDecoration(
              hintText: 'Morning run',
              hintStyle: TextStyle(
                color: colors.ink3,
                fontSize: 16,
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGroupTypeSelector(
      BuildContext context,
      BitoColorScheme colors,
      ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'GROUP TYPE',
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w700,
            color: colors.ink3,
            letterSpacing: 1.2,
            fontFamily: 'SpaceMono',
          ),
        ),
        const SizedBox(height: 12),
        GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          childAspectRatio: 4.5, // Makes buttons wider than tall
          children: _groupTypes.map((type) {
            final isSelected = _selectedType == type;
            return GestureDetector(
              onTap: () {
                setState(() {
                  _selectedType = type;
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
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
                      type.icon,
                      size: 16,
                      color: isSelected ? Colors.black : colors.ink2,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      type.label,
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
            );
          }).toList(),
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
            text: 'CANCEL',
            type: ButtonType.cancel,
            icon: Icon(
              PhosphorIcons.arrowLeft(),
              size: 16,
              color: colors.ink2,
            ),
            onPressed: () => context.go('/groups'),
            expanded: false,
          ),
          ElevatedButton(
            onPressed: () {
              context.go('/groups/create/step2');
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
                Icon(
                  PhosphorIcons.arrowRight(),
                  size: 16,
                  color: Colors.black,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
