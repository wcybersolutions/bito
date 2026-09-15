// lib/features/dashboard/dashboard_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:bito/features/dashboard/widgets/stats_row.dart';
import 'package:bito/features/dashboard/widgets/week_card.dart';
import 'package:bito/features/dashboard/widgets/quick_actions.dart';
import 'package:bito/features/dashboard/widgets/ai_insight_card.dart';
import 'package:bito/features/dashboard/widgets/weekly_habits_card.dart';
import 'package:bito/theme/theme_extensions.dart';
import 'package:bito/shared/shared.dart';
import 'package:bito/data/providers/auth_provider.dart';
import 'package:bito/data/providers/dashboard_provider.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).extension<BitoColorScheme>()!;
    final authState = ref.watch(authNotifierProvider);
    final user = authState.valueOrNull;
    final dashboardAsync = ref.watch(dashboardProvider);

    return Scaffold(
      backgroundColor: colors.bg,
      body: SafeArea(
        child: dashboardAsync.when(
          data: (dashboard) {
            final userName = user?.name ?? dashboard.userName;
            final userAvatar = user?.avatar;
            final userInitials = _getInitials(userName);

            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppHeader(
                    eyebrow: '${dashboard.dayOfWeek}, THE DAY BOOK',
                    title: '${dashboard.greeting}, $userName.',
                    date: dashboard.date,
                    onNotificationTap: () => context.push('/notifications'),
                    onThemeTap: () => _showThemeSheet(context, ref),
                    onProfileTap: () => context.push('/settings'),
                    profileImageUrl: userAvatar,
                    profileName: userName,
                    profileInitials: userInitials,
                  ),
                  const SizedBox(height: 16),
                  StatsRow(
                    stats: {
                      'TODAY':
                          '${dashboard.completedToday}/${dashboard.totalToday}',
                      'WEEKLY':
                          '${dashboard.weeklyCompleted}/${dashboard.totalWeekly}',
                      'DAY STREAK': dashboard.streak.toString(),
                    },
                  ),
                  const SizedBox(height: 16),
                  AIInsightCard(insight: dashboard.insight),
                  const SizedBox(height: 16),
                  QuickActions(habits: dashboard.todayHabits),
                  const SizedBox(height: 16),
                  WeeklyHabitsCard(
                    habits: dashboard.todayHabits
                        .map(
                          (h) => WeeklyHabit(
                            id: h.id,
                            name: h.name,
                            icon: _getIconData(h.iconName),
                            target: 1,
                            progress: h.isCompleted ? 1 : 0,
                          ),
                        )
                        .toList(),
                  ),
                  const SizedBox(height: 16),
                  WeekCard(
                    weekData: dashboard.weekData
                        .map(
                          (w) => WeekDay(
                            label: w.label,
                            state: w.state,
                            done: w.done,
                            total: w.total,
                          ),
                        )
                        .toList(),
                    dateRange: dashboard.weekRange,
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) => Center(
            child: Text(
              'Error loading dashboard: $error',
              style: TextStyle(color: colors.error),
            ),
          ),
        ),
      ),
    );
  }

  IconData _getIconData(String iconName) {
    switch (iconName) {
      case 'directions_run':
        return PhosphorIcons.personSimpleRun();
      case 'self_improvement':
        return PhosphorIcons.heart();
      case 'work':
        return PhosphorIcons.target();
      case 'bookOpen':
        return PhosphorIcons.bookOpen();
      case 'forkKnife':
        return PhosphorIcons.forkKnife();
      default:
        return PhosphorIcons.checkCircle();
    }
  }

  void _showThemeSheet(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).extension<BitoColorScheme>()!;
    final currentTheme = ref.read(themeProvider);

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: colors.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: colors.line2,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Text(
                'Choose Theme',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: colors.ink,
                ),
              ),
              const SizedBox(height: 16),
              ...AppThemeMode.values.map((mode) {
                final isSelected = currentTheme == mode;
                return GestureDetector(
                  onTap: () {
                    ref.read(themeProvider.notifier).setTheme(mode);
                    Navigator.pop(context);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    margin: const EdgeInsets.only(bottom: 8),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? colors.signal.withValues(alpha: 0.08)
                          : colors.surface2,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected ? colors.signal : colors.line,
                        width: isSelected ? 2 : 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          mode.icon,
                          size: 24,
                          color: isSelected ? colors.signal : colors.ink2,
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Text(
                            mode.label,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: isSelected ? colors.signal : colors.ink,
                            ),
                          ),
                        ),
                        if (isSelected)
                          Icon(
                            PhosphorIcons.check(),
                            size: 20,
                            color: colors.signal,
                          ),
                      ],
                    ),
                  ),
                );
              }),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }

  String _getInitials(String name) {
    if (name.isEmpty) return 'MP';
    final parts = name.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return parts[0][0].toUpperCase();
  }
}
