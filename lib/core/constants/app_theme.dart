import 'package:habittrack/core/constants/app_color_tokens.dart';
import 'package:habittrack/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get light => ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: Color(0xFFF0EFF8),
    primaryColor: AppColors.purple,
    colorScheme: ColorScheme.light(
      primary: AppColors.purple,
      surface: Colors.white,
      onSurface: Color(0xFF18172B),
    ),
    fontFamily: 'Nunito',
    listTileTheme: ListTileThemeData(tileColor: Colors.transparent),
    appBarTheme: AppBarTheme(
      backgroundColor: Color(0xFFF0EFF8),
      elevation: 0,
      surfaceTintColor: Colors.transparent,
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: Colors.white,
      selectedItemColor: AppColors.purple,
      unselectedItemColor: Color(0xFF7A789A),
    ),
    extensions: [AppColorTokens.light()],
  );

  static ThemeData get dark => ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: Color(0xFF0A091A),
    primaryColor: AppColors.purple,
    colorScheme: ColorScheme.dark(
      primary: AppColors.purple,
      surface: Color(0xFF1E1D2E),
      onSurface: Color(0xFFF0EFF8),
    ),
    fontFamily: 'Nunito',
    listTileTheme: ListTileThemeData(tileColor: Colors.transparent),
    appBarTheme: AppBarTheme(
      backgroundColor: Color(0xFF0A091A),
      elevation: 0,
      surfaceTintColor: Colors.transparent,
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: Color(0xFF1E1D2E),
      selectedItemColor: AppColors.purple,
      unselectedItemColor: Color(0xFF8884AA),
    ),
    extensions: [AppColorTokens.dark()],
  );
}
