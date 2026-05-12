import 'package:eomappshabit_track/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

class AppTextStyles {
  AppTextStyles._();

  // ── App bar ──────────────────────────────────────────
  static const appBarTitle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w700,
    color: AppColors.text,
  );

  // ── Home screen ──────────────────────────────────────
  static const dateRow = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w600,
    color: AppColors.muted,
    letterSpacing: 0.04 * 11,
  );

  static final sectionLabel = TextStyle(
    fontSize: 9,
    fontWeight: FontWeight.w700,
    color: AppColors.label,
    letterSpacing: 0.12 * 9,
  );

  static const habitName = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w600,
    color: AppColors.text,
  );

  static const habitStreak = TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.w500,
    color: AppColors.muted,
  );

  // ── Bottom nav ───────────────────────────────────────
  static const navLabel = TextStyle(
    fontSize: 9,
    fontWeight: FontWeight.w600,
    color: AppColors.muted,
  );

  static const navLabelActive = TextStyle(
    fontSize: 9,
    fontWeight: FontWeight.w600,
    color: AppColors.purple,
  );

  // ── Add habit sheet ──────────────────────────────────
  static const sheetTitle = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w700,
    color: AppColors.text,
  );

  static const formLabel = TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.w700,
    color: AppColors.muted,
    letterSpacing: 0.08 * 10,
  );

  static const formInput = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w400,
    color: AppColors.text,
    fontFamily: 'Nunito',
  );

  static const saveButton = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w700,
    color: Colors.white,
    fontFamily: 'Nunito',
  );

  // ── Progress screen ──────────────────────────────────
  static const progressName = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    color: AppColors.text,
  );

  static const progressDayCount = TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.w700,
    color: AppColors.muted,
    fontFamily: 'monospace',
  );

  // ── Splash screen ────────────────────────────────────
  static const splashTitle = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w700,
    color: Colors.white,
  );

  static final splashSubtitle = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: Colors.white.withOpacity(0.60),
    letterSpacing: 0.04 * 12,
  );

  // ── Empty state ──────────────────────────────────────
  static const emptyStateTitle = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w700,
    color: AppColors.text,
  );

  static const emptyStateSub = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w500,
    color: AppColors.muted,
    height: 1.6,
  );
}
