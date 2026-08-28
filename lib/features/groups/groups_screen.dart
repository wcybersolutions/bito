// lib/features/groups/groups_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:bito/theme/theme_extensions.dart';
import 'package:bito/data/groups/group.dart';
import 'package:bito/data/groups/groups_provider.dart';

class GroupsScreen extends ConsumerWidget {
  const GroupsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).extension<BitoColorScheme>()!;
    final textTheme = Theme.of(context).textTheme;
    final groupsAsync = ref.watch(groupsProvider);

    return Scaffold(
      backgroundColor: colors.bg,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Small tracking header
              Text(
                'THE BASECAMPS',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: colors.ink3,
                  letterSpacing: 1.2,
                  fontFamily: 'SpaceMono',
                ),
              ),
              const SizedBox(height: 6),

              // Title and Actions Button
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Groups',
                    style: textTheme.displayMedium?.copyWith(
                      color: colors.ink,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: () => _showGroupActionsSheet(context),
                    icon: Icon(
                      PhosphorIcons.list(),
                      size: 15,
                      color: Colors.black,
                    ),
                    label: const Text(
                      'ACTIONS',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        color: Colors.black,
                        letterSpacing: 0.6,
                        fontFamily: 'SpaceMono',
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colors.signal2,
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: 0,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),

              // Summary Stats Line
              groupsAsync.when(
                data: (groups) {
                  final activeCount = groups.length.toString().padLeft(2, '0');
                  final totalMembers = groups.fold<int>(0, (sum, g) => sum + g.memberCount);
                  return Row(
                    children: [
                      Text(
                        '$activeCount ACTIVE',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: colors.signal2,
                          letterSpacing: 0.5,
                          fontFamily: 'SpaceMono',
                        ),
                      ),
                      Text(
                        ' · $totalMembers MEMBERS · 3 SHARED HABITS',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: colors.ink3,
                          letterSpacing: 0.5,
                          fontFamily: 'SpaceMono',
                        ),
                      ),
                    ],
                  );
                },
                loading: () => Text(
                  '01 ACTIVE · 1 MEMBERS · 3 SHARED HABITS',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: colors.ink3,
                    letterSpacing: 0.5,
                    fontFamily: 'SpaceMono',
                  ),
                ),
                error: (_, __) => Text(
                  '00 ACTIVE · 0 MEMBERS',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: colors.ink3,
                    letterSpacing: 0.5,
                    fontFamily: 'SpaceMono',
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Divider(height: 1, color: colors.line),
              const SizedBox(height: 16),

              // Group List or Empty State
              groupsAsync.when(
                data: (groups) {
                  if (groups.isEmpty) {
                    return _buildEmptyState(context, colors, textTheme);
                  }
                  return _buildGroupsList(context, colors, textTheme, groups);
                },
                loading: () => Center(
                  child: Padding(
                    padding: const EdgeInsets.all(40),
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: colors.signal,
                    ),
                  ),
                ),
                error: (_, __) => _buildEmptyState(context, colors, textTheme),
              ),
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
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: colors.line),
      ),
      child: Column(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: colors.signal2.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(
              PhosphorIcons.users(),
              size: 24,
              color: colors.signal2,
            ),
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
              fontWeight: FontWeight.w700,
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
          const SizedBox(height: 20),
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
              label: const Text(
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
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () {
                _showGroupActionsSheet(context);
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
      List<Group> groups,
      ) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: groups.length,
      separatorBuilder: (_, __) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        return _buildGroupCard(context, colors, textTheme, groups[index], index + 1);
      },
    );
  }

  Widget _buildGroupCard(
      BuildContext context,
      BitoColorScheme colors,
      TextTheme textTheme,
      Group group,
      int index,
      ) {
    final memberCountStr = group.memberCount.toString().padLeft(2, '0');
    final indexStr = index.toString().padLeft(2, '0');

    return GestureDetector(
      onTap: () {
        context.go('/groups/${group.id}');
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: colors.line),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Card Top Row: Group Icon Badge and Group Index (№ 01)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: group.color.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: group.color.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Icon(
                    group.type.icon,
                    size: 20,
                    color: group.color,
                  ),
                ),
                Text(
                  '№ $indexStr',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: colors.ink3,
                    fontFamily: 'SpaceMono',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),

            // Group Name
            Text(
              group.name,
              style: textTheme.titleLarge?.copyWith(
                color: colors.ink,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 4),

            // Members & Active subtext
            Row(
              children: [
                Text(
                  '$memberCountStr ${group.memberCount == 1 ? 'MEMBER' : 'MEMBERS'} · ',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: colors.ink3,
                    letterSpacing: 0.5,
                    fontFamily: 'SpaceMono',
                  ),
                ),
                Text(
                  '1 ACTIVE',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: colors.signal2,
                    letterSpacing: 0.5,
                    fontFamily: 'SpaceMono',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Divider(height: 1, color: colors.line),
            const SizedBox(height: 12),

            // Card Bottom Row: Avatar + Type Pill, and Arrow Button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 14,
                      backgroundColor: colors.surface2,
                      child: Icon(PhosphorIcons.user(), size: 14, color: colors.ink),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: group.color.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                          color: group.color.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Text(
                        group.type.label,
                        style: TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.w700,
                          color: group.color,
                          letterSpacing: 0.5,
                          fontFamily: 'SpaceMono',
                        ),
                      ),
                    ),
                  ],
                ),
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: colors.line),
                  ),
                  child: Icon(
                    PhosphorIcons.arrowRight(),
                    size: 16,
                    color: colors.ink2,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showGroupActionsSheet(BuildContext context) {
    final colors = Theme.of(context).extension<BitoColorScheme>()!;
    final textTheme = Theme.of(context).textTheme;
    final TextEditingController codeController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        return Consumer(
          builder: (context, ref, _) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(sheetContext).viewInsets.bottom,
              ),
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: colors.surface,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                  border: Border.all(color: colors.line),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Handle
                    Center(
                      child: Container(
                        width: 36,
                        height: 4,
                        decoration: BoxDecoration(
                          color: colors.line2,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Title
                    Text(
                      'Group Actions',
                      style: textTheme.titleLarge?.copyWith(
                        color: colors.ink,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Join an existing group or create a new one.',
                      style: TextStyle(
                        fontSize: 13,
                        color: colors.ink2,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // JOIN BY CODE OR QR section
                    Text(
                      'JOIN BY CODE OR QR',
                      style: TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.w700,
                        color: colors.ink3,
                        letterSpacing: 0.8,
                        fontFamily: 'SpaceMono',
                      ),
                    ),
                    const SizedBox(height: 8),

                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: colors.bg,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: colors.line),
                            ),
                            child: TextField(
                              controller: codeController,
                              style: TextStyle(
                                fontSize: 13,
                                color: colors.ink,
                                fontFamily: 'SpaceMono',
                                fontWeight: FontWeight.w600,
                              ),
                              textCapitalization: TextCapitalization.characters,
                              decoration: InputDecoration(
                                hintText: 'PASTE INVITE CODE...',
                                hintStyle: TextStyle(
                                  color: colors.ink3,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'SpaceMono',
                                  letterSpacing: 0.5,
                                ),
                                border: InputBorder.none,
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 14,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        GestureDetector(
                          onTap: () async {
                            final code = codeController.text.trim();
                            if (code.isNotEmpty) {
                              try {
                                final joined = await ref
                                    .read(groupCreationProvider.notifier)
                                    .joinGroup(code);
                                if (sheetContext.mounted) {
                                  Navigator.pop(sheetContext);
                                  context.go('/groups/${joined.id}');
                                }
                              } catch (_) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Invalid invite code'),
                                  ),
                                );
                              }
                            }
                          },
                          child: Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: colors.signal2.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: colors.signal2.withValues(alpha: 0.3),
                              ),
                            ),
                            child: Icon(
                              PhosphorIcons.qrCode(),
                              color: colors.signal2,
                              size: 22,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // OR divider
                    Row(
                      children: [
                        Expanded(child: Divider(color: colors.line)),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Text(
                            'OR',
                            style: TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.w700,
                              color: colors.ink3,
                              fontFamily: 'SpaceMono',
                            ),
                          ),
                        ),
                        Expanded(child: Divider(color: colors.line)),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // CREATE NEW GROUP button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.pop(sheetContext);
                          context.go('/groups/create/step1');
                        },
                        icon: Icon(
                          PhosphorIcons.plus(),
                          size: 16,
                          color: Colors.black,
                        ),
                        label: const Text(
                          'CREATE NEW GROUP',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                            color: Colors.black,
                            letterSpacing: 0.5,
                            fontFamily: 'SpaceMono',
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: colors.signal2,
                          foregroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          elevation: 0,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
