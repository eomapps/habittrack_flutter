import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:habittrack/core/utils/ht_utils.dart';
import 'package:habittrack/data/models/habit.dart';
import 'package:habittrack/views/home/widgets/progress_card.dart';

void main() {
  late Habit testHabit;
  late int testStreak;

  String makeLastCheckedDate(int daysPassed) {
    return DateTime.now()
        .subtract(Duration(days: daysPassed))
        .toIso8601String()
        .substring(0, 10);
  }

  Widget buildProgressCard() {
    return MaterialApp(
      home: Scaffold(
        body: ProgressCard(habit: testHabit, maxStreak: testStreak),
      ),
    );
  }

  setUp(() {
    testHabit = Habit(
      title: HTUtils.getInSentenceCase('morning run'),
      colorHex: '#FF5733',
      lastCheckedDate: makeLastCheckedDate(1),
      streakCount: 3,
    );
    testStreak = 6;
  });

  testWidgets('shows habit title', (WidgetTester tester) async {
    await tester.pumpWidget(buildProgressCard());
    expect(find.text(testHabit.title), findsOneWidget);
  });

  group('LinearProgressIndicator', () {
    testWidgets('shows streakCount / maxStreak as the value', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(buildProgressCard());
      final progressFinder = find.byType(LinearProgressIndicator);
      final indicator = tester.widget<LinearProgressIndicator>(progressFinder);
      expect(
        indicator.value,
        closeTo(testHabit.streakCount / testStreak, 0.001),
      );
    });

    testWidgets('shows the correct color of the Habit', (
      WidgetTester tester,
    ) async {
      const Color c = Color(0xFFFF5733);
      await tester.pumpWidget(buildProgressCard());
      final progressFinder = find.byType(LinearProgressIndicator);
      final indicator = tester.widget<LinearProgressIndicator>(progressFinder);
      expect(indicator.color, c);
    });
  });

  group('computedStreak', () {
    testWidgets('shows number of days in streak', (WidgetTester tester) async {
      await tester.pumpWidget(buildProgressCard());
      expect(find.text('${testHabit.computedStreak}d'), findsOneWidget);
    });

    testWidgets('shows as 0d if streak is broken (2+ days ago)', (
      WidgetTester tester,
    ) async {
      testHabit = Habit(
        title: 'morning run',
        colorHex: '#FF5733',
        lastCheckedDate: makeLastCheckedDate(2),
        streakCount: 3,
      );
      await tester.pumpWidget(buildProgressCard());
      expect(find.text('0d'), findsOneWidget);
    });

    testWidgets('shows streakCount when checked today', (
      WidgetTester tester,
    ) async {
      testHabit = Habit(
        title: 'morning run',
        colorHex: '#FF5733',
        lastCheckedDate: makeLastCheckedDate(0),
        streakCount: 3,
      );
      await tester.pumpWidget(buildProgressCard());
      expect(find.text('${testHabit.computedStreak}d'), findsOneWidget);
    });

    testWidgets('shows 0d when Habit was not checked', (
      WidgetTester tester,
    ) async {
      testHabit = Habit(
        title: 'morning run',
        colorHex: '#FF5733',
        lastCheckedDate: null,
        streakCount: 3,
      );
      await tester.pumpWidget(buildProgressCard());
      expect(find.text('0d'), findsOneWidget);
    });
  });
}
