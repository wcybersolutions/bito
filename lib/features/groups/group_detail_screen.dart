// lib/features/groups/group_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:bito/theme/theme_extensions.dart';
import 'package:bito/shared/shared.dart';
import 'package:bito/data/groups/group.dart';

class GroupDetailScreen extends StatefulWidget {
  final String groupId;

  const GroupDetailScreen({
    super.key,
    required this.groupId,
  });

  @override
  State<GroupDetailScreen> createState() => _GroupDetailScreenState();
}

class _GroupDetailScreenState extends State<GroupDetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _selectedFeedFilter = 'ALL';
  final List<String> _feedFilters = ['ALL', 'STREAKS', 'KUDOS', 'GROUP INFO'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
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

    return Scaffold(
      backgroundColor: colors.bg,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context, colors, textTheme),
            _buildStats(context, colors, textTheme),
            _buildFeedTabs(context, colors),
            Expanded(
              child: _buildFeedContent(context, colors),
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
          Row(
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
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Morning Grind',
                    style: textTheme.headlineSmall?.copyWith(
                      color: colors.ink,
                    ),
                  ),
                  Text(
                    'TEAM · 2 MEMBERS · ACCOUNTABLE',
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
            ],
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(
              PhosphorIcons.dotsThree(),
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
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            _buildStatItem(
              context,
              label: 'ACTIVE TODAY',
              value: '0 / 1',
              colors: colors,
            ),
            Container(
              width: 1,
              height: 30,
              color: colors.line,
            ),
            _buildStatItem(
              context,
              label: 'COMPLETIONS',
              value: '9',
              colors: colors,
            ),
            Container(
              width: 1,
              height: 30,
              color: colors.line,
            ),
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
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: colors.ink,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              fontSize: 8,
              fontWeight: FontWeight.w700,
              color: colors.ink3,
              letterSpacing: 0.5,
              fontFamily: 'SpaceMono',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeedTabs(
      BuildContext context,
      BitoColorScheme colors,
      ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Feed Tabs (Members, Habits, Challenges)
          Row(
            children: [
              _buildFeedTab('FEED', true, colors),
              const SizedBox(width: 12),
              _buildFeedTab('MEMBERS', false, colors),
              const SizedBox(width: 12),
              _buildFeedTab('HABITS', false, colors),
              const SizedBox(width: 12),
              _buildFeedTab('CHALLENGES', false, colors),
            ],
          ),
          // Filter chips
          Row(
            children: _feedFilters.map((filter) {
              final isSelected = _selectedFeedFilter == filter;
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedFeedFilter = filter;
                  });
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: isSelected ? colors.signal : Colors.transparent,
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(
                      color: isSelected ? colors.signal : colors.line,
                    ),
                  ),
                  child: Text(
                    filter,
                    style: TextStyle(
                      fontSize: 8,
                      fontWeight: FontWeight.w700,
                      color: isSelected ? Colors.black : colors.ink2,
                      letterSpacing: 0.3,
                      fontFamily: 'SpaceMono',
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildFeedTab(
      String label,
      bool isSelected,
      BitoColorScheme colors,
      ) {
    return GestureDetector(
      onTap: () {
        // Navigate to different views
      },
      child: Text(
        label,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          color: isSelected ? colors.signal : colors.ink2,
          letterSpacing: 0.5,
          fontFamily: 'SpaceMono',
        ),
      ),
    );
  }

  Widget _buildFeedContent(
      BuildContext context,
      BitoColorScheme colors,
      ) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      children: [
        // Feed items
        _buildFeedItem(
          context,
          name: 'Joseph Katsande',
          action: 'completed Evening run',
          details: '· 2-day streak',
          time: '23H AGO',
          colors: colors,
        ),
        const SizedBox(height: 12),
        _buildFeedItem(
          context,
          name: 'Joseph Katsande',
          action: 'completed Yoga',
          details: '· 2-day streak',
          time: '23H AGO',
          colors: colors,
        ),
        const SizedBox(height: 12),
        _buildFeedItem(
          context,
          name: 'Joseph Katsande',
          action: 'completed Evening run',
          details: '',
          time: '5D AGO',
          colors: colors,
        ),
        const SizedBox(height: 12),
        _buildFeedItem(
          context,
          name: 'Joseph Katsande',
          action: 'completed Yoga',
          details: '',
          time: '5D AGO',
          colors: colors,
        ),
        const SizedBox(height: 12),
        _buildFeedItem(
          context,
          name: 'Joseph Katsande',
          action: 'completed Evening run',
          details: '',
          time: '6D AGO',
          colors: colors,
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildFeedItem(
      BuildContext context, {
        required String name,
        required String action,
        required String details,
        required String time,
        required BitoColorScheme colors,
      }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: colors.line.withValues(alpha: 0.5)),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: colors.signal.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              PhosphorIcons.checkCircle(),
              size: 16,
              color: colors.signal,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      name,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: colors.ink,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      action,
                      style: TextStyle(
                        fontSize: 13,
                        color: colors.ink2,
                      ),
                    ),
                    if (details.isNotEmpty)
                      Text(
                        details,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: colors.signal,
                          fontFamily: 'SpaceMono',
                        ),
                      ),
                  ],
                ),
                Text(
                  time,
                  style: TextStyle(
                    fontSize: 10,
                    color: colors.ink3,
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


