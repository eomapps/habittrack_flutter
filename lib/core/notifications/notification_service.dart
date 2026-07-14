import 'dart:io';

import 'package:flutter/rendering.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:habittrack/core/constants/app_strings.dart';
import 'package:habittrack/core/notifications/notification_handler.dart';
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
          await cancelNotification(0);
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
          await cancelNotification(0);
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
      final notificationTime = viewmodel!.notificationTime;
      var scheduledDate = tz.TZDateTime(
        tz.local,
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day,
        notificationTime.hour,
        notificationTime.minute,
      );
      final isToday = !scheduledDate.isBefore(tz.TZDateTime.now(tz.local));
      if (!isToday) {
        scheduledDate = scheduledDate.add(const Duration(days: 1));
      }
      final useCongratsMessage = allDoneToday && isToday;
      await flutterLocalNotificationsPlugin.zonedSchedule(
        id: 0,
        title: useCongratsMessage
            ? AppStrings.notificationCongratulationsTitle
            : AppStrings.notificationTitle,
        body: useCongratsMessage
            ? AppStrings.notificationCongratulationsBody
            : AppStrings.notificationBody,
        scheduledDate: scheduledDate,
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
        matchDateTimeComponents: DateTimeComponents.time,
      );
    } catch (e) {
      debugPrint('scheduleNotification failed: $e');
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
