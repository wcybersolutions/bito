// lib/features/groups/members/members_tab.dart
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:bito/theme/theme_extensions.dart';
import 'package:bito/data/groups/group.dart';

class GroupMember {
  final String id;
  final String name;
  final String avatarUrl;
  final String role; // 'OWNER', 'ADMIN', 'MEMBER'
  final bool isCurrentUser;
  final String joinedDate;

  const GroupMember({
    required this.id,
    required this.name,
    required this.avatarUrl,
    required this.role,
    this.isCurrentUser = false,
    required this.joinedDate,
  });
}

class MembersTab extends StatefulWidget {
  final Group group;
  final VoidCallback onInvite;

  const MembersTab({super.key, required this.group, required this.onInvite});

  @override
  State<MembersTab> createState() => _MembersTabState();
}

class _MembersTabState extends State<MembersTab> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  late List<GroupMember> _members;

  @override
  void initState() {
    super.initState();
    _members = [
      const GroupMember(
        id: '1',
        name: 'Joseph Katsande',
        avatarUrl: '',
        role: 'OWNER',
        isCurrentUser: true,
        joinedDate: 'JOINED 03/08/2026',
      ),
    ];
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<GroupMember> get _filteredMembers {
    if (_searchQuery.trim().isEmpty) return _members;
    final q = _searchQuery.toLowerCase();
    return _members.where((m) => m.name.toLowerCase().contains(q)).toList();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<BitoColorScheme>()!;
    final countStr = _filteredMembers.length.toString().padLeft(2, '0');

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Search Bar
          Container(
            decoration: BoxDecoration(
              color: colors.bg,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: colors.line),
            ),
            child: TextField(
              controller: _searchController,
              onChanged: (val) => setState(() => _searchQuery = val),
              style: TextStyle(color: colors.ink, fontSize: 13),
              decoration: InputDecoration(
                hintText: 'Search members',
                hintStyle: TextStyle(color: colors.ink3, fontSize: 13),
                prefixIcon: Icon(
                  PhosphorIcons.magnifyingGlass(),
                  size: 16,
                  color: colors.ink3,
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 12,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // ROSTER — 01 and INVITES & SHARING button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'ROSTER — $countStr',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: colors.ink3,
                  letterSpacing: 0.8,
                  fontFamily: 'SpaceMono',
                ),
              ),
              GestureDetector(
                onTap: widget.onInvite,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 7,
                  ),
                  decoration: BoxDecoration(
                    color: colors.surface,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: colors.line),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        PhosphorIcons.userPlus(),
                        size: 13,
                        color: colors.ink,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'INVITES & SHARING',
                        style: TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.w800,
                          color: colors.ink,
                          letterSpacing: 0.6,
                          fontFamily: 'SpaceMono',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Member Cards List
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _filteredMembers.length,
            separatorBuilder: (_, _) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              final member = _filteredMembers[index];
              return _buildMemberCard(context, colors, member);
            },
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildMemberCard(
    BuildContext context,
    BitoColorScheme colors,
    GroupMember member,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colors.line),
      ),
      child: Row(
        children: [
          // Member Profile Avatar
          CircleAvatar(
            radius: 18,
            backgroundColor: colors.surface2,
            child: Icon(PhosphorIcons.user(), size: 18, color: colors.ink),
          ),
          const SizedBox(width: 12),

          // Name + (YOU) and Joined Date
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      member.name,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: colors.ink,
                      ),
                    ),
                    if (member.isCurrentUser) ...[
                      const SizedBox(width: 5),
                      Text(
                        '(YOU)',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                          color: colors.signal2,
                          fontFamily: 'SpaceMono',
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  member.joinedDate,
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

          // Role Badge (e.g. OWNER)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: colors.surface2,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: colors.line),
            ),
            child: Text(
              member.role,
              style: TextStyle(
                fontSize: 9,
                fontWeight: FontWeight.w800,
                color: colors.signal2,
                letterSpacing: 0.5,
                fontFamily: 'SpaceMono',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
