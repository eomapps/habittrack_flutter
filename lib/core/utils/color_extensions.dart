import 'package:flutter/material.dart';

extension AppColorExtensions on Color {
  String toHex() =>
      '#${toARGB32().toRadixString(16).substring(2).toUpperCase()}';
}

Color colorFromHex(String hex) {
  final cleaned = hex
      .replaceFirst('#', '')
      .replaceFirst('0xFF', '')
      .replaceFirst('0xff', '');
  return Color(int.parse('FF$cleaned', radix: 16));
}
