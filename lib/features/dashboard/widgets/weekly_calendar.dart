// lib/features/dashboard/widgets/weekly_calendar.dart
import 'package:flutter/material.dart';
import 'package:bito/theme/theme_extensions.dart';

class WeeklyCalendar extends StatelessWidget {
  final List<String> days;
  final List<String> dates;
  final List<String> scores;
  final int todayIndex;
  final String dateRange;

  const WeeklyCalendar({
    super.key,
    this.days = const ['MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT', 'SUN'],
    this.dates = const ['10', '11', '12', '13', '14', '15', '16'],
    this.scores = const ['0/9', '0/9', '0/9', '0/9', '0/9', '0/7', '0/5'],
    this.todayIndex = 1,
    this.dateRange = 'Aug 10 – Aug 16',
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<BitoColorScheme>()!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              dateRange,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: colors.ink3,
                letterSpacing: 0.3,
              ),
            ),
            Row(
              children: [
                Icon(
                  Icons.chevron_left,
                  size: 20,
                  color: colors.ink3,
                ),
                const SizedBox(width: 4),
                Icon(
                  Icons.chevron_right,
                  size: 20,
                  color: colors.ink3,
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(7, (index) {
            final isToday = index == todayIndex;
            return Column(
              children: [
                Text(
                  days[index],
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                    color: isToday ? colors.ink : colors.ink3,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isToday ? colors.signal2 : Colors.transparent,
                  ),
                  child: Center(
                    child: Text(
                      dates[index],
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: isToday ? colors.signalInk : colors.ink2,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  scores[index],
                  style: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w500,
                    color: colors.ink3,
                    letterSpacing: 0.3,
                  ),
                ),
              ],
            );
          }),
        ),
      ],
    );
  }
}

