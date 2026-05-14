import 'package:habittrack/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

class AppDimens {
  AppDimens._();

  // radius sizes
  static const double radiusCard = 12;
  static const double radiusButton = 12;
  static const double radiusScreenScaffold = 24;
  static const double radiusProgressRow = 12;
  static const double radiusFormInput = 10;
  static const double radiusSheetHandle = 2;
  static const double radiusProgressBar = 3;

  static const BorderRadius radiusBottomSheet = BorderRadius.vertical(
    top: Radius.circular(20),
  );

  static const double radiusEmptyStateIconBox = 16;

  // padding & gaps
  static const paddingTopBar = EdgeInsets.symmetric(
    horizontal: 6,
    vertical: 16,
  );

  static const paddingDateRow = EdgeInsets.fromLTRB(16, 0, 16, 8);

  static const paddingSectionLabel = EdgeInsets.symmetric(
    horizontal: 16,
    vertical: 4,
  );

  static const paddingHabitCardMargin = EdgeInsets.symmetric(
    horizontal: 10,
    vertical: 3,
  );

  static const paddingHabitCard = EdgeInsets.symmetric(
    horizontal: 12,
    vertical: 10,
  );

  static const paddingBottomNav = EdgeInsets.only(top: 2, bottom: 8);

  static const paddingSheetHandleTitle = EdgeInsets.only(top: 20, bottom: 14);

  static const EdgeInsets paddingSheet = EdgeInsets.only(
    left: 16,
    right: 16,
    bottom: 20,
  );

  static const paddingProgressBody = EdgeInsets.symmetric(
    horizontal: 12,
    vertical: 10,
  );

  static const paddingProgressRowPad = EdgeInsets.symmetric(
    horizontal: 12,
    vertical: 10,
  );

  static const double progressRowGap = 10;
  static const double habitCardGap = 10;

  // component sizes
  static const double fabSize = 30;
  static const double checkCircleSize = 24;
  static const double colorDotSize = 9;
  static const double colorSwatchSize = 26;
  static const double sheetHandleWidth = 36;
  static const double sheetHandleHeight = 4;
  static const double progressBarHeight = 5;
  static const double emptyStateIconBoxSize = 52;
  static const double splashIconBoxSize = 60;
  static const double splashLoaderWidth = 32;
  static const double splashLoaderHeight = 3;
  static const double navDotSize = 4;

  // borders & strokes
  static final BorderSide checkCircleBorder = BorderSide(
    color: AppColors.border,
    width: 1.5,
  );

  static const BorderSide splashIconBorder = BorderSide(
    color: Color(0x40FFFFFF), // rgba(255,255,255,0.25)
    width: 1,
  );

  // shadows
  static const BoxShadow fabShadow = BoxShadow(
    color: Color(0x4C534AB7), // rgba(83,74,183,0.30)
    blurRadius: 12,
    offset: Offset(0, 4),
  );

  static const BoxShadow checkDoneShadow = BoxShadow(
    color: Color(0x401D9E75), // rgba(29,158,117,0.25)
    blurRadius: 8,
  );

  static const double colorSwatchRingInset = 3;
  static const double colorSwatchRingWidth = 2;
}
