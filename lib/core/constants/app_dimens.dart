import 'package:flutter/material.dart';

class AppDimens {
  AppDimens._();

  static const double radiusCard = 12;
  static const double radiusButton = 12;
  static const double checkSize = 24;
  static const double radiusScreenScaffold = 24;
  static const double radiusProgressRow = 12;
  static const double radiusFormInput = 10;
  static const BorderRadius radiusBottomSheet = BorderRadius.vertical(
    top: Radius.circular(20),
  );
  static const radiusEmptyStateIconBox = 16;

  // padding & gaps
  static const paddingTopBar = EdgeInsets.symmetric(
    horizontal: 6,
    vertical: 16,
  );

  static const paddingDateRow = EdgeInsets.symmetric(
    horizontal: 16,
    vertical: 8,
  );

  static const paddingSectionLabel = EdgeInsets.symmetric(
    horizontal: 16,
    vertical: 4,
  );

  static const paddingHabitCardMargin = EdgeInsets.symmetric(
    horizontal: 12,
    vertical: 10,
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

  static const paddingRowGap = EdgeInsets.symmetric(
    horizontal: 10,
    vertical: 10,
  );
}
