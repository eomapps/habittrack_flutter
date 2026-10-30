import 'package:timezone/timezone.dart' as tz;

/// How many days ahead daily notifications are scheduled. The window is
/// refreshed every time the app opens or a habit is toggled.
const int notificationDaysAhead = 14;

/// A single one-off notification to schedule.
class PlannedNotification {
  const PlannedNotification({
    required this.id,
    required this.scheduledDate,
    required this.isCongratulations,
  });

  /// Notification id, equal to the number of days from today (0..13).
  final int id;
  final tz.TZDateTime scheduledDate;

  /// True only for today's notification when every habit is already done.
  final bool isCongratulations;
}

/// Plans one notification per day for the next [notificationDaysAhead] days.
///
/// Each day defaults to the reminder. Only today's notification can be the
/// congratulations message, so it can never carry over to the next day.
/// Days whose notification time has already passed are skipped.
List<PlannedNotification> planNotifications({
  required tz.TZDateTime now,
  required int hour,
  required int minute,
  required bool allDoneToday,
}) {
  final planned = <PlannedNotification>[];
  for (var day = 0; day < notificationDaysAhead; day++) {
    // Build from calendar fields (not now + Duration) so the time of day
    // stays the same across daylight saving changes.
    final scheduledDate = tz.TZDateTime(
      now.location,
      now.year,
      now.month,
      now.day + day,
      hour,
      minute,
    );
    if (scheduledDate.isBefore(now)) continue;
    planned.add(
      PlannedNotification(
        id: day,
        scheduledDate: scheduledDate,
        isCongratulations: day == 0 && allDoneToday,
      ),
    );
  }
  return planned;
}
