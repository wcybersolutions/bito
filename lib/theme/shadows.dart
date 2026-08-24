import 'package:flutter/material.dart';

class BitoShadows {
  const BitoShadows._();

  static const List<BoxShadow> sm = [
    BoxShadow(
      blurRadius: 6,
      offset: Offset(0, 2),
      color: Color(0x14000000),
    ),
  ];

  static const List<BoxShadow> md = [
    BoxShadow(
      blurRadius: 12,
      offset: Offset(0, 4),
      color: Color(0x18000000),
    ),
  ];

  static const List<BoxShadow> lg = [
    BoxShadow(
      blurRadius: 24,
      offset: Offset(0, 8),
      color: Color(0x22000000),
    ),
  ];
}


