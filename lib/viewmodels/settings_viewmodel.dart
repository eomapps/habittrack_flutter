import 'package:flutter/material.dart';
import 'package:habittrack/core/constants/app_strings.dart';
import 'package:habittrack/core/notifications/notification_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsViewmodel extends ChangeNotifier {
  late SharedPreferences _prefs;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  Future<void> setNotifications(bool notificationsEnabled) async {
    await _prefs.setBool(
      AppStrings.settingsNotificationsEnabled,
      notificationsEnabled,
    );
    if (notificationsEnabled) {
      await NotificationsService.instance.scheduleNotification();
    } else {
      await NotificationsService.instance.cancelNotification(0);
    }
    notifyListeners();
  }

  bool get notificationsEnabled =>
      _prefs.getBool(AppStrings.settingsNotificationsEnabled) ?? true;

  Future<void> setNotificationTime(int hours, int mins) async {
    await _prefs.setInt(AppStrings.settingsNotificationHour, hours);
    await _prefs.setInt(AppStrings.settingsNotificationMins, mins);
    if (notificationsEnabled) {
      await NotificationsService.instance.cancelNotification(0);
      await NotificationsService.instance.scheduleNotification();
    }
    notifyListeners();
  }

  TimeOfDay get notificationTime {
    final hours = _prefs.getInt(AppStrings.settingsNotificationHour) ?? 9;
    final mins = _prefs.getInt(AppStrings.settingsNotificationMins) ?? 0;
    return TimeOfDay(hour: hours, minute: mins);
  }

  Future<void> setThemeDark(bool useThemeDark) async {
    await _prefs.setBool(AppStrings.settingsAppThemeDark, useThemeDark);
    notifyListeners();
  }

  bool get themeDark =>
      _prefs.getBool(AppStrings.settingsAppThemeDark) ?? false;
}
