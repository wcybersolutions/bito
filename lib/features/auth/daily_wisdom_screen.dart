// lib/features/auth/daily_wisdom_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:bito/theme/theme_extensions.dart';
import 'package:bito/theme/colors.dart';
import 'package:bito/shared/components/app_bar/bito_logo.dart';
import 'package:bito/data/providers/verse_provider.dart';

class DailyWisdomScreen extends ConsumerStatefulWidget {
  const DailyWisdomScreen({super.key});

  @override
  ConsumerState<DailyWisdomScreen> createState() => _DailyWisdomScreenState();
}

class _DailyWisdomScreenState extends ConsumerState<DailyWisdomScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

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
    final verseAsync = ref.watch(dailyVerseProvider);

    return Scaffold(
      backgroundColor: colors.bg,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            children: [
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

              Expanded(
                child: verseAsync.when(
                  data: (verse) => AnimatedBuilder(
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
                              Icon(
                                PhosphorIcons.bookOpen(),
                                size: 28,
                                color: colors.signal2,
                              ),
                              const SizedBox(height: 12),
                              Expanded(
                                child: Center(
                                  child: SingleChildScrollView(
                                    physics: const BouncingScrollPhysics(),
                                    child: Text(
                                      verse.text,
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
                              Text(
                                verse.reference,
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: colors.ink2,
                                  letterSpacing: 0.5,
                                  fontFamily: 'SpaceMono',
                                ),
                              ),
                              const SizedBox(height: 8),
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
                  loading: () => Container(
                    decoration: BoxDecoration(
                      color: colors.surface,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: colors.line),
                    ),
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
                  error: (error, stack) => Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: colors.surface,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: colors.line),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          PhosphorIcons.warning(),
                          size: 48,
                          color: colors.warning,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Unable to load verse',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: colors.ink,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Please check your connection',
                          style: TextStyle(
                            fontSize: 14,
                            color: colors.ink2,
                          ),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {
                            ref.invalidate(dailyVerseProvider);
                          },
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

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
