// lib/shared/components/buttons/action_button.dart
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:bito/theme/theme_extensions.dart';

enum ButtonType { primary, secondary, outline, cancel }

class ActionButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final ButtonType type;
  final bool isLoading;
  final bool expanded;
  final Widget? icon;

  const ActionButton({
    super.key,
    required this.text,
    this.onPressed,
    this.type = ButtonType.primary,
    this.isLoading = false,
    this.expanded = false,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<BitoColorScheme>()!;

    Widget button;

    switch (type) {
      case ButtonType.primary:
        button = ElevatedButton(
          onPressed: isLoading ? null : onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: colors.signal,
            foregroundColor: Colors.black, // Changed to black
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
            minimumSize: const Size(120, 48),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(11),
            ),
            elevation: 0,
          ),
          child: isLoading
              ? SizedBox(
            height: 20,
            width: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: Colors.black, // Changed to black
            ),
          )
              : Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                icon!,
                const SizedBox(width: 8),
              ],
              Text(
                text,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: Colors.black, // Changed to black
                  letterSpacing: 0.5,
                  fontFamily: 'SpaceMono',
                ),
              ),
            ],
          ),
        );
        break;

      case ButtonType.secondary:
        button = OutlinedButton(
          onPressed: onPressed,
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
            minimumSize: const Size(120, 48),
            side: BorderSide(color: colors.line),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(11),
            ),
            foregroundColor: colors.ink,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                icon!,
                const SizedBox(width: 8),
              ],
              Text(
                text,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: colors.ink,
                  letterSpacing: 0.5,
                  fontFamily: 'SpaceMono',
                ),
              ),
            ],
          ),
        );
        break;

      case ButtonType.outline:
        button = OutlinedButton(
          onPressed: onPressed,
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
            minimumSize: const Size(120, 48),
            side: BorderSide(color: colors.line),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(11),
            ),
            foregroundColor: colors.ink2,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                icon!,
                const SizedBox(width: 8),
              ],
              Text(
                text,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: colors.ink2,
                  letterSpacing: 0.5,
                  fontFamily: 'SpaceMono',
                ),
              ),
            ],
          ),
        );
        break;

      case ButtonType.cancel:
        button = OutlinedButton(
          onPressed: onPressed,
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
            minimumSize: const Size(120, 48),
            side: BorderSide(color: colors.line),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(11),
            ),
            foregroundColor: colors.ink2,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                icon!,
                const SizedBox(width: 8),
              ],
              Text(
                text,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: colors.ink2,
                  letterSpacing: 0.5,
                  fontFamily: 'SpaceMono',
                ),
              ),
            ],
          ),
        );
        break;
    }

    return expanded
        ? SizedBox(
      width: double.infinity,
      child: button,
    )
        : button;
  }
}