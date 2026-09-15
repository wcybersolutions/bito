import 'package:flutter/material.dart';

import '../../../theme/radius.dart';

class AppDropdown<T> extends StatelessWidget {
  final T? value;
  final List<T> items;
  final ValueChanged<T?> onChanged;
  final String Function(T) labelBuilder;

  const AppDropdown({
    super.key,
    required this.value,
    required this.items,
    required this.onChanged,
    required this.labelBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<T>(
      initialValue: value,
      onChanged: onChanged,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(BitoRadius.lg),
        ),
      ),
      items: items
          .map(
            (item) => DropdownMenuItem<T>(
              value: item,
              child: Text(labelBuilder(item)),
            ),
          )
          .toList(),
    );
  }
}
