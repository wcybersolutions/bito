// lib/shared/components/app_bar/app_header.dart
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:bito/theme/theme_extensions.dart';
import 'bito_logo.dart';

class AppHeader extends StatelessWidget {
  final String eyebrow;
  final String title;
  final String date;
  final VoidCallback? onNotificationTap;
  final VoidCallback? onProfileTap;
  final String? profileInitials;

  const AppHeader({
    super.key,
    required this.eyebrow,
    required this.title,
    required this.date,
    this.onNotificationTap,
    this.onProfileTap,
    this.profileInitials = 'MP',
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<BitoColorScheme>()!;
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Use BitoLogo widget
              const BitoLogo(size: 28),
              Row(
                children: [
                  IconButton(
                    onPressed: onNotificationTap ?? () {},
                    icon: Icon(
                      PhosphorIcons.bell(),
                      size: 24,
                      color: colors.ink2,
                    ),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    style: IconButton.styleFrom(
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                  ),
                  const SizedBox(width: 12),
                  GestureDetector(
                    onTap: onProfileTap ?? () {},
                    child: Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: colors.signal2),
                        color: colors.signal.withOpacity(0.1),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.19),
                            offset: const Offset(0, 2),
                            blurRadius: 7,
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          profileInitials ?? 'MP',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: colors.signal,
                            letterSpacing: 0.9,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            eyebrow.toUpperCase(),
            style: TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.w700,
              color: colors.ink3,
              letterSpacing: 0.5,
              fontFamily: 'SpaceMono',
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: textTheme.headlineMedium?.copyWith(
                  color: colors.ink,
                  letterSpacing: -1,
                ),
              ),
              Text(
                date,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: colors.ink3,
                  letterSpacing: 0.5,
                  fontFamily: 'SpaceMono',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

