// lib/features/analytics_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:bito/shared/shared.dart';
import 'package:bito/data/analytics/analytics_provider.dart';
import 'package:bito/data/analytics/analytics_data.dart';

class AnalyticsScreen extends ConsumerStatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  ConsumerState<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends ConsumerState<AnalyticsScreen> {
  String _selectedTimeframe = '7D';
  final List<String> _timeframes = ['7D', '14D', '30D', '90D'];

  // Method to refresh data when timeframe changes
  void _refreshData() {
    ref.refresh(analyticsDataProvider);
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<BitoColorScheme>()!;
    final textTheme = Theme.of(context).textTheme;
    final analyticsAsync = ref.watch(analyticsDataProvider);

    return Scaffold(
      backgroundColor: colors.bg,
      body: SafeArea(
        child: analyticsAsync.when(
          data: (data) => _buildContent(context, colors, textTheme, data),
          loading: () => const Center(
            child: Padding(
              padding: EdgeInsets.all(32),
              child: LoadingIndicator(),
            ),
          ),
          error: (error, stack) => Center(
            child: Text(
              'Error loading analytics: $error',
              style: TextStyle(color: colors.error),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContent(
      BuildContext context,
      BitoColorScheme colors,
      TextTheme textTheme,
      AnalyticsData data,
      ) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context, colors, textTheme, data),
          const SizedBox(height: 20),
          _buildStatsGrid(context, colors, textTheme, data.stats),
          const SizedBox(height: 20),
          _buildDailyPerformanceChart(context, colors, textTheme, data.dailyPerformance),
          const SizedBox(height: 24),
          _buildCurrentStreaksChart(context, colors, textTheme, data.streaks),
          const SizedBox(height: 24),
          _buildTopHabits(context, colors, textTheme, data.streaks),
          const SizedBox(height: 24),
          _buildInsightsCard(context, colors, textTheme, data),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildHeader(
      BuildContext context,
      BitoColorScheme colors,
      TextTheme textTheme,
      AnalyticsData data,
      ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'SIGNAL REPORT',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: colors.ink3,
                letterSpacing: 1.2,
                fontFamily: 'SpaceMono',
              ),
            ),
            /*Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: colors.signal.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                'MP',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: colors.signal,
                  fontFamily: 'SpaceMono',
                ),
              ),
            ),*/
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Analytics',
              style: textTheme.displayMedium?.copyWith(
                color: colors.ink,
              ),
            ),
            // Dropdown for timeframe selection
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: colors.line),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _selectedTimeframe,
                  icon: Icon(
                    Icons.keyboard_arrow_down,
                    size: 16,
                    color: colors.ink2,
                  ),
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: colors.ink2,
                    fontFamily: 'SpaceMono',
                  ),
                  items: _timeframes.map((String timeframe) {
                    return DropdownMenuItem<String>(
                      value: timeframe,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Text(
                          timeframe,
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: _selectedTimeframe == timeframe
                                ? colors.signal2
                                : colors.ink2,
                            fontFamily: 'SpaceMono',
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    if (newValue != null && newValue != _selectedTimeframe) {
                      setState(() {
                        _selectedTimeframe = newValue;
                      });
                      // Refresh data when timeframe changes
                      _refreshData();
                    }
                  },
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          '${data.stats.activeHabits} ACTIVE HABITS · ${_selectedTimeframe} WINDOW',
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w500,
            color: colors.ink3,
            letterSpacing: 0.5,
            fontFamily: 'SpaceMono',
          ),
        ),
      ],
    );
  }

  Widget _buildStatsGrid(
      BuildContext context,
      BitoColorScheme colors,
      TextTheme textTheme,
      AnalyticsStats stats,
      ) {
    final statItems = [
      {'value': '${stats.activeHabits}', 'label': 'ACTIVE\nHABITS'},
      {'value': '${stats.completions}', 'label': 'COMPLETIONS'},
      {'value': stats.bestStreak, 'label': 'BEST\nSTREAK'},
      {'value': stats.weeklyGoals, 'label': 'WEEKLY\nGOALS'},
    ];

    return Container(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colors.line),
      ),
      child: Row(
        children: statItems.asMap().entries.map((entry) {
          final index = entry.key;
          final stat = entry.value;

          return Expanded(
            child: Stack(
              alignment: Alignment.center, // <--- Add this to center the column in the cell
              children: [
                // Stat content
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center, // Ensures text is centered within the column
                    children: [
                      Text(
                        stat['value']!,
                        style: textTheme.displayMedium?.copyWith(
                          color: colors.ink,
                          fontSize: 24,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        stat['label']!,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 8,
                          fontWeight: FontWeight.w700,
                          color: colors.ink3,
                          letterSpacing: 0.5,
                          fontFamily: 'SpaceMono',
                        ),
                      ),
                    ],
                  ),
                ),
                // Vertical separator (except for last item) - full height
                if (index < statItems.length - 1)
                  Positioned.fill(
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Container(
                        width: 1,
                        color: colors.line,
                      ),
                    ),
                  ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildDailyPerformanceChart(
      BuildContext context,
      BitoColorScheme colors,
      TextTheme textTheme,
      List<DailyPerformance> dailyData,
      ) {
    if (dailyData.isEmpty) {
      return const SizedBox.shrink();
    }

    final average = dailyData.fold(0.0, (sum, day) => sum + day.percentage) / dailyData.length;

    return Container(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colors.line),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'DAILY PERFORMANCE',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: colors.ink3,
                  letterSpacing: 1.2,
                  fontFamily: 'SpaceMono',
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: colors.signal2.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  'AVG ${average.toInt()}%',
                  style: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                    color: colors.signal2,
                    fontFamily: 'SpaceMono',
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 150,
            child: SfCartesianChart(
              plotAreaBorderWidth: 0,
              margin: const EdgeInsets.only(left: 8, right: 8, top: 8, bottom: 16),
              primaryXAxis: CategoryAxis(
                majorGridLines: const MajorGridLines(width: 0),
                majorTickLines: const MajorTickLines(size: 0),
                axisLine: const AxisLine(width: 0),
                labelStyle: TextStyle(
                  color: colors.ink3,
                  fontSize: 8,
                  fontFamily: 'SpaceMono',
                ),
              ),
              primaryYAxis: NumericAxis(
                minimum: 0,
                maximum: 100,
                interval: 25,
                axisLine: const AxisLine(width: 0),
                majorTickLines: const MajorTickLines(size: 0),
                labelFormat: '{value}%',
                labelStyle: TextStyle(
                  color: colors.ink3,
                  fontSize: 8,
                  fontFamily: 'SpaceMono',
                ),
                majorGridLines: MajorGridLines(
                  color: colors.line.withValues(alpha: 0.3),
                  width: 1,
                ),
              ),
              series: <CartesianSeries<DailyPerformance, String>>[
                SplineAreaSeries<DailyPerformance, String>(
                  dataSource: dailyData,
                  xValueMapper: (DailyPerformance data, _) => data.date,
                  yValueMapper: (DailyPerformance data, _) => data.percentage,
                  color: colors.signal2,
                  borderColor: colors.signal2,
                  borderWidth: 2,
                  opacity: 0.3,
                  enableTooltip: true,
                  markerSettings: const MarkerSettings(
                    isVisible: false,
                  ),
                  animationDuration: 300,
                ),
              ],
              tooltipBehavior: TooltipBehavior(
                enable: true,
                header: '',
                canShowMarker: false,
                builder: (dynamic data, dynamic point, dynamic series, int pointIndex, int seriesIndex) {
                  final day = dailyData[pointIndex];
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: colors.surface,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: colors.signal),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.15),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Text(
                      '${day.completed}/${day.total} habits completed',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: colors.ink,
                        fontFamily: 'SpaceMono',
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  // NEW: Current Streaks Bar Chart
  Widget _buildCurrentStreaksChart(
      BuildContext context,
      BitoColorScheme colors,
      TextTheme textTheme,
      List<HabitStreak> streaks,
      ) {
    // Array mimicking the varied colors in the mockup
    final barColors = [
      colors.signal,
      Colors.pink.shade400,
      colors.signal,
      Colors.teal.shade400,
      colors.signal,
      Colors.lightBlue.shade400,
      Colors.blue.shade600,
      colors.signal,
    ];

    return Container(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colors.line),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'CURRENT STREAKS',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: colors.ink3,
              letterSpacing: 1.2,
              fontFamily: 'SpaceMono',
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: (streaks.length * 40.0).clamp(200.0, 400.0), // Dynamic height based on items
            child: SfCartesianChart(
              plotAreaBorderWidth: 0,
              margin: EdgeInsets.zero,
              primaryXAxis: CategoryAxis(
                isInversed: true, // Puts the first item at the top
                majorGridLines: const MajorGridLines(width: 0),
                majorTickLines: const MajorTickLines(size: 0),
                axisLine: const AxisLine(width: 0),
                labelStyle: TextStyle(
                  color: colors.ink2,
                  fontSize: 10,
                  fontFamily: 'SpaceMono',
                ),
                maximumLabelWidth: 100,
              ),
              primaryYAxis: NumericAxis(
                minimum: 0,
                // Dotted vertical grid lines like the image
                majorGridLines: MajorGridLines(
                  color: colors.line.withValues(alpha: 0.3),
                  width: 1,
                  dashArray: const <double>[4, 4],
                ),
                majorTickLines: const MajorTickLines(size: 0),
                axisLine: const AxisLine(width: 0),
                labelStyle: TextStyle(
                  color: colors.ink3,
                  fontSize: 10,
                  fontFamily: 'SpaceMono',
                ),
              ),
              series: <CartesianSeries<HabitStreak, String>>[
                BarSeries<HabitStreak, String>(
                  dataSource: streaks,
                  // Truncates labels manually with ellipsis
                  xValueMapper: (HabitStreak data, _) =>
                  data.name.length > 15 ? '${data.name.substring(0, 12)}...' : data.name,
                  yValueMapper: (HabitStreak data, _) => data.currentStreak,
                  pointColorMapper: (HabitStreak data, int index) =>
                  barColors[index % barColors.length],
                  borderRadius: BorderRadius.circular(20), // Fully rounded bars
                  width: 0.5, // Thin bars like the image
                  animationDuration: 500,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopHabits(
      BuildContext context,
      BitoColorScheme colors,
      TextTheme textTheme,
      List<HabitStreak> streaks,
      ) {

    final sortedStreaks = List<HabitStreak>.from(streaks);
    sortedStreaks.sort((a, b) {
      double getProgress(HabitStreak streak) {
        if (streak.value.contains('%')) {
          return double.parse(streak.value.replaceAll('%', '')) / 100;
        } else if (streak.value.contains('/')) {
          final parts = streak.value.split('/');
          if (parts.length == 2) {
            final numerator = double.tryParse(parts[0]) ?? 0;
            final denominator = double.tryParse(parts[1].replaceAll('w', '')) ?? 1;
            return numerator / denominator;
          }
        }
        return 0.0;
      }
      return getProgress(b).compareTo(getProgress(a));
    });

    return Container(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colors.line),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'TOP HABITS', // Renamed title
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: colors.ink3,
              letterSpacing: 1.2,
              fontFamily: 'SpaceMono',
            ),
          ),
          const SizedBox(height: 12),
          // Map over the SORTED streaks instead of the original list
          ...sortedStreaks.asMap().entries.map((entry) {
            final index = entry.key;
            final streak = entry.value;

            // Reuse your existing progress calculation logic
            double progress = 0.0;
            if (streak.value.contains('%')) {
              progress = double.parse(streak.value.replaceAll('%', '')) / 100;
            } else if (streak.value.contains('/')) {
              final parts = streak.value.split('/');
              if (parts.length == 2) {
                final numerator = double.tryParse(parts[0]) ?? 0;
                final denominator = double.tryParse(parts[1].replaceAll('w', '')) ?? 1;
                progress = numerator / denominator;
              }
            }

            progress = progress.clamp(0.0, 1.0);
            final isComplete = streak.isComplete || progress >= 0.8;
            final displayNumber = (index + 1).toString().padLeft(2, '0');

            return Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 28,
                        child: Text(
                          displayNumber,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: colors.ink3,
                            fontFamily: 'SpaceMono',
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      SizedBox(
                        width: 100,
                        child: Text(
                          streak.name,
                          style: TextStyle(
                            fontSize: 13,
                            color: colors.ink,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Stack(
                          children: [
                            Container(
                              height: 4,
                              decoration: BoxDecoration(
                                color: colors.line2,
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                            FractionallySizedBox(
                              widthFactor: progress,
                              child: Container(
                                height: 4,
                                decoration: BoxDecoration(
                                  color: isComplete ? colors.signal : colors.signal2,
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        streak.value,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: isComplete ? colors.signal : colors.ink3,
                          fontFamily: 'SpaceMono',
                        ),
                      ),
                    ],
                  ),
                ),
                if (index < sortedStreaks.length - 1)
                  Divider(
                    height: 1,
                    color: colors.line.withValues(alpha: 0.5),
                  ),
              ],
            );
          }),
        ],
      ),
    );
  }

  Widget _buildInsightsCard(
      BuildContext context,
      BitoColorScheme colors,
      TextTheme textTheme,
      AnalyticsData data,
      ) {
    return Container(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colors.line),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // AI Signal
          Padding(
            padding: const EdgeInsets.all(16),
            child: _buildAISignal(context, colors, textTheme, data.aiSignal),
          ),

          // Full-width separator - extends to card edges
          Container(
            height: 1,
            color: colors.line,
          ),

          // Ask Your Data
          Padding(
            padding: const EdgeInsets.all(16),
            child: _buildAskYourData(context, colors, data.aiSignal),
          ),

          // Full-width separator
          Container(
            height: 1,
            color: colors.line,
          ),

          // Patterns
          Padding(
            padding: const EdgeInsets.all(16),
            child: _buildPatterns(context, colors, textTheme, data.patterns),
          ),

          // Full-width separator
          Container(
            height: 1,
            color: colors.line,
          ),

          // Trends
          Padding(
            padding: const EdgeInsets.all(16),
            child: _buildTrends(context, colors, textTheme, data.trends),
          ),

          // Full-width separator
          Container(
            height: 1,
            color: colors.line,
          ),

          // Correlations
          Padding(
            padding: const EdgeInsets.all(16),
            child: _buildCorrelations(context, colors, textTheme, data.correlations),
          ),

          // Full-width separator
          Container(
            height: 1,
            color: colors.line,
          ),

          // Recommendations
          Padding(
            padding: const EdgeInsets.all(16),
            child: _buildRecommendations(context, colors, textTheme, data.recommendations),
          ),
        ],
      ),
    );
  }

  Widget _buildAISignal(
      BuildContext context,
      BitoColorScheme colors,
      TextTheme textTheme,
      AISignal aiSignal,
      ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(
                  PhosphorIcons.robot(),
                  size: 16,
                  color: colors.signal2,
                ),
                const SizedBox(width: 8),
                Text(
                  'AI SIGNAL',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: colors.ink3,
                    letterSpacing: 1.2,
                    fontFamily: 'SpaceMono',
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: colors.signal.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    'The Briefing',
                    style: TextStyle(
                      fontSize: 7,
                      fontWeight: FontWeight.w700,
                      color: colors.signal,
                      fontFamily: 'SpaceMono',
                    ),
                  ),
                ),
              ],
            ),
            OutlinedButton(
              onPressed: () {
                ref.refresh(analyticsDataProvider);
              },
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                side: BorderSide(color: colors.line),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              child: Text(
                'REFRESH',
                style: TextStyle(
                  fontSize: 8,
                  fontWeight: FontWeight.w700,
                  color: colors.ink3,
                  letterSpacing: 0.5,
                  fontFamily: 'SpaceMono',
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Text(
          '"${aiSignal.briefing}"',
          style: TextStyle(
            fontSize: 13,
            height: 1.6,
            color: colors.ink2,
            fontStyle: FontStyle.italic,
          ),
        ),
      ],
    );
  }

  Widget _buildAskYourData(
      BuildContext context,
      BitoColorScheme colors,
      AISignal aiSignal,
      ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'ASK YOUR DATA',
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w700,
            color: colors.ink3,
            letterSpacing: 1.2,
            fontFamily: 'SpaceMono',
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: aiSignal.questions.map((question) {
            return _buildQuestionChip(question, colors);
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildQuestionChip(String text, BitoColorScheme colors) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: colors.bg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: colors.line),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            PhosphorIcons.chatCircle(),
            size: 12,
            color: colors.signal,
          ),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w500,
              color: colors.ink2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPatterns(
      BuildContext context,
      BitoColorScheme colors,
      TextTheme textTheme,
      List<AnalyticsPattern> patterns,
      ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'PATTERNS',
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w700,
            color: colors.ink3,
            letterSpacing: 1.2,
            fontFamily: 'SpaceMono',
          ),
        ),
        const SizedBox(height: 8),
        ...patterns.map((pattern) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _buildPatternItem(
              pattern.title,
              pattern.description,
              colors,
              isStable: pattern.isStable,
            ),
          );
        }).toList(),
      ],
    );
  }

  Widget _buildPatternItem(
      String title,
      String description,
      BitoColorScheme colors, {
        bool isStable = false,
      }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 4),
          width: 4,
          height: 4,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: colors.signal,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: colors.ink,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: TextStyle(
                  fontSize: 12,
                  height: 1.5,
                  color: colors.ink2,
                ),
              ),
              if (isStable)
                Container(
                  margin: const EdgeInsets.only(top: 4),
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: colors.line2,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    'Stable',
                    style: TextStyle(
                      fontSize: 7,
                      fontWeight: FontWeight.w700,
                      color: colors.ink3,
                      fontFamily: 'SpaceMono',
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTrends(
      BuildContext context,
      BitoColorScheme colors,
      TextTheme textTheme,
      List<AnalyticsTrend> trends,
      ) {
    if (trends.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'TRENDS',
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w700,
            color: colors.ink3,
            letterSpacing: 1.2,
            fontFamily: 'SpaceMono',
          ),
        ),
        const SizedBox(height: 8),
        ...trends.map((trend) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              children: [
                Container(
                  width: 4,
                  height: 4,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: colors.signal,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        trend.title,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: colors.ink,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        trend.description,
                        style: TextStyle(
                          fontSize: 12,
                          height: 1.5,
                          color: colors.ink2,
                        ),
                      ),
                      if (trend.badge.isNotEmpty)
                        Container(
                          margin: const EdgeInsets.only(top: 4),
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: colors.line2,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            trend.badge,
                            style: TextStyle(
                              fontSize: 7,
                              fontWeight: FontWeight.w700,
                              color: colors.ink3,
                              fontFamily: 'SpaceMono',
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ],
    );
  }

  Widget _buildCorrelations(
      BuildContext context,
      BitoColorScheme colors,
      TextTheme textTheme,
      List<AnalyticsCorrelation> correlations,
      ) {
    if (correlations.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'CORRELATIONS',
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w700,
            color: colors.ink3,
            letterSpacing: 1.2,
            fontFamily: 'SpaceMono',
          ),
        ),
        const SizedBox(height: 8),
        ...correlations.map((correlation) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              children: [
                Container(
                  width: 4,
                  height: 4,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: colors.signal,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        correlation.title,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: colors.ink,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        correlation.description,
                        style: TextStyle(
                          fontSize: 12,
                          height: 1.5,
                          color: colors.ink2,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ],
    );
  }

  Widget _buildRecommendations(
      BuildContext context,
      BitoColorScheme colors,
      TextTheme textTheme,
      List<AnalyticsRecommendation> recommendations,
      ) {
    if (recommendations.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'RECOMMENDATIONS',
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w700,
            color: colors.ink3,
            letterSpacing: 1.2,
            fontFamily: 'SpaceMono',
          ),
        ),
        const SizedBox(height: 8),
        ...recommendations.map((rec) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 4,
                      height: 4,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: colors.signal,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        rec.title,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: colors.ink,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        rec.description,
                        style: TextStyle(
                          fontSize: 12,
                          height: 1.5,
                          color: colors.ink2,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: _getPriorityColor(rec.priority, colors),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          rec.priority,
                          style: TextStyle(
                            fontSize: 7,
                            fontWeight: FontWeight.w700,
                            color: Colors.black,
                            fontFamily: 'SpaceMono',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ],
    );
  }

  Color _getPriorityColor(String priority, BitoColorScheme colors) {
    switch (priority.toLowerCase()) {
      case 'high':
        return Colors.red.shade400;
      case 'medium':
        return Colors.orange.shade400;
      default:
        return colors.line2;
    }
  }
}
