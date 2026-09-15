// lib/features/groups/feed/feed_tab.dart
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:bito/theme/theme_extensions.dart';
import 'package:bito/data/groups/group.dart';

class GroupFeedItem {
  final String id;
  final String userName;
  final String userAvatar;
  final String habitName;
  final String? streakInfo;
  final String timeAgo;
  final String type; // 'completion', 'streak', 'kudos'
  int likesCount;
  bool isLiked;
  final List<String> reactions;

  GroupFeedItem({
    required this.id,
    required this.userName,
    required this.userAvatar,
    required this.habitName,
    this.streakInfo,
    required this.timeAgo,
    required this.type,
    this.likesCount = 0,
    this.isLiked = false,
    List<String>? reactions,
  }) : reactions = reactions ?? [];
}

class FeedTab extends StatefulWidget {
  final Group group;

  const FeedTab({super.key, required this.group});

  @override
  State<FeedTab> createState() => _FeedTabState();
}

class _FeedTabState extends State<FeedTab> {
  String _selectedFilter = 'ALL';
  final List<String> _filters = ['ALL', 'STREAKS', 'KUDOS'];
  String? _activePickerItemId;

  late List<GroupFeedItem> _feedItems;

  @override
  void initState() {
    super.initState();
    _feedItems = [
      GroupFeedItem(
        id: '1',
        userName: 'Joseph Katsande',
        userAvatar: 'J',
        habitName: 'Yoga',
        timeAgo: '21H AGO',
        type: 'completion',
        likesCount: 1,
        isLiked: true,
      ),
      GroupFeedItem(
        id: '2',
        userName: 'Joseph Katsande',
        userAvatar: 'J',
        habitName: 'Morning run',
        timeAgo: '21H AGO',
        type: 'completion',
      ),
      GroupFeedItem(
        id: '3',
        userName: 'Joseph Katsande',
        userAvatar: 'J',
        habitName: 'Evening run',
        timeAgo: '21H AGO',
        type: 'completion',
      ),
      GroupFeedItem(
        id: '4',
        userName: 'Joseph Katsande',
        userAvatar: 'J',
        habitName: 'Evening run',
        streakInfo: '2-day streak',
        timeAgo: '3D AGO',
        type: 'streak',
      ),
      GroupFeedItem(
        id: '5',
        userName: 'Joseph Katsande',
        userAvatar: 'J',
        habitName: 'Morning run',
        timeAgo: '3D AGO',
        type: 'completion',
      ),
    ];
  }

  List<GroupFeedItem> get _filteredItems {
    if (_selectedFilter == 'STREAKS') {
      return _feedItems
          .where((i) => i.streakInfo != null || i.type == 'streak')
          .toList();
    }
    if (_selectedFilter == 'KUDOS') {
      return _feedItems
          .where((i) => i.likesCount > 0 || i.reactions.isNotEmpty)
          .toList();
    }
    return _feedItems;
  }

  void _toggleLike(GroupFeedItem item) {
    setState(() {
      item.isLiked = !item.isLiked;
      if (item.isLiked) {
        item.likesCount += 1;
      } else {
        item.likesCount = (item.likesCount - 1).clamp(0, 999);
      }
    });
  }

