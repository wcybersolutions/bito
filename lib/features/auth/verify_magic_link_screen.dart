// lib/features/auth/verify_magic_link_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../data/providers/auth_provider.dart';
import '../../theme/theme_extensions.dart';

class VerifyMagicLinkScreen extends ConsumerStatefulWidget {
  final String token;

  const VerifyMagicLinkScreen({
    super.key,
    required this.token,
  });

  @override
  ConsumerState<VerifyMagicLinkScreen> createState() => _VerifyMagicLinkScreenState();
}

class _VerifyMagicLinkScreenState extends ConsumerState<VerifyMagicLinkScreen> {
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _verifyToken();
  }

  Future<void> _verifyToken() async {
    final notifier = ref.read(authNotifierProvider.notifier);
    await notifier.verifyMagicLink(widget.token);

    if (mounted) {
      final authState = ref.read(authNotifierProvider);
      if (authState.hasValue && authState.value != null) {
        // ✅ SUCCESS - User is authenticated, navigate to daily wisdom
        context.go('/daily-wisdom');
      } else if (authState.hasError) {
        setState(() {
          _isLoading = false;
          _error = authState.error.toString();
        });
      } else {
        setState(() {
          _isLoading = false;
          _error = 'Verification failed. Please try again.';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Scaffold(
      backgroundColor: colors.bg,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (_isLoading) ...[
                  const CircularProgressIndicator(
                    color: Colors.purple,
                    strokeWidth: 3,
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Verifying your email...',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: colors.ink,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Please wait while we confirm your identity',
                    style: TextStyle(
                      fontSize: 14,
                      color: colors.ink2,
                    ),
                  ),
                ] else if (_error != null) ...[
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: colors.error,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Verification Failed',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: colors.error,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _error!,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: colors.ink2,
                    ),
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: () => context.go('/sign-in'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colors.signal,
                        foregroundColor: colors.signalInk,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Back to Sign In',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}