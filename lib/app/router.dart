// lib/app/router.dart
import 'package:go_router/go_router.dart';

// Navigation Shell
import '../shared/components/shell/shell_screen.dart';

// Primary Screens
import '../features/dashboard/dashboard_screen.dart';
import '../features/analytics/analytics_screen.dart';
import '../features/groups/groups_screen.dart';
import '../features/more/more_screen.dart';

// Secondary Screens
import '../features/habits/habits_screen.dart';
// Remove: import '../features/create_habit_screen.dart'; // ← NOT USED
import '../features/journal/journal_screen.dart';
import '../features/journal/create_journal_screen.dart';
import '../features/journal/journal_intelligence_screen.dart';
import '../features/profile/profile_screen.dart';
import '../features/settings/settings_screen.dart';
import '../features/notifications/notifications_screen.dart';
import '../features/compass/compass_screen.dart';
import '../features/groups/challenges_screen.dart';

// Habit Creation Steps
import '../features/habits/create_habit_step1.dart';
import '../features/habits/create_habit_step2.dart';
import '../features/habits/create_habit_step3.dart';
import '../features/habits/create_habit_step4.dart';
import '../features/habits/edit_habit_screen.dart';

// Groups Creation
import '../features/groups/create_group_step1.dart';
import '../features/groups/create_group_step2.dart';
import '../features/groups/create_group_step3.dart';
import '../features/groups/group_detail_screen.dart';

// Auth Screens
import '../features/auth/sign_in_screen.dart';
import '../features/auth/daily_wisdom_screen.dart';
import '../features/auth/verify_magic_link_screen.dart';

final GoRouter router = GoRouter(
  initialLocation: '/sign-in',
  routes: [
    // ============================================================
    // Auth routes (no shell - full screen)
    // ============================================================
    GoRoute(
      path: '/sign-in',
      name: 'signIn',
      builder: (context, state) => const SignInScreen(),
    ),
    GoRoute(
      path: '/daily-wisdom',
      name: 'dailyWisdom',
      builder: (context, state) => const DailyWisdomScreen(),
    ),
    GoRoute(
      path: '/verify-magic-link',
      name: 'verifyMagicLink',
      builder: (context, state) {
        final token = state.uri.queryParameters['token'] ?? '';
        return VerifyMagicLinkScreen(token: token);
      },
    ),

    // ============================================================
    // Main app with shell (bottom navigation) - Requires Auth
    // ============================================================
    ShellRoute(
      builder: (context, state, child) {
        return ShellScreen(child: child);
      },
      routes: [
        // HOME
        GoRoute(
          path: '/',
          name: 'home',
          builder: (context, state) => const DashboardScreen(),
        ),

        // ANALYTICS
        GoRoute(
          path: '/analytics',
          name: 'analytics',
          builder: (context, state) => const AnalyticsScreen(),
        ),

        // GROUPS
        GoRoute(
          path: '/groups',
          name: 'groups',
          builder: (context, state) => const GroupsScreen(),
        ),

        // MORE
        GoRoute(
          path: '/more',
          name: 'more',
          builder: (context, state) => const MoreScreen(),
        ),

        // HABITS
        GoRoute(
          path: '/habits',
          name: 'habits',
          builder: (context, state) => const HabitsScreen(),
        ),
        GoRoute(
          path: '/habits/create/step1',
          name: 'createHabitStep1',
          builder: (context, state) => const CreateHabitStep1(),
        ),
        GoRoute(
          path: '/habits/create/step2',
          name: 'createHabitStep2',
          builder: (context, state) => const CreateHabitStep2(),
        ),
        GoRoute(
          path: '/habits/create/step3',
          name: 'createHabitStep3',
          builder: (context, state) => const CreateHabitStep3(),
        ),
        GoRoute(
          path: '/habits/create/step4',
          name: 'createHabitStep4',
          builder: (context, state) => const CreateHabitStep4(),
        ),

        // lib/app/router.dart - Add these routes inside the ShellRoute

        // Add these after the create habit routes:
        // Edit Habit Routes (reuse step screens with isEditing=true)
        GoRoute(
          path: '/habits/edit/step1',
          name: 'editHabitStep1',
          builder: (context, state) => const CreateHabitStep1(isEditing: true),
        ),
        GoRoute(
          path: '/habits/edit/step2',
          name: 'editHabitStep2',
          builder: (context, state) => const CreateHabitStep2(isEditing: true),
        ),
        GoRoute(
          path: '/habits/edit/step3',
          name: 'editHabitStep3',
          builder: (context, state) => const CreateHabitStep3(isEditing: true),
        ),
        GoRoute(
          path: '/habits/edit/step4',
          name: 'editHabitStep4',
          builder: (context, state) => const CreateHabitStep4(isEditing: true),
        ),

        // Entry point for editing
        GoRoute(
          path: '/habits/:habitId/edit',
          name: 'editHabit',
          builder: (context, state) {
            final habitId = state.pathParameters['habitId']!;
            return EditHabitScreen(habitId: habitId);
          },
        ),

        // JOURNAL
        GoRoute(
          path: '/journal',
          name: 'journal',
          builder: (context, state) => const JournalScreen(),
        ),
        GoRoute(
          path: '/journal/new',
          name: 'createJournal',
          builder: (context, state) {
            final entryId = state.uri.queryParameters['id'];
            return CreateJournalScreen(entryId: entryId);
          },
        ),
        GoRoute(
          path: '/journal/:entryId/edit',
          name: 'editJournal',
          builder: (context, state) {
            final entryId = state.pathParameters['entryId'];
            return CreateJournalScreen(entryId: entryId);
          },
        ),
        GoRoute(
          path: '/journal/intelligence',
          name: 'journalIntelligence',
          builder: (context, state) => const JournalIntelligenceScreen(),
        ),

        // PROFILE
        GoRoute(
          path: '/profile',
          name: 'profile',
          builder: (context, state) => const ProfileScreen(),
        ),

        // SETTINGS
        GoRoute(
          path: '/settings',
          name: 'settings',
          builder: (context, state) => const SettingsScreen(),
        ),

        // NOTIFICATIONS
        GoRoute(
          path: '/notifications',
          name: 'notifications',
          builder: (context, state) => const NotificationsScreen(),
        ),

        // COMPASS
        GoRoute(
          path: '/compass',
          name: 'compass',
          builder: (context, state) => const CompassScreen(),
        ),

        // CHALLENGES
        GoRoute(
          path: '/challenges',
          name: 'challenges',
          builder: (context, state) => const ChallengesScreen(),
        ),

        // GROUPS
        GoRoute(
          path: '/groups/create',
          name: 'createGroup',
          builder: (context, state) => const CreateGroupStep1(),
        ),
        GoRoute(
          path: '/groups/create/step1',
          name: 'createGroupStep1',
          builder: (context, state) => const CreateGroupStep1(),
        ),
        GoRoute(
          path: '/groups/create/step2',
          name: 'createGroupStep2',
          builder: (context, state) => const CreateGroupStep2(),
        ),
        GoRoute(
          path: '/groups/create/step3',
          name: 'createGroupStep3',
          builder: (context, state) => const CreateGroupStep3(),
        ),
        GoRoute(
          path: '/groups/:groupId',
          name: 'groupDetail',
          builder: (context, state) {
            final groupId = state.pathParameters['groupId']!;
            return GroupDetailScreen(groupId: groupId);
          },
        ),
      ],
    ),
  ],
);
