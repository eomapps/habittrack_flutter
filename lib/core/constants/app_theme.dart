import 'package:habittrack/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get light => ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: AppColors.bg,
    primaryColor: AppColors.purple,
    colorScheme: ColorScheme.light(
      primary: AppColors.purple,
      surface: Colors.white,
      onSurface: AppColors.text,
    ),
    fontFamily: 'Nunito',
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.bg,
      elevation: 0,
      surfaceTintColor: Colors.transparent,
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: Colors.white,
      selectedItemColor: AppColors.purple,
      unselectedItemColor: AppColors.muted,
    ),
  );
}
