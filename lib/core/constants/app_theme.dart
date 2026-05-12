import 'package:eomappshabit_track/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get light => ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.light(
      primary: AppColors.brand,
      onPrimary: AppColors.buttonText,
    ),
    textTheme: TextTheme(
      headlineLarge: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
      bodyLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      bodyMedium: TextStyle(fontSize: 14, color: AppColors.mutedText),
      bodySmall: TextStyle(fontSize: 10),
    ),
    buttonTheme: ButtonThemeData(buttonColor: AppColors.brand),
  );
}
