import 'package:flutter/material.dart';
import 'package:habittrack/core/constants/app_strings.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsViewmodel extends ChangeNotifier {
  late SharedPreferences _prefs;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    notifyListeners();
  }

  Future<void> setNotifications(bool notificationsEnabled) async {
    await _prefs.setBool(
      AppStrings.settingsNotificationsEnabled,
      notificationsEnabled,
    );
    notifyListeners();
  }

  bool getNotificationsEnabled() {
    return _prefs.getBool(AppStrings.settingsNotificationsEnabled) ?? true;
  }

  Future<void> setNotificationTime(int hours, int mins) async {
    await _prefs.setInt(AppStrings.settingsNotificationHour, hours);
    await _prefs.setInt(AppStrings.settingsNotificationMins, mins);
    notifyListeners();
  }

  TimeOfDay getNotificationTime() {
    final hours = _prefs.getInt(AppStrings.settingsNotificationHour) ?? 9;
    final mins = _prefs.getInt(AppStrings.settingsNotificationMins) ?? 00;
    return TimeOfDay(hour: hours, minute: mins);
  }

  Future<void> setThemeDark(bool useThemeLight) async {
    await _prefs.setBool(AppStrings.settingsAppThemeDark, useThemeLight);
    notifyListeners();
  }

  bool getThemeDark() {
    return _prefs.getBool(AppStrings.settingsAppThemeDark) ?? false;
  }
}
