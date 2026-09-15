// lib/features/groups/group_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:bito/theme/theme_extensions.dart';
import 'package:bito/data/groups/group.dart';
import 'package:bito/data/groups/groups_provider.dart';
import 'package:bito/data/groups/group_habits_provider.dart';
import 'package:bito/data/groups/group_challenges_provider.dart';
import 'package:bito/features/groups/feed/feed_tab.dart';
import 'package:bito/features/groups/members/members_tab.dart';
import 'package:bito/features/groups/habits/habits_tab.dart';
import 'package:bito/features/groups/challenges/challenges_tab.dart';
import 'package:bito/features/groups/widgets/invites_and_sharing_sheet.dart';

class GroupDetailScreen extends ConsumerStatefulWidget {
  final String groupId;

  const GroupDetailScreen({super.key, required this.groupId});

  @override
  ConsumerState<GroupDetailScreen> createState() => _GroupDetailScreenState();
}

class _GroupDetailScreenState extends ConsumerState<GroupDetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(() {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<BitoColorScheme>()!;
    final textTheme = Theme.of(context).textTheme;

    final groupsAsync = ref.watch(groupsProvider);
    final groupHabits = ref.watch(groupHabitsListProvider(widget.groupId));
    final groupChallenges =
        ref.watch(groupChallengesListProvider(widget.groupId));

    final group = groupsAsync.maybeWhen(
      data: (groups) => groups.firstWhere(
        (g) => g.id == widget.groupId,
        orElse: () => _getDefaultFallbackGroup(),
      ),
      orElse: () => _getDefaultFallbackGroup(),
    );

    return Scaffold(
      backgroundColor: colors.bg,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context, colors, textTheme, group),
            _buildStats(context, colors, textTheme),
            const SizedBox(height: 14),
            _buildTabsBar(colors, group, groupHabits.length, groupChallenges.length),
            const SizedBox(height: 14),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  FeedTab(group: group),
                  MembersTab(
                    group: group,
                    onInvite: () => InvitesAndSharingSheet.show(context, group),
                  ),
                  HabitsTab(groupId: widget.groupId),
                  ChallengesTab(group: group),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Group _getDefaultFallbackGroup() {
    return Group(
      id: widget.groupId,
      name: 'Morning Grind',
      description: 'Morning run group',
      type: GroupType.team,
      intensity: GroupIntensity.accountable,
      color: const Color(0xFF6F4EE6),
      isPrivate: true,
      inviteCode: 'ABC123',
      memberCount: 1,
      createdAt: DateTime.now(),
    );
  }

  Widget _buildHeader(
    BuildContext context,
    BitoColorScheme colors,
    TextTheme textTheme,
    Group group,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
              children: [
                IconButton(
                  onPressed: () => context.go('/groups'),
                  icon: Icon(
                    PhosphorIcons.arrowLeft(),
                    size: 20,
                    color: colors.ink,
                  ),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
                const SizedBox(width: 12),
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: group.color.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: group.color.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Icon(group.type.icon, size: 20, color: group.color),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        group.name,
                        style: textTheme.titleMedium?.copyWith(
                          color: colors.ink,
                          fontWeight: FontWeight.w700,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${group.type.label.toUpperCase()} · ${group.memberCount} ${group.memberCount == 1 ? 'MEMBER' : 'MEMBERS'} · ${group.intensity.label.toUpperCase()}',
                        style: TextStyle(
                          fontSize: 8,
                          fontWeight: FontWeight.w700,
                          color: colors.ink3,
                          letterSpacing: 0.5,
                          fontFamily: 'SpaceMono',
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                onTap: () => InvitesAndSharingSheet.show(context, group),
                behavior: HitTestBehavior.opaque,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                  child: Icon(
                    PhosphorIcons.qrCode(),
                    size: 20,
                    color: colors.ink2,
                  ),
                ),
              ),
              const SizedBox(width: 4),
              GestureDetector(
                onTap: () => _showGroupOptions(context, colors, group),
                behavior: HitTestBehavior.opaque,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                  child: Icon(
                    PhosphorIcons.gear(),
                    size: 20,
                    color: colors.ink2,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStats(
    BuildContext context,
    BitoColorScheme colors,
    TextTheme textTheme,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: colors.line),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            _buildStatItem(
              context,
              label: 'ACTIVE TODAY',
              value: '0 / 1',
              colors: colors,
            ),
            Container(width: 1, height: 28, color: colors.line),
            _buildStatItem(
              context,
              label: 'COMPLETIONS',
              value: '20',
              colors: colors,
            ),
            Container(width: 1, height: 28, color: colors.line),
            _buildStatItem(
              context,
              label: 'TEAM GOAL',
              value: '—',
              colors: colors,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(
    BuildContext context, {
    required String label,
    required String value,
    required BitoColorScheme colors,
  }) {
    return Expanded(
      child: Column(
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 8,
              fontWeight: FontWeight.w700,
              color: colors.ink3,
              letterSpacing: 0.8,
              fontFamily: 'SpaceMono',
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: colors.ink,
              fontFamily: 'SpaceMono',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabsBar(
    BitoColorScheme colors,
    Group group,
    int habitsCount,
    int challengesCount,
  ) {
    final tabLabels = [
      'FEED',
      'MEMBERS ${group.memberCount}',
      'HABITS $habitsCount',
      'CHALLENGES $challengesCount',
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: colors.line, width: 1),
          ),
        ),
        child: TabBar(
          controller: _tabController,
          isScrollable: false,
          indicatorColor: colors.signal2,
          indicatorWeight: 2,
          indicatorSize: TabBarIndicatorSize.tab,
          labelColor: colors.signal2,
          unselectedLabelColor: colors.ink3,
          labelPadding: const EdgeInsets.symmetric(horizontal: 2),
          labelStyle: const TextStyle(
            fontSize: 9.5,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.2,
            fontFamily: 'SpaceMono',
          ),
          unselectedLabelStyle: const TextStyle(
            fontSize: 9.5,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.2,
            fontFamily: 'SpaceMono',
          ),
          dividerColor: Colors.transparent,
          tabs: tabLabels.map((lbl) => Tab(text: lbl, height: 32)).toList(),
        ),
      ),
    );
  }

  void _showGroupOptions(
    BuildContext context,
    BitoColorScheme colors,
    Group group,
  ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: colors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(PhosphorIcons.shareNetwork(), color: colors.ink),
                title: Text(
                  'Share Group',
                  style: TextStyle(color: colors.ink),
                ),
                onTap: () {
                  Navigator.pop(ctx);
                  InvitesAndSharingSheet.show(context, group);
                },
              ),
              ListTile(
                leading: Icon(PhosphorIcons.gear(), color: colors.ink),
                title: Text(
                  'Group Settings',
                  style: TextStyle(color: colors.ink),
                ),
                onTap: () {
                  Navigator.pop(ctx);
                },
              ),
              ListTile(
                leading: Icon(PhosphorIcons.signOut(), color: colors.error),
                title: Text(
                  'Leave Group',
                  style: TextStyle(color: colors.error),
                ),
                onTap: () {
                  Navigator.pop(ctx);
                  context.go('/groups');
                },
              ),
            ],
          ),
        );
      },
    );
  }
}


