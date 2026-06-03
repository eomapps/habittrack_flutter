import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:habittrack/core/constants/app_strings.dart';
import 'package:habittrack/core/constants/app_theme.dart';
import 'package:habittrack/data/models/habit.dart';
import 'package:habittrack/viewmodels/habit_viewmodel.dart';
import 'package:habittrack/views/home/widgets/progress.dart';
import 'package:habittrack/views/home/widgets/progress_card.dart';
import 'package:habittrack/views/home/widgets/progress_placeholder.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

import '../../data/viewmodels/habit_viewmodel_test.mocks.dart';

void main() {
  late MockHabitRepository mockHabitRepository;
  late HabitViewModel habitViewModel;

  String makeLastCheckedDate(int daysPassed) {
    return DateTime.now()
        .subtract(Duration(days: daysPassed))
        .toIso8601String()
        .substring(0, 10);
  }

  Habit makeHabit(int streakCount, int daysPassed) {
    return Habit(
      title: 'Morning Run',
      colorHex: '#FF0000',
      streakCount: streakCount,
      lastCheckedDate: makeLastCheckedDate(daysPassed),
    );
  }

  setUp(() {
    mockHabitRepository = MockHabitRepository();
    habitViewModel = HabitViewModel(mockHabitRepository);
    when(mockHabitRepository.getAll()).thenAnswer((_) async => []);
  });

  Widget buildProgressScreen() {
    return ChangeNotifierProvider<HabitViewModel>.value(
      value: habitViewModel,
      child: MaterialApp(
        theme: AppTheme.light,
        home: Scaffold(body: ProgressScreen()),
      ),
    );
  }

  group('ProgressPlaceholder', () {
    testWidgets('shows placeholder when there are no habits at all', (
      WidgetTester tester,
    ) async {
      await habitViewModel.getAllHabits();
      await tester.pumpWidget(buildProgressScreen());
      await tester.pumpAndSettle();
      expect(find.byType(ProgressPlaceholder), findsOneWidget);
    });

    testWidgets(
      'shows placeholder when all habits have a broken or zero streak',
      (WidgetTester tester) async {
        final brokenHabit = makeHabit(5, 3);
        when(
          mockHabitRepository.getAll(),
        ).thenAnswer((_) async => [brokenHabit]);
        await habitViewModel.getAllHabits();
        await tester.pumpWidget(buildProgressScreen());
        await tester.pumpAndSettle();
        expect(find.byType(ProgressPlaceholder), findsOneWidget);
      },
    );

    testWidgets('placeholder shows "No progress yet" title', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(buildProgressScreen());
      await tester.pumpAndSettle();
      expect(find.text(AppStrings.noProgressYet), findsOneWidget);
    });

    testWidgets('placeholder shows add-progress subtitle', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(buildProgressScreen());
      expect(find.text(AppStrings.addProgress), findsOneWidget);
    });

    testWidgets('placeholder shows bar chart icon', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(buildProgressScreen());
      expect(find.byIcon(Icons.bar_chart_rounded), findsOneWidget);
    });
  });

  group('ProgressScreen with active streaks', () {
    testWidgets('shows one ProgressCard for a habit with an active streak', (
      WidgetTester tester,
    ) async {
      final habit = makeHabit(3, 0);
      when(mockHabitRepository.getAll()).thenAnswer((_) async => [habit]);
      await habitViewModel.getAllHabits();
      await tester.pumpWidget(buildProgressScreen());
      await tester.pumpAndSettle();
      expect(find.byType(ProgressCard), findsOneWidget);
    });

    testWidgets(
      'shows a ProgressCard for each habit that has an active streak',
      (WidgetTester tester) async {
        final habitOne = makeHabit(3, 0);
        final habitTwo = makeHabit(3, 0);
        final habitThree = makeHabit(3, 0);
        when(
          mockHabitRepository.getAll(),
        ).thenAnswer((_) async => [habitOne, habitTwo, habitThree]);
        await habitViewModel.getAllHabits();
        await tester.pumpWidget(buildProgressScreen());
        await tester.pumpAndSettle();
        expect(find.byType(ProgressCard), findsNWidgets(3));
      },
    );

    testWidgets('does NOT show ProgressCards for habits with a broken streak', (
      WidgetTester tester,
    ) async {
      final habitOne = makeHabit(5, 0);
      final habitTwo = makeHabit(5, 5);
      when(
        mockHabitRepository.getAll(),
      ).thenAnswer((_) async => [habitOne, habitTwo]);
      await habitViewModel.getAllHabits();
      await tester.pumpWidget(buildProgressScreen());
      await tester.pumpAndSettle();
      expect(find.byType(ProgressCard), findsOneWidget);
    });

    testWidgets(
      'does not show ProgressPlaceholder when active-streak habits exist',
      (WidgetTester tester) async {
        final habitOne = makeHabit(5, 0);
        when(mockHabitRepository.getAll()).thenAnswer((_) async => [habitOne]);
        await habitViewModel.getAllHabits();
        await tester.pumpWidget(buildProgressScreen());
        await tester.pumpAndSettle();
        expect(find.byType(ProgressPlaceholder), findsNothing);
      },
    );

    testWidgets('habit title is visible in the list', (
      WidgetTester tester,
    ) async {
      final habitOne = makeHabit(5, 0);
      when(mockHabitRepository.getAll()).thenAnswer((_) async => [habitOne]);
      await habitViewModel.getAllHabits();
      await tester.pumpWidget(buildProgressScreen());
      await tester.pumpAndSettle();
      expect(find.text('Morning run'), findsOneWidget);
    });
  });
}
