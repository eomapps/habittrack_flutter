import 'package:habittrack/core/constants/app_color_tokens.dart';
import 'package:flutter/material.dart';
import 'package:habittrack/core/constants/app_colors.dart';

class AppTextStyles {
  AppTextStyles._();

  // ── App bar ──────────────────────────────────────────
  static TextStyle appBarTitle(BuildContext context) => TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w700,
    color: Theme.of(context).extension<AppColorTokens>()!.text,
  );

  // ── Home screen ──────────────────────────────────────
  static TextStyle dateRow(BuildContext context) => TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w600,
    color: Theme.of(context).extension<AppColorTokens>()!.muted,
    letterSpacing: 0.04 * 11,
  );

  static TextStyle sectionLabel(BuildContext context) => TextStyle(
    fontSize: 9,
    fontWeight: FontWeight.w700,
    color: Theme.of(context).extension<AppColorTokens>()!.label,
    letterSpacing: 0.12 * 9,
  );

  static TextStyle habitName(BuildContext context) => TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w600,
    color: Theme.of(context).extension<AppColorTokens>()!.text,
  );

  static TextStyle habitStreak(BuildContext context) => TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.w500,
    color: Theme.of(context).extension<AppColorTokens>()!.muted,
  );

  static TextStyle progressStreak(BuildContext context) => TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.w700,
    color: Theme.of(context).extension<AppColorTokens>()!.muted,
    fontFamily: 'FiraCode',
  );

  // ── Bottom nav ───────────────────────────────────────
  static TextStyle navLabel(BuildContext context) => TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w600,
    color: Theme.of(context).extension<AppColorTokens>()!.muted,
  );

  static final TextStyle navLabelActive = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w600,
    color: AppColors.purple,
  );

  // ── Add habit sheet ──────────────────────────────────
  static TextStyle sheetTitle(BuildContext context) => TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w700,
    color: Theme.of(context).extension<AppColorTokens>()!.text,
  );

  static TextStyle formLabel(BuildContext context) => TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.w700,
    color: Theme.of(context).extension<AppColorTokens>()!.muted,
    letterSpacing: 0.08 * 10,
  );

  static TextStyle formInput(BuildContext context) => TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w400,
    color: Theme.of(context).extension<AppColorTokens>()!.text,
    fontFamily: 'Nunito',
  );

  static final TextStyle saveButton = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w700,
    color: Colors.white,
    fontFamily: 'Nunito',
  );

  // ── Progress screen ──────────────────────────────────
  static TextStyle progressName(BuildContext context) => TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    color: Theme.of(context).extension<AppColorTokens>()!.text,
  );

  static TextStyle progressDayCount(BuildContext context) => TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.w700,
    color: Theme.of(context).extension<AppColorTokens>()!.muted,
    fontFamily: 'Courier New',
  );

  // ── Empty state ──────────────────────────────────────
  static TextStyle emptyStateTitle(BuildContext context) => TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w700,
    color: Theme.of(context).extension<AppColorTokens>()!.text,
  );

  static TextStyle emptyStateSub(BuildContext context) => TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w500,
    color: Theme.of(context).extension<AppColorTokens>()!.muted,
    height: 1.6,
  );
}
