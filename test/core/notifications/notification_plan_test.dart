// test/core/notifications/notification_plan_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:habittrack/core/notifications/notification_plan.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

void main() {
  late tz.Location newYork;

  setUpAll(() {
    tz.initializeTimeZones();
    newYork = tz.getLocation('America/New_York');
  });

  // Reminder time used throughout: 9:00 AM.
  List<PlannedNotification> plan({
    required tz.TZDateTime now,
    required bool allDoneToday,
  }) {
    return planNotifications(
      now: now,
      hour: 9,
      minute: 0,
      allDoneToday: allDoneToday,
    );
  }

  group('planNotifications', () {
    test('before reminder time and not done: reminder every day', () {
      final now = tz.TZDateTime(newYork, 2026, 10, 20, 8);
      final planned = plan(now: now, allDoneToday: false);

      expect(planned.length, notificationDaysAhead);
      expect(planned.every((n) => !n.isCongratulations), isTrue);
      expect(
        planned.first.scheduledDate,
        tz.TZDateTime(newYork, 2026, 10, 20, 9),
      );
    });

    test('before reminder time and all done: congratulations today only', () {
      final now = tz.TZDateTime(newYork, 2026, 10, 20, 8);
      final planned = plan(now: now, allDoneToday: true);

      expect(planned.first.id, 0);
      expect(planned.first.isCongratulations, isTrue);
      expect(planned.skip(1).every((n) => !n.isCongratulations), isTrue);
    });

    test('after reminder time: today is skipped, tomorrow is a reminder', () {
      final now = tz.TZDateTime(newYork, 2026, 10, 20, 10);
      final planned = plan(now: now, allDoneToday: true);

      expect(planned.length, notificationDaysAhead - 1);
      expect(planned.first.id, 1);
      expect(planned.first.isCongratulations, isFalse);
      expect(
        planned.first.scheduledDate,
        tz.TZDateTime(newYork, 2026, 10, 21, 9),
      );
    });

    test('ids are unique and within the cancellable range', () {
      final now = tz.TZDateTime(newYork, 2026, 10, 20, 8);
      final ids = plan(now: now, allDoneToday: false).map((n) => n.id);

      expect(ids.toSet().length, ids.length);
      expect(ids.every((id) => id >= 0 && id < notificationDaysAhead), isTrue);
    });

    test('keeps the same time of day across a daylight saving change', () {
      // Daylight saving ends in New York on Nov 1, 2026.
      final now = tz.TZDateTime(newYork, 2026, 10, 30, 8);
      final planned = plan(now: now, allDoneToday: false);

      for (final n in planned) {
        expect(n.scheduledDate.hour, 9);
        expect(n.scheduledDate.minute, 0);
      }
    });
  });
}
