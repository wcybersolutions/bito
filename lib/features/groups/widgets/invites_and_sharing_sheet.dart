// lib/features/groups/widgets/invites_and_sharing_sheet.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:bito/theme/theme_extensions.dart';
import 'package:bito/data/groups/group.dart';

class InvitesAndSharingSheet extends StatefulWidget {
  final Group group;

  const InvitesAndSharingSheet({
    super.key,
    required this.group,
  });

  static Future<void> show(BuildContext context, Group group) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      enableDrag: true,
      builder: (context) => InvitesAndSharingSheet(group: group),
    );
  }

  @override
  State<InvitesAndSharingSheet> createState() => _InvitesAndSharingSheetState();
}

class _InvitesAndSharingSheetState extends State<InvitesAndSharingSheet> {
  final TextEditingController _emailController = TextEditingController();
  late String _inviteCode;
  bool _copied = false;
  bool _sent = false;

  @override
  void initState() {
    super.initState();
    _inviteCode = widget.group.inviteCode ?? 'STQBRM';
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _regenerateCode() {
    const chars = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';
    final random = DateTime.now().millisecondsSinceEpoch;
    final buffer = StringBuffer();
    for (int i = 0; i < 6; i++) {
      buffer.write(chars[(random ~/ (i + 1) * 7) % chars.length]);
    }
    setState(() {
      _inviteCode = buffer.toString();
    });
  }

  void _copyLink() {
    Clipboard.setData(ClipboardData(text: 'https://bito.app/join/$_inviteCode'));
    setState(() => _copied = true);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Invite link copied to clipboard!'),
        duration: Duration(seconds: 2),
      ),
    );
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) setState(() => _copied = false);
    });
  }

  void _sendInvite() {
    final email = _emailController.text.trim();
    if (email.isNotEmpty && email.contains('@')) {
      setState(() => _sent = true);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Invite sent to $email!'),
          duration: const Duration(seconds: 2),
        ),
      );
      _emailController.clear();
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) setState(() => _sent = false);
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a valid email address'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<BitoColorScheme>()!;
    final textTheme = Theme.of(context).textTheme;

    // Format code with spaces between characters like "S T Q B R M"
    final spacedCode = _inviteCode.split('').join(' ');

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          border: Border.all(color: colors.line),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Handle Bar
            Center(
              child: Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: colors.line2,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Header: Invites & Sharing + Close X
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Invites & Sharing',
                  style: textTheme.titleLarge?.copyWith(
                    color: colors.ink,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Icon(
                    PhosphorIcons.x(),
                    size: 18,
                    color: colors.ink2,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),

            // Inner Card Container
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: colors.bg,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: colors.line),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // INVITE PEOPLE Label
                  Text(
                    'INVITE PEOPLE',
                    style: TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.w700,
                      color: colors.ink3,
                      letterSpacing: 1.0,
                      fontFamily: 'SpaceMono',
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Code Display Box
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                    decoration: BoxDecoration(
                      color: colors.surface,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: colors.line),
                    ),
                    child: Text(
                      spacedCode,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 2,
                        color: colors.signal2,
                        fontFamily: 'SpaceMono',
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Buttons Row: [ COPY LINK ]  [ QR ]  [ REFRESH ]
                  Row(
                    children: [
                      // COPY LINK Button
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: _copyLink,
                          icon: Icon(
                            _copied
                                ? PhosphorIcons.check()
                                : PhosphorIcons.copy(),
                            size: 14,
                            color: _copied ? colors.signal2 : colors.ink,
                          ),
                          label: Text(
                            _copied ? 'COPIED!' : 'COPY LINK',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: _copied ? colors.signal2 : colors.ink,
                              letterSpacing: 0.6,
                              fontFamily: 'SpaceMono',
                            ),
                          ),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            side: BorderSide(color: colors.line),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),

                      // QR Button
                      Container(
                        width: 42,
                        height: 42,
                        decoration: BoxDecoration(
                          color: colors.surface,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: colors.line),
                        ),
                        child: IconButton(
                          onPressed: () {
                            // Show QR Code dialog / toast
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('QR Code scanner / view'),
                                duration: Duration(seconds: 1),
                              ),
                            );
                          },
                          icon: Icon(
                            PhosphorIcons.qrCode(),
                            size: 18,
                            color: colors.ink2,
                          ),
                          padding: EdgeInsets.zero,
                        ),
                      ),
                      const SizedBox(width: 8),

                      // REFRESH / REGENERATE Button
                      Container(
                        width: 42,
                        height: 42,
                        decoration: BoxDecoration(
                          color: colors.surface,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: colors.line),
                        ),
                        child: IconButton(
                          onPressed: _regenerateCode,
                          icon: Icon(
                            PhosphorIcons.arrowsClockwise(),
                            size: 18,
                            color: colors.ink2,
                          ),
                          padding: EdgeInsets.zero,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),

                  // Email Input Field
                  Container(
                    decoration: BoxDecoration(
                      color: colors.surface,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: colors.line),
                    ),
                    child: TextField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      style: TextStyle(color: colors.ink, fontSize: 13),
                      decoration: InputDecoration(
                        hintText: 'email@example.com',
                        hintStyle: TextStyle(
                          color: colors.ink3,
                          fontSize: 13,
                        ),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 12,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // SEND INVITE Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _sendInvite,
                      icon: Icon(
                        _sent
                            ? PhosphorIcons.check()
                            : PhosphorIcons.envelope(),
                        size: 15,
                        color: Colors.black,
                      ),
                      label: Text(
                        _sent ? 'INVITE SENT!' : 'SEND INVITE',
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                          color: Colors.black,
                          letterSpacing: 0.6,
                          fontFamily: 'SpaceMono',
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colors.signal2,
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(vertical: 13),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 0,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
