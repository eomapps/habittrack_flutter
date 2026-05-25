import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:habittrack/core/constants/app_strings.dart';
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
      child: MaterialApp(home: Scaffold(body: TodayScreen())),
    );
  }

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
