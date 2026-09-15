// lib/features/groups/challenges/challenges_tab.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:bito/theme/theme_extensions.dart';
import 'package:bito/data/groups/group.dart';
import 'package:bito/data/groups/group_challenge.dart';
import 'package:bito/data/groups/group_challenges_provider.dart';
import 'package:bito/features/groups/challenges/create_challenge_sheet.dart';

class ChallengesTab extends ConsumerWidget {
  final Group group;

  const ChallengesTab({super.key, required this.group});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).extension<BitoColorScheme>()!;
    final textTheme = Theme.of(context).textTheme;
    final challenges = ref.watch(groupChallengesListProvider(group.id));

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // STANDINGS Button at top
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              color: colors.surface,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: colors.line),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(PhosphorIcons.trophy(), size: 15, color: colors.ink),
                const SizedBox(width: 8),
                Text(
                  'STANDINGS',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    color: colors.ink,
                    letterSpacing: 0.8,
                    fontFamily: 'SpaceMono',
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Content: Empty State vs Challenges List
          if (challenges.isEmpty)
            _buildEmptyState(context, colors, textTheme)
          else
            _buildChallengesList(context, ref, colors, textTheme, challenges),

          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildEmptyState(
    BuildContext context,
    BitoColorScheme colors,
    TextTheme textTheme,
  ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 24),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colors.line),
      ),
      child: Column(
        children: [
          // Orange Trophy Icon
          Icon(
            PhosphorIcons.trophy(),
            size: 48,
            color: const Color(0xFFFF6D4A),
          ),
          const SizedBox(height: 18),

          // Title
          Text(
            'No challenges yet',
            style: textTheme.headlineSmall?.copyWith(
              color: colors.ink,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),

          // Subtitle with highlighted text
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: TextStyle(fontSize: 13, color: colors.ink2, height: 1.5),
              children: [
                const TextSpan(text: 'Create a streak, '),
                TextSpan(
                  text: 'team goal',
                  style: TextStyle(
                    color: colors.signal2,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const TextSpan(
                  text: ', or consistency challenge to motivate your group.',
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // CREATE CHALLENGE Button (Orange/Coral)
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => CreateChallengeSheet.show(context, group.id),
              icon: Icon(PhosphorIcons.trophy(), size: 16, color: Colors.black),
              label: const Text(
                'CREATE CHALLENGE',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  color: Colors.black,
                  letterSpacing: 0.6,
                  fontFamily: 'SpaceMono',
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF6D4A),
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 0,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChallengesList(
    BuildContext context,
    WidgetRef ref,
    BitoColorScheme colors,
    TextTheme textTheme,
    List<GroupChallenge> challenges,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'ACTIVE CHALLENGES · ${challenges.length}',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: colors.ink3,
                letterSpacing: 0.6,
                fontFamily: 'SpaceMono',
              ),
            ),
            OutlinedButton.icon(
              onPressed: () => CreateChallengeSheet.show(context, group.id),
              icon: Icon(PhosphorIcons.plus(), size: 13, color: colors.ink),
              label: Text(
                'NEW CHALLENGE',
                style: TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.w700,
                  color: colors.ink,
                  letterSpacing: 0.5,
                  fontFamily: 'SpaceMono',
                ),
              ),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                side: BorderSide(color: colors.line),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: challenges.length,
          separatorBuilder: (_, _) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final c = challenges[index];
            return _buildChallengeCard(context, ref, colors, c);
          },
        ),
      ],
    );
  }

  Widget _buildChallengeCard(
    BuildContext context,
    WidgetRef ref,
    BitoColorScheme colors,
    GroupChallenge challenge,
  ) {
    final progressRatio = challenge.targetValue > 0
        ? (challenge.currentProgress / challenge.targetValue).clamp(0.0, 1.0)
        : 0.0;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: colors.line),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFF6D4A).withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      PhosphorIcons.trophy(),
                      size: 18,
                      color: const Color(0xFFFF6D4A),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        challenge.title,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: colors.ink,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${challenge.type.label.toUpperCase()} · ${challenge.targetValue} ${challenge.unit.toUpperCase()}',
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
              GestureDetector(
                onTap: () {
                  ref
                      .read(groupChallengesProvider.notifier)
                      .toggleJoin(group.id, challenge.id);
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: challenge.isJoined
                        ? colors.surface2
                        : colors.signal2,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                      color: challenge.isJoined ? colors.line : colors.signal2,
                    ),
                  ),
                  child: Text(
                    challenge.isJoined ? 'JOINED' : 'JOIN',
                    style: TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.w800,
                      color: challenge.isJoined ? colors.ink : Colors.black,
                      fontFamily: 'SpaceMono',
                    ),
                  ),
                ),
              ),
            ],
          ),
          if (challenge.description.isNotEmpty) ...[
            const SizedBox(height: 10),
            Text(
              challenge.description,
              style: TextStyle(fontSize: 12, color: colors.ink2),
            ),
          ],
          const SizedBox(height: 14),

          // Progress Bar
          ClipRRect(
            borderRadius: BorderRadius.circular(3),
            child: LinearProgressIndicator(
              value: progressRatio,
              backgroundColor: colors.line,
              valueColor: const AlwaysStoppedAnimation<Color>(
                Color(0xFFFF6D4A),
              ),
              minHeight: 5,
            ),
          ),
          const SizedBox(height: 8),

          // Progress & Participant Stats
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${challenge.currentProgress}/${challenge.targetValue} ${challenge.unit}',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: colors.ink3,
                  fontFamily: 'SpaceMono',
                ),
              ),
              Text(
                '${challenge.totalParticipants} PARTICIPANTS',
                style: TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.w700,
                  color: colors.ink3,
                  fontFamily: 'SpaceMono',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
