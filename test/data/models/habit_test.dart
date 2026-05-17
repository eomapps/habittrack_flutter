// test/data/models/habit_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:habittrack/data/models/habit.dart';

void main() {
  Habit makeHabit(int streakCount, String? lastCheckDate) {
    return Habit(
      title: 'Drink water',
      colorHex: '#FF0000',
      streakCount: streakCount,
      lastCheckedDate: lastCheckDate,
    );
  }

  String makeLastCheckedDate(int daysPassed) {
    return DateTime.now()
        .subtract(Duration(days: daysPassed))
        .toIso8601String()
        .substring(0, 10);
  }

  test('new habit has zero streak by default', () {
    final habit = Habit(title: 'Drink water', colorHex: '#FF0000');
    expect(habit.streakCount, 0);
  });

  group('Habit.computedStreak', () {
    test('returns 0 when never checked', () {
      final habit = makeHabit(0, null);

      expect(habit.computedStreak, 0);
    });

    test('returns streakCount when checked today', () {
      final today = makeLastCheckedDate(0);

      final habit = makeHabit(5, today);
      expect(habit.computedStreak, 5);
    });

    test('returns streakCount when checked yesterday', () {
      final yesterday = makeLastCheckedDate(1);

      final habit = makeHabit(5, yesterday);
      expect(habit.computedStreak, 5);
    });

    test('returns 0 when last checked 4 days ago', () {
      final fourDaysAgo = makeLastCheckedDate(4);

      final habit = makeHabit(1, fourDaysAgo);
      expect(habit.computedStreak, 0);
    });
  });
}
