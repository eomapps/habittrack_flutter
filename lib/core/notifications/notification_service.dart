import 'dart:io';

import 'package:flutter/rendering.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:habittrack/core/constants/app_strings.dart';
import 'package:habittrack/core/notifications/notification_handler.dart';
import 'package:habittrack/core/notifications/notification_plan.dart';
import 'package:habittrack/viewmodels/settings_viewmodel.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz;

class NotificationsService {
  NotificationsService._internal();
  static final NotificationsService instance = NotificationsService._internal();
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  SettingsViewmodel? viewmodel;
  bool allDoneToday = false;

  Future<void> _configureTimeZone() async {
    tz.initializeTimeZones();
    final TimezoneInfo timeZoneInfo = await FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(timeZoneInfo.identifier));
  }

  Future<void> initNotificationsService(
    SettingsViewmodel settingsViewmodel, {
    bool allDoneToday = false,
  }) async {
    viewmodel = settingsViewmodel;
    this.allDoneToday = allDoneToday;
    await _configureTimeZone();
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings(AppStrings.androidDefaultIcon);
    const DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings(
          requestSoundPermission: false,
          requestBadgePermission: false,
          requestAlertPermission: false,
          defaultPresentAlert: true,
        );

    final InitializationSettings initializationSettings =
        InitializationSettings(
          android: initializationSettingsAndroid,
          iOS: initializationSettingsDarwin,
        );
    await flutterLocalNotificationsPlugin.initialize(
      settings: initializationSettings,
      onDidReceiveNotificationResponse: notificationTapForeground,
      onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
    );
    await _requestPermissions();
  }

  Future<void> _requestPermissions() async {
    if (Platform.isIOS) {
      bool? grantedNotificationPermission =
          await flutterLocalNotificationsPlugin
              .resolvePlatformSpecificImplementation<
                IOSFlutterLocalNotificationsPlugin
              >()
              ?.requestPermissions(alert: true, badge: true, sound: true);

      if (grantedNotificationPermission == true &&
          viewmodel!.notificationsEnabled) {
        await scheduleNotification();
      } else if (grantedNotificationPermission == false) {
        if (!viewmodel!.hasNotificationsPreferenceBeenSet) {
          await viewmodel!.setNotifications(false);
        } else {
          await cancelAllNotifications();
        }
        viewmodel!.setNotificationsBlockedByOS(true);
      }
    } else if (Platform.isAndroid) {
      final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
          flutterLocalNotificationsPlugin
              .resolvePlatformSpecificImplementation<
                AndroidFlutterLocalNotificationsPlugin
              >();
      final bool? grantedNotificationPermission = await androidImplementation
          ?.requestNotificationsPermission();
      if (grantedNotificationPermission == true &&
          viewmodel!.notificationsEnabled) {
        await scheduleNotification();
      } else if (grantedNotificationPermission == false) {
        if (!viewmodel!.hasNotificationsPreferenceBeenSet) {
          await viewmodel!.setNotifications(false);
        } else {
          await cancelAllNotifications();
        }
        viewmodel!.setNotificationsBlockedByOS(true);
      }
    }
  }

  Future<bool?> hasPermission() async {
    bool? hasPermissions;
    if (Platform.isIOS) {
      final permissions = await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin
          >()
          ?.checkPermissions();
      hasPermissions = permissions?.isEnabled;
    } else if (Platform.isAndroid) {
      final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
          flutterLocalNotificationsPlugin
              .resolvePlatformSpecificImplementation<
                AndroidFlutterLocalNotificationsPlugin
              >();
      if (androidImplementation != null) {
        hasPermissions = await androidImplementation.areNotificationsEnabled();
      }
    }

    return hasPermissions;
  }

  Future<void> scheduleNotification() async {
    if (viewmodel == null) {
      debugPrint('scheduleNotification called before initNotificationsService');
      return;
    }
    try {
      // Clears the whole window, including the old repeating notification
      // (id 0) left over from earlier versions of the app.
      await cancelAllNotifications();
      final notificationTime = viewmodel!.notificationTime;
      final planned = planNotifications(
        now: tz.TZDateTime.now(tz.local),
        hour: notificationTime.hour,
        minute: notificationTime.minute,
        allDoneToday: allDoneToday,
      );
      for (final notification in planned) {
        await flutterLocalNotificationsPlugin.zonedSchedule(
          id: notification.id,
          title: notification.isCongratulations
              ? AppStrings.notificationCongratulationsTitle
              : AppStrings.notificationTitle,
          body: notification.isCongratulations
              ? AppStrings.notificationCongratulationsBody
              : AppStrings.notificationBody,
          scheduledDate: notification.scheduledDate,
          notificationDetails: const NotificationDetails(
            iOS: DarwinNotificationDetails(),
            android: AndroidNotificationDetails(
              AppStrings.channelId,
              AppStrings.channelName,
              channelDescription: AppStrings.channelDescription,
              priority: Priority.high,
              importance: Importance.high,
              fullScreenIntent: true,
            ),
          ),
          androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        );
      }
    } catch (e) {
      debugPrint('scheduleNotification failed: $e');
    }
  }

  Future<void> cancelAllNotifications() async {
    for (var id = 0; id < notificationDaysAhead; id++) {
      await cancelNotification(id);
    }
  }

  Future<void> cancelNotification(int id) async {
    try {
      await flutterLocalNotificationsPlugin.cancel(id: id);
    } catch (e) {
      debugPrint('cancelNotification failed: $e');
    }
  }
}
