// lib/features/dashboard/widgets/week_card.dart
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:bito/theme/theme_extensions.dart';

class WeekDay {
  final String label;
  final String state;
  final int done;
  final int total;

  const WeekDay({
    required this.label,
    required this.state,
    required this.done,
    required this.total,
  });
}

class WeekCard extends StatefulWidget {
  final List<WeekDay> weekData;
  final String dateRange;

  const WeekCard({
    super.key,
    required this.weekData,
    required this.dateRange,
  });

  @override
  State<WeekCard> createState() => _WeekCardState();
}

class _WeekCardState extends State<WeekCard> {
  int _selectedRange = 0; // 0: W, 1: M, 2: Y
  final List<String> _ranges = ['W', 'M', 'Y'];

  // Track current week offset (0 = current week, -1 = previous, 1 = next)
  int _weekOffset = 0;

  // For monthly view
  int _currentMonth = DateTime.now().month;
  int _currentYear = DateTime.now().year;

  // For yearly view
  int _viewYear = DateTime.now().year;

  void _goToPrevious() {
    setState(() {
      if (_selectedRange == 0) {
        _weekOffset--;
      } else if (_selectedRange == 1) {
        _currentMonth--;
        if (_currentMonth == 0) {
          _currentMonth = 12;
          _currentYear--;
        }
      } else {
        _viewYear--;
      }
    });
  }

  void _goToNext() {
    setState(() {
      if (_selectedRange == 0) {
        _weekOffset++;
      } else if (_selectedRange == 1) {
        _currentMonth++;
        if (_currentMonth == 13) {
          _currentMonth = 1;
          _currentYear++;
        }
      } else {
        _viewYear++;
      }
    });
  }

  void _goToToday() {
    setState(() {
      _weekOffset = 0;
      _currentMonth = DateTime.now().month;
      _currentYear = DateTime.now().year;
      _viewYear = DateTime.now().year;
    });
  }

  bool get _isTodayView {
    if (_selectedRange == 0) return _weekOffset == 0;
    if (_selectedRange == 1) {
      return _currentMonth == DateTime.now().month &&
          _currentYear == DateTime.now().year;
    }
    return _viewYear == DateTime.now().year;
  }

  String _getDateRange() {
    if (_selectedRange == 0) {
      // Calculate week range based on offset
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final startOfWeek = today.subtract(Duration(days: today.weekday - 1));
      final targetWeek = startOfWeek.add(Duration(days: _weekOffset * 7));
      final endOfWeek = targetWeek.add(const Duration(days: 6));

      final startMonth = _monthAbbr(targetWeek.month);
      final endMonth = _monthAbbr(endOfWeek.month);

      if (startMonth == endMonth) {
        return '${startMonth} ${targetWeek.day}–${endOfWeek.day}';
      }
      return '${startMonth} ${targetWeek.day}–${endMonth} ${endOfWeek.day}';
    } else if (_selectedRange == 1) {
      return '${_monthName(_currentMonth)} $_currentYear';
    } else {
      return '$_viewYear';
    }
  }

