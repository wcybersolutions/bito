// lib/features/journal/widgets/journal_stats_bar.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bito/theme/theme_extensions.dart';
import 'package:bito/data/journal/journal_provider.dart'; // This is now correct

class JournalStatsBar extends ConsumerWidget {
  const JournalStatsBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).extension<BitoColorScheme>()!;
    final statsAsync = ref.watch(journalStatsProvider);

    return statsAsync.when(
      data: (stats) => Text(
        '${stats.totalEntries} ENTRIES . ${stats.totalWords} WORDS . ${stats.journaledDays} DAYS JOURNALED',
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w500,
          color: colors.ink3,
          letterSpacing: 0.5,
          fontFamily: 'SpaceMono',
        ),
      ),
      loading: () => SizedBox(
        height: 16,
        child: Center(
          child: SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: colors.ink3,
            ),
          ),
        ),
      ),
      error: (error, stack) => Text(
        '0 ENTRIES . 0 WORDS . 0 DAYS JOURNALED',
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w500,
          color: colors.ink3,
          letterSpacing: 0.5,
          fontFamily: 'SpaceMono',
        ),
      ),
    );
  }
}

