import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:habittrack/core/constants/app_strings.dart';
import 'package:habittrack/core/utils/ht_utils.dart';
import 'package:habittrack/data/models/habit.dart';
import 'package:habittrack/viewmodels/habit_viewmodel.dart';
import 'package:habittrack/views/add_edit_habit/add_edit_delete_habit_bottom_sheet.dart';
import 'package:habittrack/views/home/widgets/habit_card.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

import '../../../data/viewmodels/habit_viewmodel_test.mocks.dart';

void main() {
  late MockHabitRepository mockHabitRepository;
  late HabitViewModel habitViewModel;
  late Habit testHabit;

  String makeLastCheckedDate(int daysPassed) {
    return DateTime.now()
        .subtract(Duration(days: daysPassed))
        .toIso8601String()
        .substring(0, 10);
  }

  setUp(() {
    mockHabitRepository = MockHabitRepository();
    habitViewModel = HabitViewModel(mockHabitRepository);
    testHabit = Habit(
      title: HTUtils.getInSentenceCase('morning run'),
      colorHex: '#FF5733',
      lastCheckedDate: makeLastCheckedDate(1),
      streakCount: 3,
    );
    when(mockHabitRepository.update(any)).thenAnswer((_) async {});
  });

  Widget buildHabitCard({bool isDone = false}) {
    return ChangeNotifierProvider<HabitViewModel>.value(
      value: habitViewModel,
      child: MaterialApp(
        home: Scaffold(
          body: HabitCard(habit: testHabit, isDone: isDone),
        ),
      ),
    );
  }

  testWidgets('shows habit title', (WidgetTester tester) async {
    await tester.pumpWidget(buildHabitCard());
    expect(find.text(testHabit.title), findsOneWidget);
  });

  group('streak detail line', () {
    testWidgets('shows no streak yet when streakCount == 0', (
      WidgetTester tester,
    ) async {
      testHabit = testHabit.copyWith(streakCount: 0);
      await tester.pumpWidget(buildHabitCard());
      expect(find.text(AppStrings.noStreakYet), findsOneWidget);
    });

    testWidgets('shows x day streak when streakCount > 0', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(buildHabitCard());
      expect(find.textContaining(AppStrings.dayStreak), findsOneWidget);
    });
  });

  group('circle', () {
    testWidgets('shows checkmark when isDone == true', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(buildHabitCard(isDone: true));
      expect(find.byIcon(Icons.check), findsOne);
    });

    testWidgets('shows no checkmark when isDone == false', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(buildHabitCard(isDone: false));
      expect(find.byIcon(Icons.check), findsNothing);
    });
  });

  group('tapping', () {
    testWidgets('shows AddEditHabitBottomSheet when tapped', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(buildHabitCard());
      await tester.tap(find.byKey(const Key('habit-card-tap')));
      await tester.pumpAndSettle();
      expect(find.byType(AddEditDeleteHabitBottomSheet), findsOneWidget);
    });

    testWidgets(
      'updates repository with today\'s date when tapping (circle) Container',
      (WidgetTester tester) async {
        await tester.pumpWidget(buildHabitCard());
        await tester.tap(find.byKey(const Key('habit-check-tap')));
        await tester.pump();
        final captured =
            verify(mockHabitRepository.update(captureAny)).captured.single
                as Habit;
        expect(captured.lastCheckedDate, makeLastCheckedDate(0));
      },
    );
  });
}
