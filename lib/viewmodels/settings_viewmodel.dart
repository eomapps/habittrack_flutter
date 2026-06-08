import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habittrack/core/constants/app_strings.dart';
import 'package:habittrack/core/notifications/notification_service.dart';
import 'package:habittrack/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsState {
  final bool notificationsEnabled;
  final TimeOfDay notificationTime;
  final bool themeDark;
  final bool notificationsBlockedByOS;

  const SettingsState({
    required this.notificationsEnabled,
    required this.notificationTime,
    required this.themeDark,
    required this.notificationsBlockedByOS,
  });
}

class SettingsViewmodel extends Notifier<SettingsState> {
  late SharedPreferences _prefs;

  @override
  SettingsState build() {
    return SettingsState(
      notificationsEnabled: notificationsEnabled,
      notificationTime: notificationTime,
      themeDark: themeDark,
      notificationsBlockedByOS: false,
    );
  }

  Future<void> init() async {
    try {
      _prefs = await SharedPreferences.getInstance();
    } catch (e) {
      debugPrint('SettingViewmodel init failed $e');
      rethrow;
    }
  }

  Future<bool?> canEnableNotifications() async {
    return NotificationsService.instance.hasPermission();
  }

  void setNotificationsBlockedByOS(bool blocked) {
    state = SettingsState(
      notificationsEnabled: state.notificationsEnabled,
      notificationTime: state.notificationTime,
      themeDark: themeDark,
      notificationsBlockedByOS: blocked,
    );
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
      await NotificationsService.instance.scheduleNotification(
        allDoneToday: ref.read(habitProvider.notifier).allHabitsDoneToday,
      );
    } else {
      await NotificationsService.instance.cancelNotification(0);
    }
    state = SettingsState(
      notificationsEnabled: notificationsEnabled,
      notificationTime: notificationTime,
      themeDark: themeDark,
      notificationsBlockedByOS: state.notificationsBlockedByOS,
    );
  }

  bool get notificationsEnabled =>
      _prefs.getBool(AppStrings.settingsNotificationsEnabled) ?? true;

  bool get hasNotificationsPreferenceBeenSet =>
      _prefs.getBool(AppStrings.settingsNotificationsEnabled) != null;

  Future<void> setNotificationTime(int hours, int mins) async {
    try {
      await _prefs.setInt(AppStrings.settingsNotificationHour, hours);
      await _prefs.setInt(AppStrings.settingsNotificationMins, mins);
      if (notificationsEnabled) {
        await NotificationsService.instance.cancelNotification(0);
        await NotificationsService.instance.scheduleNotification(
          allDoneToday: ref.read(habitProvider.notifier).allHabitsDoneToday,
        );
      }
    } catch (e) {
      debugPrint('setNotificationTime failed $e');
    }
    state = SettingsState(
      notificationsEnabled: notificationsEnabled,
      notificationTime: notificationTime,
      themeDark: themeDark,
      notificationsBlockedByOS: state.notificationsBlockedByOS,
    );
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
    state = SettingsState(
      notificationsEnabled: state.notificationsEnabled,
      notificationTime: state.notificationTime,
      themeDark: useThemeDark,
      notificationsBlockedByOS: state.notificationsBlockedByOS,
    );
  }

  bool get themeDark =>
      _prefs.getBool(AppStrings.settingsAppThemeDark) ?? false;
}
