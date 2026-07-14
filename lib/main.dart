import 'dart:async';

import 'package:habittrack/core/constants/app_strings.dart';
import 'package:habittrack/core/constants/app_theme.dart';
import 'package:habittrack/core/notifications/notification_service.dart';
import 'package:habittrack/data/database/database_helper.dart';
import 'package:habittrack/data/repositories/habit_repository.dart';
import 'package:habittrack/viewmodels/habit_viewmodel.dart';
import 'package:habittrack/viewmodels/settings_viewmodel.dart';
import 'package:habittrack/views/home/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  // Start timer immediately — runs in background while init work happens
  const kMinSplashDuration = Duration(milliseconds: 500);
  final minSplash = Future.delayed(kMinSplashDuration);

  try {
    await DatabaseHelper.instance.database;
  } catch (e) {
    debugPrint('initialize db failed: $e');
  }

  HabitRepository habitRepository = HabitRepository(DatabaseHelper.instance);
  HabitViewModel habitViewModel = HabitViewModel(habitRepository);
  await habitViewModel.getAllHabits();

  SettingsViewmodel settingsViewmodel = SettingsViewmodel();
  try {
    await settingsViewmodel.init();
  } catch (e) {
    debugPrint('settingsViewmodel.init failed: $e');
  }

  try {
    await NotificationsService.instance.initNotificationsService(
      settingsViewmodel,
      allDoneToday: habitViewModel.allHabitsDoneToday,
    );
  } catch (e) {
    debugPrint('initNotificationsService failed $e');
  }

  await minSplash; // no-op if init already took ≥ 500ms
  FlutterNativeSplash.remove();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: habitViewModel),
        ChangeNotifierProvider.value(value: settingsViewmodel),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsViewmodel>();
    return MaterialApp(
      title: AppStrings.appTitle,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: settings.themeDark ? ThemeMode.dark : ThemeMode.light,
      home: const HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
