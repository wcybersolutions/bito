// lib/features/settings/settings_screen.dart
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:go_router/go_router.dart';

import '../../theme/theme_extensions.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // ── State ──────────────────────────────────────────────────────────────────
  bool _pushNotifications = false;
  bool _emailUpdates = true;
  bool _dashboardSharing = true;
  bool _dashboardInsights = true;
  bool _analyticsInsights = true;

  String _dashboardStyle = 'Daybook';
  String _timezone = 'UTC';
  String _weekStartsOn = 'Monday';
  String _journalDefaultView = 'Day view';
  String _aiVoice = 'Neutral';
  int _textSize = 0; // 0=Small, 1=Medium, 2=Large

  String _designLanguage = 'Legacy';
  String _colorWorld = 'Legacy';
  String _palette = 'Indigo';
  String _signal = 'Complement';
  String _theme = 'Dark';

  // ── Helpers ────────────────────────────────────────────────────────────────
  final List<String> _textSizeLabels = ['Small\nDefault', 'Medium\nComfortable', 'Large\nSpacious'];

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<BitoColorScheme>()!;

    return Scaffold(
      backgroundColor: colors.bg,
      body: SafeArea(
        child: Column(
          children: [
            // ── App header ─────────────────────────────────────────────────
            _buildHeader(context, colors),
            // ── Scrollable content ─────────────────────────────────────────
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                children: [
                  // Section tabs hint
                  _buildSectionTabs(colors),
                  const SizedBox(height: 24),

                  // PROFILE
                  _SectionLabel(label: 'PROFILE', colors: colors),
                  const SizedBox(height: 10),
                  _buildProfileCard(colors),
                  const SizedBox(height: 24),

                  // APPEARANCE
                  _SectionLabel(label: 'APPEARANCE', colors: colors),
                  const SizedBox(height: 10),
                  _buildAppearanceCard(colors),
                  const SizedBox(height: 24),

                  // TEXT SIZE
                  _SectionLabel(label: 'TEXT SIZE', colors: colors),
                  const SizedBox(height: 10),
                  _buildTextSizeCard(colors),
                  const SizedBox(height: 24),

                  // PREFERENCES
                  _SectionLabel(label: 'PREFERENCES', colors: colors),
                  const SizedBox(height: 10),
                  _buildPreferencesCard(colors),
                  const SizedBox(height: 24),

                  // AI FEATURES
                  _SectionLabel(label: 'AI FEATURES', colors: colors),
                  const SizedBox(height: 10),
                  _buildAIFeaturesCard(colors),
                  const SizedBox(height: 24),

                  // NOTIFICATIONS
                  _SectionLabel(label: 'NOTIFICATIONS', colors: colors),
                  const SizedBox(height: 10),
                  _buildNotificationsCard(colors),
                  const SizedBox(height: 24),

                  // PRIVACY
                  _SectionLabel(label: 'PRIVACY', colors: colors),
                  const SizedBox(height: 10),
                  _buildPrivacyCard(colors),
                  const SizedBox(height: 24),

                  // DATA
                  _SectionLabel(label: 'DATA', colors: colors),
                  const SizedBox(height: 10),
                  _buildDataCard(colors),
                  const SizedBox(height: 24),

                  // ABOUT
                  _SectionLabel(label: 'ABOUT', colors: colors),
                  const SizedBox(height: 10),
                  _buildAboutCard(colors),
                  const SizedBox(height: 24),

                  // SUPPORT
                  _SectionLabel(label: 'SUPPORT', colors: colors),
                  const SizedBox(height: 10),
                  _buildSupportCard(colors),
                  const SizedBox(height: 24),

                  // DANGER ZONE
                  _SectionLabel(label: 'DANGER ZONE', colors: colors),
                  const SizedBox(height: 10),
                  _buildDangerZoneCard(colors),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Header ────────────────────────────────────────────────────────────────
  Widget _buildHeader(BuildContext context, BitoColorScheme colors) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Logo
              Row(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: colors.signal2,
                      borderRadius: BorderRadius.circular(9),
                    ),
                    child: Icon(
                      PhosphorIcons.spiral(),
                      size: 18,
                      color: colors.signalInk,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'bito',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: colors.ink,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  IconButton(
                    onPressed: () => context.go('/notifications'),
                    icon: Icon(PhosphorIcons.bell(), size: 20, color: colors.ink2),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                  const SizedBox(width: 14),
                  CircleAvatar(
                    radius: 16,
                    backgroundColor: colors.signal2,
                    child: Text(
                      'U',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: colors.signalInk,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            'CONFIGURATION',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: colors.ink3,
              letterSpacing: 1.5,
              fontFamily: 'SpaceMono',
            ),
          ),
          const SizedBox(height: 2),
          Text(
            'Settings',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w700,
              color: colors.ink,
              letterSpacing: -0.5,
            ),
          ),
        ],
      ),
    );
  }

  // ── Section tabs ─────────────────────────────────────────────────────────
  Widget _buildSectionTabs(BitoColorScheme colors) {
    return Row(
      children: [
        _tab('ACCOUNT', colors),
        Text(' · ', style: TextStyle(color: colors.ink3, fontSize: 12)),
        _tab('PREFERENCES', colors),
        Text(' · ', style: TextStyle(color: colors.ink3, fontSize: 12)),
        _tab('DATA', colors),
      ],
    );
  }

  Widget _tab(String label, BitoColorScheme colors) {
    return Text(
      label,
      style: TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w600,
        color: colors.ink2,
        letterSpacing: 0.8,
        fontFamily: 'SpaceMono',
      ),
    );
  }

  // ── Profile ───────────────────────────────────────────────────────────────
  Widget _buildProfileCard(BitoColorScheme colors) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF161618), // Dark card from screenshot
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: colors.signal2),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 28,
                backgroundColor: colors.signal2,
                child: Text(
                  'JK',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: colors.signalInk,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Joseph Katsande',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: colors.ink,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '@jabari · katsandejoseph39@gmail.com',
                      style: TextStyle(
                        fontSize: 12,
                        color: colors.ink2,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    foregroundColor: colors.ink,
                    side: BorderSide(color: colors.signal2),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text('Change avatar', style: TextStyle(fontWeight: FontWeight.w600)),
                ),
              ),
              const SizedBox(width: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border: Border.all(color: colors.signal2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(PhosphorIcons.googleLogo(), size: 20, color: colors.ink),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ── Appearance ────────────────────────────────────────────────────────────
  Widget _buildAppearanceCard(BitoColorScheme colors) {
    return _SettingsCard(
      colors: colors,
      child: Column(
        children: [
          _DropdownRow(
            label: 'DESIGN LANGUAGE',
            subtitle: 'Legacy',
            value: _designLanguage,
            options: const ['Legacy', 'Standard'],
            onChanged: (v) => setState(() => _designLanguage = v!),
            colors: colors,
          ),
          _DividerFull(colors: colors),
          _DropdownRow(
            label: 'COLOR WORLD',
            subtitle: 'Your whole environment shifts...',
            value: _colorWorld,
            options: const ['Legacy', 'Modern'],
            onChanged: (v) => setState(() => _colorWorld = v!),
            colors: colors,
          ),
          _DividerFull(colors: colors),
          _DropdownRow(
            label: 'PALETTE',
            subtitle: 'Indigo',
            value: _palette,
            options: const ['Indigo', 'Mineral', 'Forest', 'Ember', 'Ocean', 'Rose', 'Hue'],
            onChanged: (v) => setState(() => _palette = v!),
            colors: colors,
          ),
          _DividerFull(colors: colors),
          _DropdownRow(
            label: 'SIGNAL',
            subtitle: 'Complement',
            value: _signal,
            options: const ['Complement', 'Native'],
            onChanged: (v) => setState(() => _signal = v!),
            colors: colors,
          ),
          _DividerFull(colors: colors),
          _DropdownRow(
            label: 'THEME',
            subtitle: 'Dark',
            value: _theme,
            options: const ['Light', 'Dark', 'System'],
            onChanged: (v) => setState(() => _theme = v!),
            colors: colors,
          ),
        ],
      ),
    );
  }

  // ── Text size ─────────────────────────────────────────────────────────────
  Widget _buildTextSizeCard(BitoColorScheme colors) {
    return _SettingsCard(
      colors: colors,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Scale text and UI elements for readability',
              style: TextStyle(fontSize: 13, color: colors.ink2),
            ),
            const SizedBox(height: 16),
            Row(
              children: List.generate(3, (i) {
                final selected = _textSize == i;
                return Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _textSize = i),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      margin: EdgeInsets.only(right: i < 2 ? 10 : 0),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: colors.surface2,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: selected ? colors.signal2 : colors.line,
                          width: selected ? 2 : 1,
                        ),
                      ),
                      child: Column(
                        children: [
                          // Preview lines
                          Container(
                            height: 6,
                            width: double.infinity,
                            margin: const EdgeInsets.only(bottom: 4),
                            decoration: BoxDecoration(
                              color: selected ? colors.signal2 : colors.line2,
                              borderRadius: BorderRadius.circular(3),
                            ),
                          ),
                          Container(
                            height: 4,
                            width: double.infinity * 0.7,
                            margin: const EdgeInsets.only(bottom: 4),
                            decoration: BoxDecoration(
                              color: colors.line2,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                          Container(
                            height: 4,
                            width: double.infinity * 0.5,
                            decoration: BoxDecoration(
                              color: colors.line2,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            _textSizeLabels[i],
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: selected ? colors.signal2 : colors.ink3,
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  // ── Preferences ──────────────────────────────────────────────────────────
  Widget _buildPreferencesCard(BitoColorScheme colors) {
    return _SettingsCard(
      colors: colors,
      child: Column(
        children: [
          _DropdownRow(
            label: 'Timezone',
            subtitle: 'Your local timezone for accurate tracking',
            value: _timezone,
            options: const ['UTC', 'UTC+1', 'UTC+2', 'UTC+3', 'UTC+5:30', 'UTC+8', 'UTC+9', 'UTC-5', 'UTC-8'],
            colors: colors,
            onChanged: (v) => setState(() => _timezone = v!),
          ),
          _DividerFull(colors: colors),
          _DropdownRow(
            label: 'Week Starts On',
            subtitle: 'Which day your week begins',
            value: _weekStartsOn,
            options: const ['Monday', 'Sunday', 'Saturday'],
            colors: colors,
            onChanged: (v) => setState(() => _weekStartsOn = v!),
          ),
          _DividerFull(colors: colors),
          _DropdownRow(
            label: 'Journal Default View',
            subtitle: 'Which view opens when you visit your journal',
            value: _journalDefaultView,
            options: const ['Day view', 'Week view', 'Month view'],
            colors: colors,
            onChanged: (v) => setState(() => _journalDefaultView = v!),
          ),
          _DividerFull(colors: colors),
          _DropdownRow(
            label: 'Dashboard Style',
            subtitle: 'Daybook (serif almanac) or Mission Control (status console)',
            value: _dashboardStyle,
            options: const ['Daybook', 'Mission Control'],
            colors: colors,
            onChanged: (v) => setState(() => _dashboardStyle = v!),
          ),
        ],
      ),
    );
  }

  // ── AI Features ──────────────────────────────────────────────────────────
  Widget _buildAIFeaturesCard(BitoColorScheme colors) {
    return _SettingsCard(
      colors: colors,
      child: Column(
        children: [
          _ToggleRow(
            label: 'Dashboard Insights',
            subtitle: 'AI-powered nudges and tips on your dashboard',
            value: _dashboardInsights,
            colors: colors,
            onChanged: (v) => setState(() => _dashboardInsights = v),
          ),
          _DividerFull(colors: colors),
          _ToggleRow(
            label: 'Analytics Insights',
            subtitle: 'AI analysis and recommendations on the analytics page',
            value: _analyticsInsights,
            colors: colors,
            onChanged: (v) => setState(() => _analyticsInsights = v),
          ),
          _DividerFull(colors: colors),
          _DropdownRow(
            label: 'AI Voice',
            subtitle: 'Neutral · Patterns · Detailed · Honest',
            value: _aiVoice,
            options: const ['Neutral', 'Patterns', 'Detailed', 'Honest'],
            colors: colors,
            onChanged: (v) => setState(() => _aiVoice = v!),
          ),
        ],
      ),
    );
  }

  // ── Notifications ─────────────────────────────────────────────────────────
  Widget _buildNotificationsCard(BitoColorScheme colors) {
    return _SettingsCard(
      colors: colors,
      child: Column(
        children: [
          _ToggleRow(
            label: 'Push Notifications',
            subtitle: 'Habit reminders & achievement alerts',
            value: _pushNotifications,
            colors: colors,
            onChanged: (v) => setState(() => _pushNotifications = v),
          ),
          _DividerFull(colors: colors),
          _ToggleRow(
            label: 'Email Updates',
            subtitle: 'Weekly reports and summaries',
            value: _emailUpdates,
            colors: colors,
            onChanged: (v) => setState(() => _emailUpdates = v),
          ),
        ],
      ),
    );
  }

  // ── Privacy ───────────────────────────────────────────────────────────────
  Widget _buildPrivacyCard(BitoColorScheme colors) {
    return _SettingsCard(
      colors: colors,
      child: Column(
        children: [
          _ToggleRow(
            label: 'Morning Grind',
            subtitle: 'Members can view your dashboard',
            value: _dashboardSharing,
            colors: colors,
            onChanged: (v) => setState(() => _dashboardSharing = v),
          ),
          if (_dashboardSharing)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: colors.surface2,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: colors.line),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(PhosphorIcons.info(), size: 14, color: colors.ink3),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'When sharing is on, members see a read-only view of your habits and progress. Personal notes stay hidden.',
                        style: TextStyle(
                          fontSize: 12,
                          color: colors.ink3,
                          height: 1.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  // ── Data ─────────────────────────────────────────────────────────────────
  Widget _buildDataCard(BitoColorScheme colors) {
    return _SettingsCard(
      colors: colors,
      child: _NavRow(
        icon: PhosphorIcons.downloadSimple(),
        label: 'Export All Data',
        subtitle: 'Download your habits, entries, and journal as JSON',
        colors: colors,
        onTap: () => _showExportDialog(context, colors),
      ),
    );
  }

  // ── About ─────────────────────────────────────────────────────────────────
  Widget _buildAboutCard(BitoColorScheme colors) {
    return _SettingsCard(
      colors: colors,
      child: Column(
        children: [
          // App info row
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'bito',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: colors.ink,
                      ),
                    ),
                    Text(
                      'v1.0.0',
                      style: TextStyle(fontSize: 12, color: colors.ink3),
                    ),
                  ],
                ),
                const Spacer(),
                Row(
                  children: [
                    Container(
                      width: 7,
                      height: 7,
                      decoration: BoxDecoration(
                        color: colors.success,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'All systems operational',
                      style: TextStyle(
                        fontSize: 11,
                        color: colors.success,
                        fontFamily: 'SpaceMono',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          _DividerFull(colors: colors),
          _NavRow(
            icon: PhosphorIcons.squaresFour(),
            label: 'Replay dashboard tour',
            subtitle: '',
            colors: colors,
            onTap: () {},
          ),
          _DividerFull(colors: colors),
          _NavRow(
            icon: PhosphorIcons.repeat(),
            label: 'Replay habits tour',
            subtitle: '',
            colors: colors,
            onTap: () {},
          ),
          _DividerFull(colors: colors),
          _NavRow(
            icon: PhosphorIcons.list(),
            label: 'Replay journal tour',
            subtitle: '',
            colors: colors,
            onTap: () {},
          ),
        ],
      ),
    );
  }

  // ── Support ───────────────────────────────────────────────────────────────
  Widget _buildSupportCard(BitoColorScheme colors) {
    return _SettingsCard(
      colors: colors,
      child: _NavRow(
        icon: PhosphorIcons.chatCircle(),
        label: 'Contact Support',
        subtitle: 'Get help, report a bug, or send us feedback',
        colors: colors,
        onTap: () {},
      ),
    );
  }

  // ── Danger zone ───────────────────────────────────────────────────────────
  Widget _buildDangerZoneCard(BitoColorScheme colors) {
    return Container(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: colors.error.withValues(alpha: 0.4)),
      ),
      child: Column(
        children: [
          // Reset completion data
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Reset Completion Data',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: colors.ink,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Permanently deletes all completion history. Habits are kept, but streaks, rates, and entry history will be cleared.',
                  style: TextStyle(fontSize: 13, color: colors.ink3, height: 1.5),
                ),
                const SizedBox(height: 8),
                RichText(
                  text: TextSpan(
                    text: 'Recommend ',
                    style: TextStyle(fontSize: 13, color: colors.ink3),
                    children: [
                      TextSpan(
                        text: 'exporting your data',
                        style: TextStyle(
                          fontSize: 13,
                          color: colors.signal2,
                          decoration: TextDecoration.underline,
                          decorationColor: colors.signal2,
                        ),
                      ),
                      const TextSpan(text: ' first.'),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                OutlinedButton(
                  onPressed: () => _showResetDialog(context, colors),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: colors.error),
                    foregroundColor: colors.error,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  ),
                  child: const Text(
                    'Reset Completion Data',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ),
          Divider(height: 1, color: colors.error.withValues(alpha: 0.3)),
          // Delete account
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Delete Account',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: colors.ink,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Permanently delete your account and all associated data. This cannot be undone.',
                  style: TextStyle(fontSize: 13, color: colors.ink3, height: 1.5),
                ),
                const SizedBox(height: 16),
                OutlinedButton(
                  onPressed: () => _showDeleteAccountDialog(context, colors),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: colors.error),
                    foregroundColor: colors.error,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  ),
                  child: const Text(
                    'Delete Account',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Dialogs ───────────────────────────────────────────────────────────────
  void _showExportDialog(BuildContext context, BitoColorScheme colors) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: colors.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Export All Data', style: TextStyle(color: colors.ink, fontWeight: FontWeight.w700)),
        content: Text(
          'Your habits, journal entries, and completions will be downloaded as a JSON file.',
          style: TextStyle(color: colors.ink2, fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Cancel', style: TextStyle(color: colors.ink3)),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx),
            style: ElevatedButton.styleFrom(
              backgroundColor: colors.signal2,
              foregroundColor: colors.signalInk,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text('Export'),
          ),
        ],
      ),
    );
  }

  void _showResetDialog(BuildContext context, BitoColorScheme colors) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: colors.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Reset Completion Data?', style: TextStyle(color: colors.error, fontWeight: FontWeight.w700)),
        content: Text(
          'This will permanently delete all streaks, rates, and completion history. Habits themselves are kept.',
          style: TextStyle(color: colors.ink2, fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Cancel', style: TextStyle(color: colors.ink3)),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx),
            style: ElevatedButton.styleFrom(
              backgroundColor: colors.error,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text('Reset'),
          ),
        ],
      ),
    );
  }

  void _showDeleteAccountDialog(BuildContext context, BitoColorScheme colors) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: colors.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Delete Account?', style: TextStyle(color: colors.error, fontWeight: FontWeight.w700)),
        content: Text(
          'This will permanently delete your account and ALL data. This cannot be undone.',
          style: TextStyle(color: colors.ink2, fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Cancel', style: TextStyle(color: colors.ink3)),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx),
            style: ElevatedButton.styleFrom(
              backgroundColor: colors.error,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text('Delete Account'),
          ),
        ],
      ),
    );
  }
}

// ── Shared sub-widgets ────────────────────────────────────────────────────────

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({required this.label, required this.colors});
  final String label;
  final BitoColorScheme colors;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: TextStyle(
        fontSize: 10,
        fontWeight: FontWeight.w700,
        color: colors.ink3,
        letterSpacing: 1.5,
        fontFamily: 'SpaceMono',
      ),
    );
  }
}

class _SettingsCard extends StatelessWidget {
  const _SettingsCard({required this.colors, required this.child});
  final BitoColorScheme colors;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: colors.line),
      ),
      child: child,
    );
  }
}

class _ToggleRow extends StatelessWidget {
  const _ToggleRow({
    required this.label,
    required this.subtitle,
    required this.value,
    required this.colors,
    required this.onChanged,
  });
  final String label;
  final String subtitle;
  final bool value;
  final BitoColorScheme colors;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: colors.ink,
                  ),
                ),
                if (subtitle.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(subtitle, style: TextStyle(fontSize: 12, color: colors.ink3)),
                ],
              ],
            ),
          ),
          const SizedBox(width: 12),
          Switch(
            value: value,
            onChanged: onChanged,
            activeThumbColor: colors.signal2,
            activeTrackColor: colors.signal2.withValues(alpha: 0.4),
            inactiveThumbColor: colors.ink3,
            inactiveTrackColor: colors.line2,
          ),
        ],
      ),
    );
  }
}

