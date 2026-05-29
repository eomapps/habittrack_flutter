import 'dart:async';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:habittrack/core/constants/app_strings.dart';
import 'package:shared_preferences/shared_preferences.dart';

final StreamController<void> notificationTapStream =
    StreamController<void>.broadcast();

@pragma('vm:entry-point')
void notificationTapBackground(
  NotificationResponse notificationResponse,
) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setBool(AppStrings.notificationTapped, true);
}

void notificationTapForeground(NotificationResponse notificationResponse) {
  notificationTapStream.add(null);
}