  void _addReaction(GroupFeedItem item, String emoji) {
    setState(() {
      if (!item.reactions.contains(emoji)) {
        item.reactions.add(emoji);
      } else {
        item.reactions.remove(emoji);
      }
      _activePickerItemId = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<BitoColorScheme>()!;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Filter Chips and Group Info button row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Filter chips
              Row(
                children: _filters.map((filter) {
                  final isSelected = _selectedFilter == filter;
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedFilter = filter;
                      });
                    },
                    child: Container(
                      margin: const EdgeInsets.only(right: 8),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected ? colors.signal2 : Colors.transparent,
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                          color: isSelected ? colors.signal2 : colors.line,
                        ),
                      ),
                      child: Text(
                        filter,
                        style: TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.w800,
                          color: isSelected ? Colors.black : colors.ink2,
                          letterSpacing: 0.5,
                          fontFamily: 'SpaceMono',
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),

              // GROUP INFO button
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: colors.surface,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: colors.line),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(PhosphorIcons.users(), size: 13, color: colors.ink),
                    const SizedBox(width: 5),
                    Text(
                      'GROUP INFO',
                      style: TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.w700,
                        color: colors.ink,
                        letterSpacing: 0.5,
                        fontFamily: 'SpaceMono',
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Feed List
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _filteredItems.length,
            separatorBuilder: (_, _) =>
                Divider(height: 24, color: colors.line.withValues(alpha: 0.5)),
            itemBuilder: (context, index) {
              final item = _filteredItems[index];
              return _buildFeedItem(context, colors, item);
            },
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildFeedItem(
    BuildContext context,
    BitoColorScheme colors,
    GroupFeedItem item,
  ) {
    final showPicker = _activePickerItemId == item.id;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (showPicker)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Align(
              alignment: Alignment.centerRight,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: colors.surface2,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: colors.line2),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.25),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildReactionOption(item, '👍', colors),
                    _buildReactionOption(item, '🔥', colors),
                    _buildReactionOption(item, '⚡', colors),
                    _buildReactionOption(item, '👏', colors),
                    _buildReactionOption(item, '❤️', colors),
                    _buildReactionOption(item, '🎯', colors),
                  ],
                ),
              ),
            ),
          ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // User Avatar
            CircleAvatar(
              radius: 16,
              backgroundColor: colors.surface2,
              child: Text(
                item.userAvatar,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: colors.ink,
                ),
              ),
            ),
            const SizedBox(width: 12),

            // Activity Text & Time
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: TextSpan(
                      style: TextStyle(fontSize: 13, color: colors.ink),
                      children: [
                        TextSpan(
                          text: item.userName,
                          style: const TextStyle(fontWeight: FontWeight.w700),
                        ),
                        TextSpan(
                          text: ' completed ${item.habitName}',
                          style: TextStyle(color: colors.ink2),
                        ),
                        if (item.streakInfo != null) ...[
                          TextSpan(
                            text: ' · ${item.streakInfo}',
                            style: TextStyle(
                              color: colors.signal2,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    item.timeAgo,
                    style: TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.w700,
                      color: colors.ink3,
                      fontFamily: 'SpaceMono',
                    ),
                  ),
                  if (item.reactions.isNotEmpty) ...[
                    const SizedBox(height: 6),
                    Wrap(
                      spacing: 4,
                      runSpacing: 4,
                      children: item.reactions.map((emoji) {
                        return GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () => _addReaction(item, emoji),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: colors.surface2,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: colors.line2),
                            ),
                            child: Text(
                              emoji,
                              style: const TextStyle(fontSize: 12),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ],
              ),
            ),

            // Actions (Heart button & Plus button)
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Heart button (Liked or Unliked)
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => _toggleLike(item),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: item.likesCount > 0 ? 8 : 7,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: item.isLiked
                          ? const Color(0xFFE5576C).withValues(alpha: 0.15)
                          : colors.surface,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                        color: item.isLiked
                            ? const Color(0xFFE5576C).withValues(alpha: 0.4)
                            : colors.line,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          item.isLiked
                              ? PhosphorIcons.heart(PhosphorIconsStyle.fill)
                              : PhosphorIcons.heart(),
                          size: 13,
                          color: item.isLiked
                              ? const Color(0xFFE5576C)
                              : colors.ink3,
                        ),
                        if (item.likesCount > 0) ...[
                          const SizedBox(width: 4),
                          Text(
                            item.likesCount.toString(),
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFFE5576C),
                              fontFamily: 'SpaceMono',
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 6),

                // Plus Reaction button
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    setState(() {
                      _activePickerItemId = showPicker ? null : item.id;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: showPicker
                          ? colors.signal.withValues(alpha: 0.2)
                          : colors.surface,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                        color: showPicker ? colors.signal : colors.line,
                      ),
                    ),
                    child: Icon(
                      showPicker ? PhosphorIcons.x() : PhosphorIcons.plus(),
                      size: 13,
                      color: showPicker ? colors.signal : colors.ink3,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildReactionOption(
    GroupFeedItem item,
    String emoji,
    BitoColorScheme colors,
  ) {
    final isSelected = item.reactions.contains(emoji);
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => _addReaction(item, emoji),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 2),
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
        decoration: BoxDecoration(
          color: isSelected
              ? colors.signal.withValues(alpha: 0.2)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(emoji, style: const TextStyle(fontSize: 16)),
      ),
    );
  }
}
