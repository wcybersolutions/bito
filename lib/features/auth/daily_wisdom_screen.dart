// lib/features/auth/daily_wisdom_screen.dart
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:bito/theme/theme_extensions.dart';
import 'package:bito/theme/colors.dart';
import 'package:bito/shared/components/app_bar/bito_logo.dart';

class DailyWisdomScreen extends StatefulWidget {
  const DailyWisdomScreen({super.key});

  @override
  State<DailyWisdomScreen> createState() => _DailyWisdomScreenState();
}

class _DailyWisdomScreenState extends State<DailyWisdomScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  // Collection of inspiring verses
  static const List<Map<String, String>> _verses = [
    {
      'verse': '"Though the fig tree should not blossom, nor fruit be on the vines, the produce of the olive fail and the fields yield no food, the flock be cut off from the fold and there be no herd in the stalls, yet I will rejoice in the Lord; I will joy in the God of my Salvation."',
      'reference': 'Habakkuk 3:17-18',
    },
    {
      'verse': '"For I know the plans I have for you, declares the Lord, plans for welfare and not for evil, to give you a future and a hope."',
      'reference': 'Jeremiah 29:11',
    },
    {
      'verse': '"Be strong and courageous. Do not fear or be in dread of them, for it is the Lord your God who goes with you. He will not leave you or forsake you."',
      'reference': 'Deuteronomy 31:6',
    },
    {
      'verse': '"Trust in the Lord with all your heart, and do not lean on your own understanding. In all your ways acknowledge him, and he will make straight your paths."',
      'reference': 'Proverbs 3:5-6',
    },
    {
      'verse': '"I can do all things through him who strengthens me."',
      'reference': 'Philippians 4:13',
    },
    {
      'verse': '"The Lord is my shepherd; I shall not want. He makes me lie down in green pastures. He leads me beside still waters. He restores my soul."',
      'reference': 'Psalm 23:1-3',
    },
    {
      'verse': '"And we know that for those who love God all things work together for good, for those who are called according to his purpose."',
      'reference': 'Romans 8:28',
    },
    {
      'verse': '"Do not be anxious about anything, but in everything by prayer and supplication with thanksgiving let your requests be made known to God."',
      'reference': 'Philippians 4:6',
    },
    {
      'verse': '"The steadfast love of the Lord never ceases; his mercies never come to an end; they are new every morning; great is your faithfulness."',
      'reference': 'Lamentations 3:22-23',
    },
    {
      'verse': '"But they who wait for the Lord shall renew their strength; they shall mount up with wings like eagles; they shall run and not be weary; they shall walk and not faint."',
      'reference': 'Isaiah 40:31',
    },
  ];

  late Map<String, String> _currentVerse;
  int _currentIndex = 0;

  /// Get the verse index for today's date.
  /// This ensures the same verse is shown all day, regardless of sign-in count.
  int _getTodaysVerseIndex() {
    final now = DateTime.now();
    // Use the day of year (1-366) to deterministically pick a verse
    // This ensures the same verse for the entire day
    final dayOfYear = now.difference(DateTime(now.year, 1, 1)).inDays;
    return dayOfYear % _verses.length;
  }

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    );

    // Get today's verse deterministically
    _currentIndex = _getTodaysVerseIndex();
    _currentVerse = _verses[_currentIndex];
    _fadeController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  void _skipToDashboard() {
    context.go('/');
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<BitoColorScheme>()!;
    final today = DateTime.now();
    final formattedDate = '${_getMonthName(today.month)} ${today.day}, ${today.year}';

    return Scaffold(
      backgroundColor: colors.bg,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            children: [
              // Top logo
              const BitoLogo(size: 32),
              const SizedBox(height: 12),
              Text(
                'Daily Dose of Wisdom',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: colors.signal,
                  letterSpacing: 1.2,
                  fontFamily: 'SpaceMono',
                ),
              ),
              const SizedBox(height: 4),
              // Show today's date to reinforce "daily" concept
              Text(
                formattedDate,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: colors.ink3,
                  letterSpacing: 0.5,
                  fontFamily: 'SpaceMono',
                ),
              ),
              const SizedBox(height: 20),

              // Verse container with fade animation
              Expanded(
                child: AnimatedBuilder(
                  animation: _fadeAnimation,
                  builder: (context, child) {
                    return Opacity(
                      opacity: _fadeAnimation.value,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 20,
                        ),
                        decoration: BoxDecoration(
                          color: colors.surface,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: colors.line),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.04),
                              offset: const Offset(0, 4),
                              blurRadius: 20,
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            // Book icon
                            Icon(
                              PhosphorIcons.bookOpen(),
                              size: 28,
                              color: colors.signal2,
                            ),
                            const SizedBox(height: 12),

                            // Scrollable verse text area
                            Expanded(
                              child: Center(
                                child: SingleChildScrollView(
                                  physics: const BouncingScrollPhysics(),
                                  child: Text(
                                    _currentVerse['verse'] ?? '',
                                    style: TextStyle(
                                      fontSize: 16,
                                      height: 1.6,
                                      color: colors.ink,
                                      fontStyle: FontStyle.italic,
                                      letterSpacing: 0.3,
                                      fontWeight: FontWeight.w400,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(height: 12),
                            // Pinned verse reference
                            Text(
                              _currentVerse['reference'] ?? '',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: colors.ink2,
                                letterSpacing: 0.5,
                                fontFamily: 'SpaceMono',
                              ),
                            ),

                            const SizedBox(height: 8),
                            // Daily verse indicator
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: colors.signal.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                '✨ Today\'s Verse',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                  color: colors.signal,
                                  letterSpacing: 0.5,
                                  fontFamily: 'SpaceMono',
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 20),

              // Bottom actions - Show dots but no navigation arrows (daily verse is fixed)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ...List.generate(_verses.length, (index) {
                    final isActive = index == _currentIndex;
                    return Container(
                      width: 8,
                      height: 8,
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isActive ? colors.signal : colors.line2,
                      ),
                    );
                  }),
                ],
              ),

              const SizedBox(height: 20),

              // Continue button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _skipToDashboard,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: BitoColors.cobalt,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(11),
                    ),
                    elevation: 0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'CONTINUE',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          letterSpacing: 0.8,
                          fontFamily: 'SpaceMono',
                        ),
                      ),
                      const SizedBox(width: 8),
                      Icon(
                        PhosphorIcons.arrowRight(),
                        size: 18,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getMonthName(int month) {
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return months[month - 1];
  }
}

