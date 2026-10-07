import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:habittrack/core/constants/app_strings.dart';
import 'package:habittrack/core/constants/app_theme.dart';
import 'package:habittrack/core/utils/ht_utils.dart';
import 'package:habittrack/data/models/habit.dart';
import 'package:habittrack/viewmodels/habit_viewmodel.dart';
import 'package:habittrack/views/home/widgets/today.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

import '../../../data/viewmodels/habit_viewmodel_test.mocks.dart';

void main() {
  late MockHabitRepository mockHabitRepository;
  late HabitViewModel habitViewModel;

  setUp(() {
    mockHabitRepository = MockHabitRepository();
    habitViewModel = HabitViewModel(mockHabitRepository);
    when(mockHabitRepository.getAll()).thenAnswer((_) async {
      return [];
    });
  });

  Widget buildTodayScreen() {
    return ChangeNotifierProvider<HabitViewModel>.value(
      value: habitViewModel,
      child: MaterialApp(
        theme: AppTheme.light,
        home: Scaffold(body: TodayScreen()),
      ),
    );
  }

  group('timeUntilNextMidnight', () {
    test('keeps the leftover seconds before midnight', () {
      final now = DateTime(2026, 10, 6, 23, 59, 20);
      final wait = timeUntilNextMidnight(now);

      expect(wait, const Duration(seconds: 40));
      expect(now.add(wait), DateTime(2026, 10, 7));
    });

    test('from earlier in the day lands on the next midnight', () {
      final now = DateTime(2026, 10, 6, 20, 29);
      expect(now.add(timeUntilNextMidnight(now)), DateTime(2026, 10, 7));
    });
  });

  group('TodayScreen date display', () {
    testWidgets('displays today\'s date', (WidgetTester tester) async {
      String dateToday = HTUtils.getFormattedDate(DateTime.now());
      await tester.pumpWidget(buildTodayScreen());
      await tester.pumpAndSettle();
      final textToday = find.byKey(const Key('date-today-text'));
      final indicator = tester.widget<Text>(textToday);
      expect(indicator.data, dateToday);
    });
  });

  group('TodayScreen habit filtering', () {
    testWidgets('empty list shows placeholder', (WidgetTester tester) async {
      await tester.pumpWidget(buildTodayScreen());
      await tester.pumpAndSettle();
      expect(find.text(AppStrings.noHabitsYet), findsOneWidget);
    });

    testWidgets('habit with no check today appears in NOT DONE section', (
      WidgetTester tester,
    ) async {
      Habit notDoneHabit = Habit(title: 'Exercise', colorHex: '#FF0000');
      when(mockHabitRepository.getAll()).thenAnswer((_) async {
        return [notDoneHabit];
      });
      await tester.pumpWidget(buildTodayScreen());
      await tester.pumpAndSettle();
      expect(find.text(AppStrings.notDone), findsOneWidget);
      expect(find.text(notDoneHabit.title), findsOneWidget);
      expect(find.text(AppStrings.doneToday), findsNothing);
    });

    testWidgets('habit checked today appears in DONE TODAY section', (
      WidgetTester tester,
    ) async {
      Habit doneHabit = Habit(
        title: 'Read',
        colorHex: '#0000FF',
        lastCheckedDate: DateTime.now().toIso8601String().substring(0, 10),
      );
      when(mockHabitRepository.getAll()).thenAnswer((_) async {
        return [doneHabit];
      });
      await tester.pumpWidget(buildTodayScreen());
      await tester.pumpAndSettle();
      expect(find.text(AppStrings.notDone), findsNothing);
      expect(find.text(AppStrings.doneToday), findsOneWidget);
      expect(find.text(doneHabit.title), findsOneWidget);
    });

    testWidgets('a yesterday check is switched off when Today loads', (
      WidgetTester tester,
    ) async {
      final yesterday = DateTime.now()
          .subtract(const Duration(days: 1))
          .toIso8601String()
          .substring(0, 10);
      final habit = Habit(
        id: 1,
        title: 'Exercise',
        colorHex: '#FF0000',
        streakCount: 3,
        lastCheckedDate: yesterday,
        toggledOn: true,
      );
      when(mockHabitRepository.getAll()).thenAnswer((_) async => [habit]);

      await tester.pumpWidget(buildTodayScreen());
      await tester.pumpAndSettle();

      final saved =
          verify(mockHabitRepository.update(captureAny)).captured.single
              as Habit;
      expect(saved.toggledOn, false);
      expect(saved.lastCheckedDate, yesterday);
      expect(find.text(AppStrings.notDone), findsOneWidget);
      expect(find.text(AppStrings.doneToday), findsNothing);
    });

    testWidgets('habits split correctly across both sections', (
      WidgetTester tester,
    ) async {
      Habit notDoneHabit = Habit(title: 'Exercise', colorHex: '#FF0000');
      Habit doneHabit = Habit(
        title: 'Read',
        colorHex: '#0000FF',
        lastCheckedDate: DateTime.now().toIso8601String().substring(0, 10),
      );
      when(mockHabitRepository.getAll()).thenAnswer((_) async {
        return [notDoneHabit, doneHabit];
      });
      await tester.pumpWidget(buildTodayScreen());
      await tester.pumpAndSettle();
      expect(find.text(AppStrings.notDone), findsOneWidget);
      expect(find.text(notDoneHabit.title), findsOneWidget);
      expect(find.text(AppStrings.doneToday), findsOneWidget);
      expect(find.text(doneHabit.title), findsOneWidget);
    });
  });
}
