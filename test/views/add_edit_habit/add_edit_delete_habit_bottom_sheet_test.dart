import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:habittrack/core/constants/app_strings.dart';
import 'package:habittrack/core/constants/app_theme.dart';
import 'package:habittrack/core/utils/ht_utils.dart';
import 'package:habittrack/data/models/habit.dart';
import 'package:habittrack/viewmodels/habit_viewmodel.dart';
import 'package:habittrack/views/add_edit_habit/add_edit_delete_habit_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:mockito/mockito.dart';

import '../../data/viewmodels/habit_viewmodel_test.mocks.dart';

void main() {
  late MockHabitRepository mockHabitRepository;
  late HabitViewModel habitViewModel;
  late Habit testHabit;

  Habit makeTestHabit() {
    return testHabit = Habit(
      title: HTUtils.getInSentenceCase('morning run'),
      colorHex: '#FF5733',
    );
  }

  setUp(() {
    mockHabitRepository = MockHabitRepository();
    habitViewModel = HabitViewModel(mockHabitRepository);
    testHabit = makeTestHabit();
    when(mockHabitRepository.update(any)).thenAnswer((_) async {});
    when(mockHabitRepository.insert(any)).thenAnswer((_) async => testHabit);
    when(mockHabitRepository.delete(any)).thenAnswer((_) async {});
  });

  Widget buildBottomSheet({bool isEdit = false}) {
    return ChangeNotifierProvider<HabitViewModel>.value(
      value: habitViewModel,
      child: MaterialApp(
        theme: AppTheme.light,
        home: Scaffold(
          body: AddEditDeleteHabitBottomSheet(habit: testHabit, isEdit: isEdit),
        ),
      ),
    );
  }

  group('add Habit', () {
    testWidgets('title shows NEW HABIT and delete button is absent', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(buildBottomSheet(isEdit: false));
      expect(find.text(AppStrings.newHabit.toUpperCase()), findsOneWidget);
      expect(find.text(AppStrings.deleteHabit), findsNothing);
    });

    testWidgets('repository will insert 1 new record', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(buildBottomSheet(isEdit: false));
      final textField = find.byType(TextField);
      await tester.enterText(textField, 'Drink water');
      await tester.tap(find.text(AppStrings.saveHabit));
      final captured =
          verify(mockHabitRepository.insert(captureAny)).captured.single
              as Habit;
      expect(captured.title, 'Drink water');
    });
  });

  group('edit/delete Habit', () {
    testWidgets('title shows EDIT HABIT and delete button is present', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(buildBottomSheet(isEdit: true));
      expect(find.text(AppStrings.editHabit.toUpperCase()), findsOneWidget);
      expect(find.text(AppStrings.deleteHabit), findsOneWidget);
    });

    testWidgets('repository will update 1 record', (WidgetTester tester) async {
      await tester.pumpWidget(buildBottomSheet(isEdit: true));
      final textField = find.byType(TextField);
      await tester.enterText(textField, 'Drink water');
      await tester.tap(find.text(AppStrings.updateHabit));
      final captured =
          verify(mockHabitRepository.update(captureAny)).captured.single
              as Habit;
      expect(captured.title, 'Drink water');
    });

    testWidgets('repository will delete 1 record', (WidgetTester tester) async {
      testHabit = testHabit.copyWith(id: 1);
      await tester.pumpWidget(buildBottomSheet(isEdit: true));
      final textField = find.byType(TextField);
      await tester.enterText(textField, 'Drink water');
      await tester.tap(find.text(AppStrings.deleteHabit));
      await tester.pump();
      await tester.tap(find.text(AppStrings.yes.toUpperCase()));
      final captured = verify(
        mockHabitRepository.delete(captureAny),
      ).captured.single;
      expect(captured, 1);
    });
  });
}
