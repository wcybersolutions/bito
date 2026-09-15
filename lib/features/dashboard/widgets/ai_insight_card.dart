// lib/features/widgets/ai_insight_card.dart
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:bito/theme/theme_extensions.dart';
import 'package:go_router/go_router.dart';

class AIInsightCard extends StatefulWidget {
  final String insight;

  const AIInsightCard({
    super.key,
    required this.insight,
  });

  @override
  State<AIInsightCard> createState() => _AIInsightCardState();
}

class _AIInsightCardState extends State<AIInsightCard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<BitoColorScheme>()!;

    const String fullText = 'You have nine daily habits with an average completion rate of 33%. "Easy Morning Run" leads with a 78% completion rate, while "Evening run" is at the lowest with just 3%. Over the last three tracked days, you achieved 100% completion each day, including a full set of eight or more habits completed daily. Sundays stand out as your most productive day, with all habits completed, and mornings.';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: colors.line),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with "THE RHYTHM" and chevron
            InkWell(
              onTap: () {
                setState(() {
                  _isExpanded = !_isExpanded;
                });
              },
              borderRadius: BorderRadius.circular(12),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
                child: Row(
                  children: [
                    Text(
                      'THE RHYTHM',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: colors.ink3,
                        letterSpacing: 1.5,
                        fontFamily: 'SpaceMono',
                      ),
                    ),
                    const Spacer(),
                    Icon(
                      _isExpanded
                          ? PhosphorIcons.caretUp()
                          : PhosphorIcons.caretDown(),
                      size: 16,
                      color: colors.ink3,
                    ),
                  ],
                ),
              ),
            ),

            // Content
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Show preview text (3 lines) when collapsed, full text when expanded
                  Text(
                    fullText,
                    style: TextStyle(
                      fontSize: 15,
                      height: 1.6,
                      color: colors.ink,
                      letterSpacing: 0.4,
                    ),
                    maxLines: _isExpanded ? null : 3,
                    overflow: _isExpanded ? null : TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),

            // Actions row with REFRESH and FULL ANALYSIS (only when expanded)
            if (_isExpanded) ...[
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // REFRESH button
                    TextButton(
                      onPressed: () {
                        // Refresh logic
                      },
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: Text(
                        'REFRESH',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: colors.ink3,
                          letterSpacing: 0.5,
                          fontFamily: 'SpaceMono',
                        ),
                      ),
                    ),

                    // FULL ANALYSIS button
                    TextButton(
                      onPressed: () {
                        context.go('/analytics');
                      },
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: Row(
                        children: [
                          Text(
                            'FULL ANALYSIS',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: colors.signal2,
                              letterSpacing: 0.5,
                              fontFamily: 'SpaceMono',
                            ),
                          ),
                          const SizedBox(width: 4),
                          Icon(
                            PhosphorIcons.arrowRight(),
                            size: 14,
                            color: colors.signal2,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
