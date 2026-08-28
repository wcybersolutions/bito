// lib/shared/components/inputs/digital_time_picker.dart
import 'package:flutter/material.dart';
import 'package:bito/theme/theme_extensions.dart';

class DigitalTimePicker extends StatefulWidget {
  final TimeOfDay initialTime;
  final ValueChanged<TimeOfDay> onTimeSelected;

  const DigitalTimePicker({
    super.key,
    required this.initialTime,
    required this.onTimeSelected,
  });

  static Future<TimeOfDay?> show(
    BuildContext context, {
    required TimeOfDay initialTime,
  }) async {
    TimeOfDay? selected;
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      enableDrag: true,
      barrierColor: Colors.black.withValues(alpha: 0.5),
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(ctx).viewInsets.bottom,
          ),
          child: DigitalTimePicker(
            initialTime: initialTime,
            onTimeSelected: (time) {
              selected = time;
            },
          ),
        );
      },
    );
    return selected;
  }

  @override
  State<DigitalTimePicker> createState() => _DigitalTimePickerState();
}

class _DigitalTimePickerState extends State<DigitalTimePicker> {
  late TextEditingController _hourController;
  late TextEditingController _minuteController;
  late bool _isAM;
  late FocusNode _hourFocusNode;
  late FocusNode _minuteFocusNode;

  @override
  void initState() {
    super.initState();
    final hour = widget.initialTime.hour;
    final minute = widget.initialTime.minute;
    _isAM = hour < 12;
    _hourController = TextEditingController(
      text: _formatHour(hour),
    );
    _minuteController = TextEditingController(
      text: minute.toString().padLeft(2, '0'),
    );
    _hourFocusNode = FocusNode();
    _minuteFocusNode = FocusNode();
  }

  @override
  void dispose() {
    _hourController.dispose();
    _minuteController.dispose();
    _hourFocusNode.dispose();
    _minuteFocusNode.dispose();
    super.dispose();
  }

  String _formatHour(int hour) {
    final displayHour = hour == 0 ? 12 : (hour > 12 ? hour - 12 : hour);
    return displayHour.toString();
  }

  int _parseHour(String value) {
    final hour = int.tryParse(value) ?? 1;
    if (hour < 1) return 1;
    if (hour > 12) return 12;
    return hour;
  }

  int _parseMinute(String value) {
    final minute = int.tryParse(value) ?? 0;
    if (minute < 0) return 0;
    if (minute > 59) return 59;
    return minute;
  }

  int _getHour24() {
    final hour12 = _parseHour(_hourController.text);
    if (_isAM) {
      return hour12 == 12 ? 0 : hour12;
    } else {
      return hour12 == 12 ? 12 : hour12 + 12;
    }
  }

  void _updateTime() {
    final hour24 = _getHour24();
    final minute = _parseMinute(_minuteController.text);
    widget.onTimeSelected(TimeOfDay(hour: hour24, minute: minute));
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<BitoColorScheme>()!;
    final screenWidth = MediaQuery.of(context).size.width;

    return Center(
      child: Container(
        width: screenWidth * 0.85,
        constraints: const BoxConstraints(maxWidth: 320),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: colors.line, width: 0.5),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar
            Container(
              width: 36,
              height: 4,
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: colors.line2,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: Text(
                    'Cancel',
                    style: TextStyle(
                      fontSize: 13,
                      color: colors.ink3,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Text(
                  'Select Time',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: colors.ink,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    _updateTime();
                    Navigator.pop(context);
                  },
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: Text(
                    'Done',
                    style: TextStyle(
                      fontSize: 13,
                      color: colors.signal,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Digital time display with typeable text inputs
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Hour input
                SizedBox(
                  width: 56,
                  child: TextField(
                    controller: _hourController,
                    focusNode: _hourFocusNode,
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.number,
                    maxLength: 2,
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w700,
                      color: colors.ink,
                    ),
                    decoration: InputDecoration(
                      counterText: '',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: colors.line),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: colors.signal, width: 2),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                    ),
                    onChanged: (value) {
                      if (value.isNotEmpty) {
                        final hour = int.tryParse(value);
                        if (hour != null && hour > 12) {
                          _hourController.text = '12';
                          _hourController.selection = TextSelection.fromPosition(
                            TextPosition(offset: _hourController.text.length),
                          );
                        }
                      }
                    },
                    onSubmitted: (_) {
                      _minuteFocusNode.requestFocus();
                    },
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  ':',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w700,
                    color: colors.ink,
                  ),
                ),
                const SizedBox(width: 4),
                // Minute input
                SizedBox(
                  width: 56,
                  child: TextField(
                    controller: _minuteController,
                    focusNode: _minuteFocusNode,
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.number,
                    maxLength: 2,
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w700,
                      color: colors.ink,
                    ),
                    decoration: InputDecoration(
                      counterText: '',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: colors.line),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: colors.signal, width: 2),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                    ),
                    onChanged: (value) {
                      if (value.isNotEmpty) {
                        final minute = int.tryParse(value);
                        if (minute != null && minute > 59) {
                          _minuteController.text = '59';
                          _minuteController.selection = TextSelection.fromPosition(
                            TextPosition(offset: _minuteController.text.length),
                          );
                        }
                      }
                    },
                  ),
                ),
                const SizedBox(width: 20),
                // AM/PM toggle
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildAMPMButton(
                      label: 'AM',
                      isSelected: _isAM,
                      onTap: () {
                        setState(() {
                          _isAM = true;
                          _updateTime();
                        });
                      },
                    ),
                    const SizedBox(height: 4),
                    _buildAMPMButton(
                      label: 'PM',
                      isSelected: !_isAM,
                      onTap: () {
                        setState(() {
                          _isAM = false;
                          _updateTime();
                        });
                      },
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildAMPMButton({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    final colors = Theme.of(context).extension<BitoColorScheme>()!;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44,
        height: 28,
        decoration: BoxDecoration(
          color: isSelected ? colors.signal : colors.surface2,
          borderRadius: BorderRadius.circular(6),
          border: isSelected
              ? null
              : Border.all(color: colors.line2, width: 0.5),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: isSelected ? colors.signalInk : colors.ink3,
            ),
          ),
        ),
      ),
    );
  }
}
