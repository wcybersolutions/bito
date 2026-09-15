// lib/shared/components/app_bar/app_header.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:bito/theme/theme_extensions.dart';
import 'bito_logo.dart';

class AppHeader extends StatelessWidget {
  final String eyebrow;
  final String title;
  final String date;
  final VoidCallback? onNotificationTap;
  final VoidCallback? onThemeTap;
  final VoidCallback? onProfileTap;
  final String? profileImageUrl;
  final String? profileName;
  final String? profileInitials;

  const AppHeader({
    super.key,
    required this.eyebrow,
    required this.title,
    required this.date,
    this.onNotificationTap,
    this.onThemeTap,
    this.onProfileTap,
    this.profileImageUrl,
    this.profileName,
    this.profileInitials,
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
              Row(
                children: [
                  const BitoLogo(size: 28),
                  const SizedBox(width: 8),
                  Text(
                    'bito',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: colors.ink,
                      letterSpacing: -0.5,
                    ),
                  ),
                ],
              ),
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
                  const SizedBox(width: 8),
                  IconButton(
                    onPressed: onThemeTap ?? () {},
                    icon: Icon(
                      PhosphorIcons.palette(),
                      size: 22,
                      color: colors.ink2,
                    ),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    style: IconButton.styleFrom(
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: onProfileTap ?? () => context.push('/settings'),
                    child: Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: colors.signal2),
                        color: colors.signal.withValues(alpha: 0.1),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.19),
                            offset: const Offset(0, 2),
                            blurRadius: 7,
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(11),
                        child: _buildProfileAvatar(colors),
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

  Widget _buildProfileAvatar(BitoColorScheme colors) {
    // Determine the initials to use as a fallback
    final String resolvedInitials = profileInitials ??
        (profileName != null && profileName!.isNotEmpty
            ? _getNameInitials(profileName!)
            : 'JK');

    // If there's an image URL, show the image
    if (profileImageUrl != null && profileImageUrl!.isNotEmpty) {
      return Image.network(
        profileImageUrl!,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) =>
            _buildInitials(colors, resolvedInitials),
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Center(
            child: SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: colors.signal,
              ),
            ),
          );
        },
      );
    }

    // Fallback to initials if no image URL is provided
    return _buildInitials(colors, resolvedInitials);
  }

  String _getNameInitials(String name) {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return parts[0][0].toUpperCase();
  }

  Widget _buildInitials(BitoColorScheme colors, String initials) {
    return Center(
      child: Text(
        initials,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w700,
          color: colors.signal,
          letterSpacing: 0.9,
        ),
      ),
    );
  }
}

