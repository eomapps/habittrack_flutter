import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:habittrack/core/constants/app_strings.dart';
import 'package:habittrack/core/constants/app_theme.dart';
import 'package:habittrack/core/notifications/notification_service.dart';
import 'package:habittrack/data/database/database_helper.dart';
import 'package:habittrack/data/models/habit.dart';
import 'package:habittrack/data/repositories/habit_repository.dart';
import 'package:habittrack/viewmodels/habit_viewmodel.dart';
import 'package:habittrack/viewmodels/settings_viewmodel.dart';
import 'package:habittrack/views/home/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

final habitProvider = StateNotifierProvider<HabitViewModel, List<Habit>>(
  (ref) => HabitViewModel(HabitRepository(DatabaseHelper.instance)),
);

final settingsProvider = NotifierProvider<SettingsViewmodel, SettingsState>(
  () => SettingsViewmodel(),
);

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

  SettingsViewmodel settingsViewmodel = SettingsViewmodel();
  try {
    await settingsViewmodel.init();
  } catch (e) {
    debugPrint('settingsViewmodel.init failed: $e');
  }

  try {
    await NotificationsService.instance.initNotificationsService(
      settingsViewmodel,
    );
  } catch (e) {
    debugPrint('initNotificationsService failed $e');
  }

  await minSplash; // no-op if init already took ≥ 500ms
  FlutterNativeSplash.remove();

  runApp(
    ProviderScope(
      overrides: [settingsProvider.overrideWith(() => settingsViewmodel)],
      child: const MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
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
