// lib/features/dashboard_screen.dart
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart'; // Add this import
import 'package:bito/shared/components/app_bar/app_header.dart';
import 'package:bito/features/dashboard/widgets/stats_row.dart';
import 'package:bito/features/dashboard/widgets/week_card.dart';
import 'package:bito/features/dashboard/widgets/quick_actions.dart';
import 'package:bito/features/dashboard/widgets/ai_insight_card.dart';
import 'package:bito/features/dashboard/widgets/weekly_habits_card.dart';
import 'package:bito/theme/theme_extensions.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<BitoColorScheme>()!;

    final weekData = [
      const WeekDay(label: 'MON', state: 'complete', done: 9, total: 9),
      const WeekDay(label: 'TUE', state: 'today', done: 0, total: 9),
      const WeekDay(label: 'WED', state: 'upcoming', done: 0, total: 9),
      const WeekDay(label: 'THU', state: 'upcoming', done: 0, total: 9),
      const WeekDay(label: 'FRI', state: 'upcoming', done: 0, total: 9),
      const WeekDay(label: 'SAT', state: 'upcoming', done: 0, total: 7),
      const WeekDay(label: 'SUN', state: 'upcoming', done: 0, total: 5),
    ];

    // Remove 'const' from WeeklyHabit instances since they use PhosphorIcons
    final weeklyHabits = [
      WeeklyHabit(
        id: 'w1',
        name: 'Weekly Review',
        icon: PhosphorIcons.bookOpen(),
        target: 1,
        progress: 0,
      ),
      WeeklyHabit(
        id: 'w2',
        name: 'Meal Prep',
        icon: PhosphorIcons.forkKnife(),
        target: 3,
        progress: 1,
      ),
    ];

    return Scaffold(
      backgroundColor: colors.bg,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const AppHeader(
                eyebrow: 'THURSDAY, THE DAY BOOK',
                title: 'Good morning, John.',
                date: 'JULY 30',
              ),
              const SizedBox(height: 16),
              StatsRow(
                stats: {
                  'TODAY': '0/7',
                  'WEEKLY': '0/2',
                  'DAY STREAK': '12',
                },
              ),
              const SizedBox(height: 16),
              const AIInsightCard(),
              const SizedBox(height: 16),
              const QuickActions(),
              const SizedBox(height: 16),
              WeeklyHabitsCard(habits: weeklyHabits),
              const SizedBox(height: 16),
              WeekCard(
                weekData: weekData,
                dateRange: 'Jul 27–Aug 2',
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

