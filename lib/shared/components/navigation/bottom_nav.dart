// lib/shared/components/navigation/bottom_nav.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:bito/theme/theme_extensions.dart';
import 'package:bito/shared/components/create_sheet.dart';

class BottomNav extends StatelessWidget {
  const BottomNav({super.key});

  int _currentIndex(BuildContext context) {
    final path = GoRouterState.of(context).uri.path;

    if (path.startsWith('/analytics')) return 1;
    if (path.startsWith('/groups')) return 2;

    if (path.startsWith('/more') ||
        path.startsWith('/settings') ||
        path.startsWith('/journal') ||
        path.startsWith('/profile') ||
        path.startsWith('/notifications') ||
        path.startsWith('/compass') ||
        path.startsWith('/challenges')) {
      return 3;
    }

    return 0;
  }

  void _showCreateSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return const CreateSheet();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<BitoColorScheme>()!;
    final selected = _currentIndex(context);

    Widget item({
      required int index,
      required PhosphorIconData icon,
      required String label,
      required String route,
    }) {
      final active = selected == index;

      return Expanded(
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => context.go(route),
          child: SizedBox(
            height: 54,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  icon,
                  size: 22,
                  color: active ? colors.signal2 : colors.ink3,
                ),
                const SizedBox(height: 2),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.0,
                    color: active ? colors.signal2 : colors.ink3,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return BottomAppBar(
      height: 64,
      color: colors.surface,
      elevation: 0,
      padding: EdgeInsets.zero,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          border: Border(top: BorderSide(color: colors.line, width: 1.5)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            item(
              index: 0,
              icon: PhosphorIcons.gridFour(),
              label: 'HOME',
              route: '/',
            ),
            item(
              index: 1,
              icon: PhosphorIcons.chartBar(),
              label: 'ANALYTICS',
              route: '/analytics',
            ),
            Expanded(
              child: Center(
                child: Material(
                  color: colors.signal2,
                  shape: const CircleBorder(),
                  child: InkWell(
                    customBorder: const CircleBorder(),
                    onTap: () => _showCreateSheet(context),
                    child: const SizedBox(
                      width: 48,
                      height: 48,
                      child: Icon(Icons.add, size: 24, color: Colors.black),
                    ),
                  ),
                ),
              ),
            ),
            item(
              index: 2,
              icon: PhosphorIcons.users(),
              label: 'GROUPS',
              route: '/groups',
            ),
            item(
              index: 3,
              icon: PhosphorIcons.dotsThreeOutline(),
              label: 'MORE',
              route: '/more',
            ),
          ],
        ),
      ),
    );
  }
}
