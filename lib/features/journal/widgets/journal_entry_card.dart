// lib/features/journal/widgets/journal_entry_card.dart
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:bito/theme/theme_extensions.dart';
import 'package:bito/data/journal/journal_entry.dart';

class JournalEntryCard extends StatelessWidget {
  final JournalEntry entry;
  final VoidCallback? onTap;

  const JournalEntryCard({
    super.key,
    required this.entry,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<BitoColorScheme>()!;
    final month = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'][entry.date.month - 1];
    final day = '${month} ${entry.date.day}';

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: colors.surface2,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            // Mood icon
            if (entry.mood != null)
              Container(
                margin: const EdgeInsets.only(right: 8),
                child: Icon(
                  entry.mood!.icon,
                  size: 16,
                  color: entry.mood!.color,
                ),
              ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    day,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: colors.ink3,
                      letterSpacing: 0.3,
                      fontFamily: 'SpaceMono',
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    entry.longFormContent.isNotEmpty
                        ? entry.longFormContent.split('\n').first
                        : (entry.quickLogs.isNotEmpty ? entry.quickLogs.first.content : 'Untitled'),
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: colors.ink,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            // Word count badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: colors.line2,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                '${entry.wordCount} w',
                style: TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.w600,
                  color: colors.ink3,
                  fontFamily: 'SpaceMono',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

