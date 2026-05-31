import 'package:flutter/material.dart';
import 'package:habittrack/core/constants/app_strings.dart';
import 'package:habittrack/core/notifications/notification_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsViewmodel extends ChangeNotifier {
  late SharedPreferences _prefs;

  Future<void> init() async {
    try {
      _prefs = await SharedPreferences.getInstance();
    } catch (e) {
      debugPrint('SettingViewmodel init failed $e');
      rethrow;
    }
  }

  Future<void> setNotifications(bool notificationsEnabled) async {
    try {
      await _prefs.setBool(
        AppStrings.settingsNotificationsEnabled,
        notificationsEnabled,
      );
    } catch (e) {
      debugPrint('setNotifications value failed $e');
    }
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
    try {
      await _prefs.setInt(AppStrings.settingsNotificationHour, hours);
      await _prefs.setInt(AppStrings.settingsNotificationMins, mins);
      if (notificationsEnabled) {
        await NotificationsService.instance.cancelNotification(0);
        await NotificationsService.instance.scheduleNotification();
      }
    } catch (e) {
      debugPrint('setNotificationTime failed $e');
    }
    notifyListeners();
  }

  TimeOfDay get notificationTime {
    final hours = _prefs.getInt(AppStrings.settingsNotificationHour) ?? 9;
    final mins = _prefs.getInt(AppStrings.settingsNotificationMins) ?? 0;
    return TimeOfDay(hour: hours, minute: mins);
  }

  Future<void> setThemeDark(bool useThemeDark) async {
    try {
      await _prefs.setBool(AppStrings.settingsAppThemeDark, useThemeDark);
    } catch (e) {
      debugPrint('setThemeDark failed $e');
    }
    notifyListeners();
  }

  bool get themeDark =>
      _prefs.getBool(AppStrings.settingsAppThemeDark) ?? false;
}