class _DropdownRow extends StatelessWidget {
  const _DropdownRow({
    required this.label,
    required this.subtitle,
    required this.value,
    required this.options,
    required this.colors,
    required this.onChanged,
  });
  final String label;
  final String subtitle;
  final String value;
  final List<String> options;
  final BitoColorScheme colors;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: colors.ink,
                  ),
                ),
                if (subtitle.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(subtitle, style: TextStyle(fontSize: 12, color: colors.ink3)),
                ],
              ],
            ),
          ),
          const SizedBox(width: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: colors.surface2,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: colors.line),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: value,
                isDense: true,
                dropdownColor: colors.surface,
                style: TextStyle(fontSize: 13, color: colors.ink, fontWeight: FontWeight.w500),
                icon: Icon(PhosphorIcons.caretDown(), size: 14, color: colors.ink3),
                items: options
                    .map((o) => DropdownMenuItem(value: o, child: Text(o)))
                    .toList(),
                onChanged: onChanged,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _NavRow extends StatelessWidget {
  const _NavRow({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.colors,
    required this.onTap,
  });
  final IconData icon;
  final String label;
  final String subtitle;
  final BitoColorScheme colors;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Icon(icon, size: 20, color: colors.ink2),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: colors.ink,
                    ),
                  ),
                  if (subtitle.isNotEmpty) ...[
                    const SizedBox(height: 2),
                    Text(subtitle, style: TextStyle(fontSize: 12, color: colors.ink3)),
                  ],
                ],
              ),
            ),
            Icon(PhosphorIcons.caretRight(), size: 16, color: colors.ink3),
          ],
        ),
      ),
    );
  }
}

class _DividerFull extends StatelessWidget {
  const _DividerFull({required this.colors});
  final BitoColorScheme colors;

  @override
  Widget build(BuildContext context) {
    return Divider(height: 1, color: colors.line);
  }
}
