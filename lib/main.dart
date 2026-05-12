import 'package:eomappshabit_track/core/constants/app_theme.dart';
import 'package:eomappshabit_track/data/database/database_helper.dart';
import 'package:eomappshabit_track/views/home/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await DatabaseHelper.instance.database; // init db
  await Future.delayed(const Duration(seconds: 2)); // so user can see branding
  FlutterNativeSplash.remove();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HabitTrack',
      theme: AppTheme.light,
      home: const HomeScreen(),
    );
  }
}
