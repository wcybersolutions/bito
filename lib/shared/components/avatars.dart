// lib/shared/components/avatars.dart
import 'package:flutter/material.dart';
import 'package:bito/theme/theme_extensions.dart';

class AppAvatar extends StatelessWidget {
  final String initials;
  final String? imageUrl;
  final double radius;

  const AppAvatar({
    super.key,
    required this.initials,
    this.imageUrl,
    this.radius = 22,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<BitoColorScheme>()!;

    if (imageUrl != null && imageUrl!.isNotEmpty) {
      return CircleAvatar(
        radius: radius,
        backgroundImage: NetworkImage(imageUrl!),
        backgroundColor: colors.surface2,
      );
    }

    return CircleAvatar(
      radius: radius,
      backgroundColor: colors.signal.withOpacity(0.1),
      child: Text(
        initials.toUpperCase(),
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: radius * 0.45,
          color: colors.signal,
        ),
      ),
    );
  }
}