  String _monthAbbr(int month) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return months[month - 1];
  }

  String _monthName(int month) {
    const months = ['January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'];
    return months[month - 1];
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<BitoColorScheme>()!;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: colors.line),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with date range and range selector
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _getDateRange(),
                  style: TextStyle(
                    fontSize: 14.6,
                    fontWeight: FontWeight.w700,
                    color: colors.ink2,
                    letterSpacing: -0.3,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: colors.line),
                  ),
                  child: Row(
                    children: List.generate(_ranges.length, (index) {
                      final isSelected = _selectedRange == index;
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedRange = index;
                            // Reset to today when switching views
                            _weekOffset = 0;
                            _currentMonth = DateTime.now().month;
                            _currentYear = DateTime.now().year;
                            _viewYear = DateTime.now().year;
                          });
                        },
                        child: Container(
                          width: 22,
                          height: 18,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            color: isSelected ? colors.signal2 : Colors.transparent,
                          ),
                          child: Center(
                            child: Text(
                              _ranges[index],
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: isSelected ? colors.signalInk : colors.ink3,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ),
              ],
            ),

            // Navigation arrows with Today button
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: _goToPrevious,
                    icon: Icon(
                      PhosphorIcons.caretLeft(),
                      size: 20,
                      color: colors.ink3,
                    ),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    style: IconButton.styleFrom(
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                  ),
                  const SizedBox(width: 24),
                  IconButton(
                    onPressed: _goToNext,
                    icon: Icon(
                      PhosphorIcons.caretRight(),
                      size: 20,
                      color: colors.ink3,
                    ),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    style: IconButton.styleFrom(
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                  ),
                  if (!_isTodayView) ...[
                    const SizedBox(width: 16),
                    TextButton(
                      onPressed: _goToToday,
                      style: TextButton.styleFrom(
                        backgroundColor: colors.signal2,
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      child: Text(
                        'TODAY',
                        style: TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.w700,
                          color: Colors.black,
                          letterSpacing: 0.5,
                          fontFamily: 'SpaceMono',
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),

            // Content based on selected range
            if (_selectedRange == 0) ...[
              _buildWeekView(colors),
            ] else if (_selectedRange == 1) ...[
              _buildMonthView(colors),
            ] else ...[
              _buildYearView(colors),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildWeekView(BitoColorScheme colors) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: widget.weekData.map((day) {
        final isComplete = day.state == 'complete' || day.state == 'partial';
        final isToday = day.state == 'today';
        final isUpcoming = day.state == 'upcoming';

        return SizedBox(
          width: 42,
          child: Column(
            children: [
              Text(
                day.label.substring(0, 3),
                style: TextStyle(
                  fontSize: 8,
                  fontWeight: FontWeight.w500,
                  color: colors.ink3,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 6),
              Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color: isComplete
                      ? colors.signal2
                      : isToday
                      ? Colors.transparent
                      : colors.line3,
                  border: isToday
                      ? Border.all(color: colors.signal2, width: 1)
                      : null,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                '${day.done}/${day.total}',
                style: TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.w500,
                  color: isUpcoming ? colors.ink3 : colors.signalInk,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildMonthView(BitoColorScheme colors) {
    // Get days in month
    final daysInMonth = DateTime(_currentYear, _currentMonth + 1, 0).day;
    final firstDayOfMonth = DateTime(_currentYear, _currentMonth, 1).weekday;
    final today = DateTime.now();
    final isCurrentMonth = _currentMonth == today.month && _currentYear == today.year;

    // Generate week day headers
    const weekDays = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];

    return Column(
      children: [
        // Day headers
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: weekDays.map((day) {
            return SizedBox(
              width: 30,
              child: Text(
                day,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 8,
                  fontWeight: FontWeight.w500,
                  color: colors.ink3,
                  letterSpacing: 0.5,
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 8),
        // Calendar grid
        Wrap(
          spacing: 0,
          runSpacing: 4,
          children: List.generate(42, (index) {
            final dayNumber = index - firstDayOfMonth + 1;
            final isInMonth = dayNumber > 0 && dayNumber <= daysInMonth;
            final isToday = isInMonth &&
                isCurrentMonth &&
                dayNumber == today.day;

            return Container(
              width: 30,
              height: 30,
              margin: const EdgeInsets.only(right: 4),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: isInMonth
                    ? (isToday ? colors.signal2 : colors.line3)
                    : Colors.transparent,
                border: isToday
                    ? Border.all(color: colors.signal2, width: 1)
                    : null,
              ),
              child: Center(
                child: Text(
                  isInMonth ? dayNumber.toString() : '',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                    color: isInMonth
                        ? (isToday ? colors.signalInk : colors.ink2)
                        : Colors.transparent,
                  ),
                ),
              ),
            );
          }),
        ),
        // Month stats
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '${_getMonthCompletionRate().toInt()}% completion',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w500,
                color: colors.ink3,
                letterSpacing: 0.5,
                fontFamily: 'SpaceMono',
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildYearView(BitoColorScheme colors) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];

    // Group months in rows of 3
    List<List<int>> monthRows = [];
    for (int i = 0; i < 12; i += 3) {
      monthRows.add([i, i + 1, i + 2].where((m) => m < 12).toList());
    }

    return Column(
      children: monthRows.map((row) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Row(
            children: row.map((monthIndex) {
              final month = monthIndex + 1;
              final isCurrentMonth = month == DateTime.now().month &&
                  _viewYear == DateTime.now().year;
              final progress = _getMonthProgress(month);

              return Expanded(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: colors.surface2,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: isCurrentMonth ? colors.signal2 : colors.line2,
                      width: isCurrentMonth ? 2 : 1,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        months[monthIndex],
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: isCurrentMonth ? colors.signal2 : colors.ink2,
                          letterSpacing: 0.3,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        height: 6,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(3),
                          color: colors.line2,
                        ),
                        child: FractionallySizedBox(
                          widthFactor: progress / 100,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(3),
                              color: isCurrentMonth ? colors.signal2 : colors.signal2,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        '${progress.toInt()}%',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: colors.ink3,
                          letterSpacing: 0.3,
                          fontFamily: 'SpaceMono',
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        );
      }).toList(),
    );
  }

  double _getMonthProgress(int month) {
    // This will be replaced with actual data from API
    // For demo, return random progress
    return (month * 7 + 5) % 100;
  }

  double _getMonthCompletionRate() {
    // This will be replaced with actual data from API
    return 73.5;
  }
}

