class ApiConstants {
  // Base URL - will be replaced with env variables
  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://bitostaging-production.up.railway.app',
  );

  static const String apiVersion = '/api/v1';
  static const String baseApiUrl = '$baseUrl$apiVersion';

  // === AUTH ===
  static const String authMagicLink = '$baseApiUrl/auth/magic-link';
  static const String authVerify = '$baseApiUrl/auth/magic-link/verify';
  static const String authLogout = '$baseApiUrl/auth/logout';
  static const String authMe = '$baseApiUrl/auth/me';
  static const String authRefresh = '$baseApiUrl/auth/refresh';
  static const String authGoogle = '$baseApiUrl/auth/google';
  static const String authGoogleCallback = '$baseApiUrl/auth/google/callback';

  // === USERS ===
  static const String users = '$baseApiUrl/users';
  static const String userProfile = '$baseApiUrl/users/profile';
  static const String userStats = '$baseApiUrl/users/stats';
  static const String userCompleteProfile =
      '$baseApiUrl/users/complete-profile';
  static const String userAvatar = '$baseApiUrl/users/avatar';

  // === HABITS ===
  static const String habits = '$baseApiUrl/habits';
  static const String habitsStats = '$baseApiUrl/habits/stats';
  static const String habitsCheck = '$baseApiUrl/habits/:id/check';
  static const String habitsBulkCheck = '$baseApiUrl/habits/bulk-check';
  static const String habitsEntries = '$baseApiUrl/habits/:id/entries';
  static const String habitsArchive = '$baseApiUrl/habits/:id/archive';
  static const String habitsId = '$baseApiUrl/habits/:id';

  // === GROUPS ===
  static const String groups = '$baseApiUrl/groups';
  static const String groupsActivity = '$baseApiUrl/groups/:id/activity';
  static const String groupsMembers = '$baseApiUrl/groups/:id/members';
  static const String groupsInvite = '$baseApiUrl/groups/:id/members/invite';
  static const String groupsJoin = '$baseApiUrl/groups/join';
  static const String groupsCode = '$baseApiUrl/groups/code/:code';
  static const String groupsInvitations = '$baseApiUrl/groups/:id/invitations';

  // === JOURNAL ===
  static const String journalEntries = '$baseApiUrl/journal/entries';
  static const String journalMicro = '$baseApiUrl/journal/micro/:date';
  static const String journalLongform = '$baseApiUrl/journal/longform/:date';
  static const String journalStats = '$baseApiUrl/journal/stats';
  static const String journalSearch = '$baseApiUrl/journal/search';
  static const String journalUpload = '$baseApiUrl/journal/upload-image';

  // === COMPASS ===
  static const String compass = '$baseApiUrl/compass';
  static const String compassGenerate = '$baseApiUrl/compass/generate';
  static const String compassApply = '$baseApiUrl/compass/:id/apply';
  static const String compassProgress = '$baseApiUrl/compass/:id/progress';

  // === INSIGHTS ===
  static const String insights = '$baseApiUrl/insights';
  static const String insightsAnalytics = '$baseApiUrl/insights/analytics';
  static const String insightsQuery = '$baseApiUrl/insights/query';

  // === NOTIFICATIONS ===
  static const String notifications = '$baseApiUrl/notifications';
  static const String notificationsPreferences =
      '$baseApiUrl/notifications/preferences';
  static const String notificationsSubscribe =
      '$baseApiUrl/notifications/subscribe';
  static const String notificationsUnread =
      '$baseApiUrl/notifications/unread-count';

  // === CHALLENGES ===
  static const String challenges = '$baseApiUrl/challenges';
  static const String challengesLeaderboard =
      '$baseApiUrl/challenges/:id/leaderboard';
  static const String challengesJoin = '$baseApiUrl/challenges/:id/join';

  // === FEED ===
  static const String feed = '$baseApiUrl/feed';
  static const String feedReactions = '$baseApiUrl/feed/:eventId/reactions';
  static const String feedKudos = '$baseApiUrl/groups/:groupId/kudos';

  // Helper methods
  static String replaceParam(String path, String param, String value) {
    return path.replaceAll(':$param', value);
  }
}
