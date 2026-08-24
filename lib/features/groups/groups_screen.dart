// lib/features/groups_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:bito/theme/theme_extensions.dart';
import 'package:bito/shared/shared.dart';

class GroupsScreen extends StatelessWidget {
  const GroupsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<BitoColorScheme>()!;
    final textTheme = Theme.of(context).textTheme;

    // Check if user has groups - for demo, we'll show empty state
    // In a real app, this would come from a provider
    const bool hasGroups = false; // Fixed: use const instead of final

    return Scaffold(
      backgroundColor: colors.bg,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Text(
                'Groups',
                style: textTheme.displayMedium?.copyWith(
                  color: colors.ink,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'TRACK HABITS TOGETHER : TEAM, FRIENDS, OR FAMILY',
                style: TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.w700,
                  color: colors.ink3,
                  letterSpacing: 0.5,
                  fontFamily: 'SpaceMono',
                ),
              ),
              const SizedBox(height: 24),

              // Show different content based on whether user has groups
              if (hasGroups)
                _buildGroupsList(context, colors, textTheme)
              else
                _buildEmptyState(context, colors, textTheme),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(
      BuildContext context,
      BitoColorScheme colors,
      TextTheme textTheme,
      ) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colors.line),
      ),
      child: Column(
        children: [
          Icon(
            PhosphorIcons.users(),
            size: 40,
            color: colors.ink3,
          ),
          const SizedBox(height: 16),
          Text(
            'NO GROUPS ON RECORD',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: colors.ink3,
              letterSpacing: 1.2,
              fontFamily: 'SpaceMono',
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Gather the troops',
            style: textTheme.headlineSmall?.copyWith(
              color: colors.ink,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Spin up a group from scratch, or punch in an invite code to join one someone shared with you.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              color: colors.ink2,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 16),
          // CREATE GROUP button - full width, on top
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                context.go('/groups/create/step1');
              },
              icon: Icon(
                PhosphorIcons.plus(),
                size: 16,
                color: Colors.black,
              ),
              label: Text(
                'CREATE GROUP',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                  letterSpacing: 0.5,
                  fontFamily: 'SpaceMono',
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: colors.signal2,
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 0,
              ),
            ),
          ),
          const SizedBox(height: 12),
          // JOIN WITH CODE button - full width, below
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () {
                _showJoinWithCodeDialog(context);
              },
              icon: Icon(
                PhosphorIcons.magnifyingGlass(),
                size: 16,
                color: colors.ink2,
              ),
              label: Text(
                'JOIN WITH CODE',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: colors.ink2,
                  letterSpacing: 0.5,
                  fontFamily: 'SpaceMono',
                ),
              ),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
                side: BorderSide(color: colors.line),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                foregroundColor: colors.ink2,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGroupsList(
      BuildContext context,
      BitoColorScheme colors,
      TextTheme textTheme,
      ) {
    // This would be a ListView.builder with actual groups data
    // For now, showing a sample group
    return Column(
      children: [
        _buildGroupCard(context, colors, textTheme, '1'), // Fixed: added groupId parameter
        const SizedBox(height: 16),
        // Add more groups here
      ],
    );
  }

  Widget _buildGroupCard(
      BuildContext context,
      BitoColorScheme colors,
      TextTheme textTheme,
      String groupId, // Added groupId parameter
      ) {
    return GestureDetector(
      onTap: () {
        context.go('/groups/$groupId');
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: colors.line),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: colors.signal.withValues(alpha: 0.1), // Fixed: use withValues
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                PhosphorIcons.users(),
                size: 24,
                color: colors.signal,
              ),
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
                  const SizedBox(height: 2),
                  Text(
                    'TEAM · 2 MEMBERS',
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
            Icon(
              PhosphorIcons.arrowRight(),
              size: 20,
              color: colors.ink3,
            ),
          ],
        ),
      ),
    );
  }

  void _showJoinWithCodeDialog(BuildContext context) {
    final colors = Theme.of(context).extension<BitoColorScheme>()!;
    final TextEditingController codeController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: colors.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: colors.line),
          ),
          title: Text(
            'JOIN WITH CODE',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: colors.ink3,
              letterSpacing: 1.2,
              fontFamily: 'SpaceMono',
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Enter the invite code shared with you to join a group.',
                style: TextStyle(
                  fontSize: 13,
                  color: colors.ink2,
                ),
              ),
              const SizedBox(height: 16),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: colors.line),
                ),
                child: TextField(
                  controller: codeController,
                  style: TextStyle(
                    fontSize: 16,
                    color: colors.ink,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Enter code',
                    hintStyle: TextStyle(
                      color: colors.ink3,
                      fontSize: 16,
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'CANCEL',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: colors.ink2,
                  fontFamily: 'SpaceMono',
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                // Join group logic
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: colors.signal,
                foregroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 0,
              ),
              child: Text(
                'JOIN',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                  fontFamily: 'SpaceMono',
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
