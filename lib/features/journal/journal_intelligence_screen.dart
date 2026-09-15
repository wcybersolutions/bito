// lib/features/journal/journal_intelligence_screen.dart
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:bito/shared/shared.dart';

class JournalIntelligenceScreen extends StatefulWidget {
  const JournalIntelligenceScreen({super.key});

  @override
  State<JournalIntelligenceScreen> createState() =>
      _JournalIntelligenceScreenState();
}

class _JournalIntelligenceScreenState extends State<JournalIntelligenceScreen> {
  bool _patternNudgesEnabled = true;
  bool _contentInsightsEnabled = false;
  bool _weeklyNarrativesEnabled = false;
  bool _aiActive = true;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<BitoColorScheme>()!;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: colors.bg,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      IconButton(
                        onPressed: () => context.go('/journal'),
                        icon: Icon(
                          PhosphorIcons.arrowLeft(),
                          size: 20,
                          color: colors.ink,
                        ),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Journal',
                        style: textTheme.headlineSmall?.copyWith(
                          color: colors.ink,
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    onPressed: () => context.go('/journal'),
                    icon: Icon(PhosphorIcons.x(), size: 20, color: colors.ink2),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: colors.surface2,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: colors.line),
                ),
                child: Row(
                  children: [
                    Icon(PhosphorIcons.lock(), size: 16, color: colors.ink3),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'YOUR JOURNAL IS PRIVATE. DISABLE ANY TIER TO IMMEDIATELY DELETE ITS CACHED AI DATA.',
                        style: TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.w600,
                          color: colors.ink3,
                          letterSpacing: 0.3,
                          fontFamily: 'SpaceMono',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildIntelligenceCard(
                      context,
                      title: 'Pattern Nudges',
                      tier: 'T1',
                      description:
                          'Detect patterns from your mood scores and tags — no content reading. You\'ll see gentle nudges like "You\'ve been in a great mood this week!"',
                      tags: 'Mood, energy, tags, entry frequency',
                      isEnabled: _patternNudgesEnabled,
                      onToggle: (value) {
                        setState(() {
                          _patternNudgesEnabled = value;
                        });
                      },
                      isComingSoon: false,
                    ),
                    const SizedBox(height: 12),
                    _buildIntelligenceCard(
                      context,
                      title: 'Content Insights',
                      tier: 'T2',
                      description:
                          'AI reads your journal text to surface deeper themes, correlations, and habit connections. This feature is still in development — your choice here is saved as consent for when it ships; no journal text is read until then.',
                      tags: 'All journal text content + metadata',
                      isEnabled: _contentInsightsEnabled,
                      onToggle: (value) {
                        setState(() {
                          _contentInsightsEnabled = value;
                        });
                      },
                      isComingSoon: true,
                    ),
                    const SizedBox(height: 12),
                    _buildIntelligenceCard(
                      context,
                      title: 'Weekly Narratives',
                      tier: 'T3',
                      description:
                          'AI-generated weekly reflection summaries that weave together your habits, mood, and journal themes. This feature is still in development — your choice here is saved as consent for when it ships.',
                      tags: 'All journal text + habit data + mood trends',
                      isEnabled: _weeklyNarrativesEnabled,
                      onToggle: (value) {
                        setState(() {
                          _weeklyNarrativesEnabled = value;
                        });
                      },
                      isComingSoon: true,
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Switch(
                              value: _aiActive,
                              onChanged: (value) {
                                setState(() {
                                  _aiActive = value;
                                });
                              },
                              activeThumbColor: colors.signal,
                            ),
                            Text(
                              'AI Active',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: _aiActive ? colors.signal : colors.ink3,
                                letterSpacing: 0.5,
                                fontFamily: 'SpaceMono',
                              ),
                            ),
                          ],
                        ),
                        ElevatedButton(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Preferences saved!'),
                                backgroundColor: Colors.green,
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: colors.signal,
                            foregroundColor: Colors.black,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 10,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            elevation: 0,
                          ),
                          child: Text(
                            'SAVE PREFERENCES',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: Colors.black,
                              letterSpacing: 0.5,
                              fontFamily: 'SpaceMono',
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIntelligenceCard(
    BuildContext context, {
    required String title,
    required String tier,
    required String description,
    required String tags,
    required bool isEnabled,
    required ValueChanged<bool> onToggle,
    bool isComingSoon = false,
  }) {
    final colors = Theme.of(context).extension<BitoColorScheme>()!;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(12),
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
                  Text(
                    title,
                    style: textTheme.titleMedium?.copyWith(
                      color: colors.ink,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: isComingSoon ? colors.line2 : colors.signal,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      tier,
                      style: TextStyle(
                        fontSize: 8,
                        fontWeight: FontWeight.w700,
                        color: isComingSoon ? colors.ink3 : colors.signalInk,
                        letterSpacing: 0.5,
                        fontFamily: 'SpaceMono',
                      ),
                    ),
                  ),
                  if (isComingSoon)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: colors.line2,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        'Coming Soon',
                        style: TextStyle(
                          fontSize: 7,
                          fontWeight: FontWeight.w700,
                          color: colors.ink3,
                          letterSpacing: 0.3,
                          fontFamily: 'SpaceMono',
                        ),
                      ),
                    ),
                ],
              ),
              Switch(
                value: isEnabled,
                onChanged: onToggle,
                activeThumbColor: colors.signal,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: TextStyle(fontSize: 13, height: 1.5, color: colors.ink2),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: colors.bg,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              tags,
              style: TextStyle(
                fontSize: 9,
                fontWeight: FontWeight.w600,
                color: colors.ink3,
                letterSpacing: 0.3,
                fontFamily: 'SpaceMono',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
