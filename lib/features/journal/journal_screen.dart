// lib/features/journal/journal_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:bito/shared/shared.dart';
import 'package:bito/data/journal/journal_entry.dart';
import 'package:bito/data/journal/journal_provider.dart';
import 'package:bito/features/journal/widgets/journal_stats_bar.dart';
import 'package:bito/features/journal/widgets/journal_entry_card.dart';

class JournalScreen extends ConsumerStatefulWidget {
  const JournalScreen({super.key});

  @override
  ConsumerState<JournalScreen> createState() => _JournalScreenState();
}

class _JournalScreenState extends ConsumerState<JournalScreen> {
  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<BitoColorScheme>()!;
    final textTheme = Theme.of(context).textTheme;
    final now = DateTime.now();
    final dayName = ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'][now.weekday % 7];
    final month = ['JAN', 'FEB', 'MAR', 'APR', 'MAY', 'JUN', 'JUL', 'AUG', 'SEP', 'OCT', 'NOV', 'DEC'][now.month - 1];

    final entriesAsync = ref.watch(journalEntriesProvider);

    return Scaffold(
      backgroundColor: colors.bg,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'THE LEDGER',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: colors.ink3,
                  letterSpacing: 1.2,
                  fontFamily: 'SpaceMono',
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Journal',
                    style: textTheme.displayMedium?.copyWith(
                      color: colors.ink,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      context.go('/journal/intelligence');
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: colors.signal2,
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          PhosphorIcons.lock(),
                          size: 12,
                          color: Colors.black,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'INTELLIGENCE',
                          style: TextStyle(
                            fontSize: 8,
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
              const SizedBox(height: 4),
              const JournalStatsBar(),
              const SizedBox(height: 20),
              _buildTodayDesk(context, colors, textTheme, dayName, month, now),
              const SizedBox(height: 24),
              _buildReadingRoom(context, colors, textTheme, entriesAsync),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.go('/journal/new');
        },
        backgroundColor: colors.signal2,
        child: Icon(
          PhosphorIcons.plus(),
          color: Colors.black,
        ),
      ),
    );
  }

  Widget _buildTodayDesk(
      BuildContext context,
      BitoColorScheme colors,
      TextTheme textTheme,
      String dayName,
      String month,
      DateTime now,
      ) {
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
          Text(
            'TODAY\'S DESK',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: colors.ink3,
              letterSpacing: 1.2,
              fontFamily: 'SpaceMono',
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                dayName,
                style: textTheme.headlineSmall?.copyWith(
                  color: colors.ink,
                ),
              ),
              Text(
                month,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: colors.ink3,
                  letterSpacing: 0.5,
                  fontFamily: 'SpaceMono',
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            '${now.day}',
            style: textTheme.displayLarge?.copyWith(
              color: colors.ink,
              fontSize: 48,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: colors.bg,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: colors.line),
            ),
            child: Row(
              children: [
                Icon(
                  PhosphorIcons.pencil(),
                  size: 16,
                  color: colors.ink3,
                ),
                const SizedBox(width: 8),
                Text(
                  'No entry yet today',
                  style: TextStyle(
                    fontSize: 13,
                    color: colors.ink3,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () {
                    context.go('/journal/new');
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: colors.signal2,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      'START WRITING',
                      style: TextStyle(
                        fontSize: 8,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                        letterSpacing: 0.5,
                        fontFamily: 'SpaceMono',
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReadingRoom(
      BuildContext context,
      BitoColorScheme colors,
      TextTheme textTheme,
      AsyncValue<List<JournalEntry>> entriesAsync,
      ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'READING ROOM',
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
          'Browse past entries, search, or reflect',
          style: TextStyle(
            fontSize: 12,
            color: colors.ink2,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'RECENT',
          style: TextStyle(
            fontSize: 9,
            fontWeight: FontWeight.w700,
            color: colors.ink3,
            letterSpacing: 0.5,
            fontFamily: 'SpaceMono',
          ),
        ),
        const SizedBox(height: 8),

        entriesAsync.when(
          data: (entries) {
            if (entries.isEmpty) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: Text(
                    'No journal entries yet.\nStart writing today!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: colors.ink3,
                    ),
                  ),
                ),
              );
            }
            return Column(
              children: entries.take(3).map((entry) {
                return JournalEntryCard(entry: entry);
              }).toList(),
            );
          },
          loading: () => const Center(
            child: Padding(
              padding: EdgeInsets.all(32),
              child: SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
          ),
          error: (_, __) => Center(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Text(
                'Error loading entries',
                style: TextStyle(
                  color: colors.error,
                ),
              ),
            ),
          ),
        ),

        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton(
              onPressed: () {},
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Text(
                'ALL ENTRIES',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: colors.signal,
                  letterSpacing: 0.5,
                  fontFamily: 'SpaceMono',
                ),
              ),
            ),
            Row(
              children: [
                entriesAsync.when(
                  data: (entries) => Text(
                    '${entries.length}',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: colors.ink3,
                      fontFamily: 'SpaceMono',
                    ),
                  ),
                  loading: () => const SizedBox.shrink(),
                  error: (_, __) => const SizedBox.shrink(),
                ),
                const SizedBox(width: 8),
                TextButton(
                  onPressed: () {},
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: Text(
                    'TIMELINE',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: colors.ink3,
                      letterSpacing: 0.5,
                      fontFamily: 'SpaceMono',
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
}

