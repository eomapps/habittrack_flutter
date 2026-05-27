import 'package:flutter/material.dart';

class AppColorTokens extends ThemeExtension<AppColorTokens> {
  final Color bg;
  final Color card;
  final Color cardBg;
  final Color text;
  final Color border;
  final Color label;
  final Color muted;
  final Color emptyStateIconBg;

  const AppColorTokens({
    required this.bg,
    required this.card,
    required this.cardBg,
    required this.text,
    required this.border,
    required this.label,
    required this.muted,
    required this.emptyStateIconBg,
  });

  const AppColorTokens.light()
    : this(
        bg: const Color(0xFFF0EFF8),
        card: const Color(0xFFFFFFFF),
        cardBg: const Color(0xFFF7F6FC),
        text: const Color(0xFF18172B),
        border: const Color(0x1A534AB7),
        label: const Color(0x59534AB7),
        muted: const Color(0xFF7A789A),
        emptyStateIconBg: const Color(0x337F77DD),
      );

  const AppColorTokens.dark()
    : this(
        bg: const Color(0xFF0A091A),
        card: const Color(0xFF1E1D2E),
        cardBg: const Color(0xFF252438),
        text: const Color(0xFFF0EFF8),
        border: const Color(0x12FFFFFF),
        label: const Color(0x47FFFFFF),
        muted: const Color(0xFF7A789A),
        emptyStateIconBg: const Color(0x337F77DD),
      );

  @override
  ThemeExtension<AppColorTokens> copyWith({
    Color? bg,
    Color? card,
    Color? cardBg,
    Color? text,
    Color? border,
    Color? label,
    Color? muted,
    Color? emptyStateIconBg,
  }) {
    return AppColorTokens(
      bg: bg ?? this.bg,
      card: card ?? this.card,
      cardBg: cardBg ?? this.cardBg,
      text: text ?? this.text,
      border: border ?? this.border,
      label: label ?? this.label,
      muted: muted ?? this.muted,
      emptyStateIconBg: emptyStateIconBg ?? this.emptyStateIconBg,
    );
  }

  @override
  ThemeExtension<AppColorTokens> lerp(
    covariant ThemeExtension<AppColorTokens>? other,
    double t,
  ) {
    if (other is! AppColorTokens) return this;

    final o = other;
    return AppColorTokens(
      bg: Color.lerp(bg, o.bg, t)!,
      card: Color.lerp(card, o.card, t)!,
      cardBg: Color.lerp(cardBg, o.cardBg, t)!,
      text: Color.lerp(text, o.text, t)!,
      border: Color.lerp(border, o.border, t)!,
      label: Color.lerp(label, o.label, t)!,
      muted: Color.lerp(muted, o.muted, t)!,
      emptyStateIconBg: Color.lerp(emptyStateIconBg, o.emptyStateIconBg, t)!,
    );
  }
}
