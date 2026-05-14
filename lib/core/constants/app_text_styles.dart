import 'package:habittrack/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

class AppTextStyles {
  AppTextStyles._();

  // ── App bar ──────────────────────────────────────────
  static const TextStyle appBarTitle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w700,
    color: AppColors.text,
  );

  // ── Home screen ──────────────────────────────────────
  static const TextStyle dateRow = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w600,
    color: AppColors.muted,
    letterSpacing: 0.04 * 11,
  );

  static final TextStyle sectionLabel = TextStyle(
    fontSize: 9,
    fontWeight: FontWeight.w700,
    color: AppColors.label,
    letterSpacing: 0.12 * 9,
  );

  static const TextStyle habitName = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w600,
    color: AppColors.text,
  );

  static const TextStyle habitStreak = TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.w500,
    color: AppColors.muted,
  );

  // ── Bottom nav ───────────────────────────────────────
  static const TextStyle navLabel = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w600,
    color: AppColors.muted,
  );

  static const TextStyle navLabelActive = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w600,
    color: AppColors.purple,
  );

  // ── Add habit sheet ──────────────────────────────────
  static const TextStyle sheetTitle = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w700,
    color: AppColors.text,
  );

  static const TextStyle formLabel = TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.w700,
    color: AppColors.muted,
    letterSpacing: 0.08 * 10,
  );

  static const TextStyle formInput = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w400,
    color: AppColors.text,
    fontFamily: 'Nunito',
  );

  static const TextStyle saveButton = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w700,
    color: Colors.white,
    fontFamily: 'Nunito',
  );

  // ── Progress screen ──────────────────────────────────
  static const TextStyle progressName = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    color: AppColors.text,
  );

  static const TextStyle progressDayCount = TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.w700,
    color: AppColors.muted,
    fontFamily: 'Courier New',
  );

  // ── Splash screen ────────────────────────────────────
  static const TextStyle splashTitle = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w700,
    color: Colors.white,
  );

  static final TextStyle splashSubtitle = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: Colors.white.withOpacity(0.60),
    letterSpacing: 0.04 * 12,
  );

  // ── Empty state ──────────────────────────────────────
  static const TextStyle emptyStateTitle = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w700,
    color: AppColors.text,
  );

  static const TextStyle emptyStateSub = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w500,
    color: AppColors.muted,
    height: 1.6,
  );
}
