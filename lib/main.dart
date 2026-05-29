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

  await DatabaseHelper.instance.database; // init db

  await Future.delayed(
    const Duration(milliseconds: 500),
  ); // brief delay for branding

  FlutterNativeSplash.remove();

  HabitRepository habitRepository = HabitRepository(DatabaseHelper.instance);
  SettingsViewmodel settingsViewmodel = SettingsViewmodel();
  await settingsViewmodel.init();
  await NotificationsService.instance.initNotificationsService(
    settingsViewmodel,
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => HabitViewModel(habitRepository)),
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
