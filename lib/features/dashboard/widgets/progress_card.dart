// lib/features/dashboard/widgets/progress_card.dart
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../../shared/components/cards/stat_card.dart';
import 'package:bito/theme/theme_extensions.dart';

class ProgressCard extends StatelessWidget {
  final int completed;
  final int total;

  const ProgressCard({
    super.key,
    required this.completed,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    final percentage = total == 0 ? 0 : ((completed / total) * 100).round();
    final colors = Theme.of(context).extension<BitoColorScheme>()!;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: StatCard(
        title: "Today's Progress",
        value: '$percentage%',
        subtitle: '$completed of $total habits completed',
        icon: Icon(
          PhosphorIcons.chartPie(),
          color: colors.signal,
        ),
      ),
    );
  }
}

