import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:habittrack/core/utils/ht_utils.dart';
import 'package:habittrack/viewmodels/habit_viewmodel.dart';
import 'package:habittrack/views/home/widgets/today.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

import '../../../data/viewmodels/habit_viewmodel_test.mocks.dart';

void main() {
  late MockHabitRepository mockHabitRepository;
  late HabitViewModel habitViewModel;
  late String dateToday;

  setUp(() {
    mockHabitRepository = MockHabitRepository();
    habitViewModel = HabitViewModel(mockHabitRepository);
    dateToday = HTUtils.getFormattedDate(DateTime.now());
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
      await tester.pumpWidget(buildTodayScreen());
      final textToday = find.byKey(const Key('date-today-text'));
      final indicator = tester.widget<Text>(textToday);
      expect(indicator.data, dateToday);
    });

    testWidgets('survives app resume', (WidgetTester tester) async {
      await tester.pumpWidget(buildTodayScreen());
      tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.paused);
      tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
      await tester.pumpAndSettle();
      final textToday = find.byKey(const Key('date-today-text'));
      final indicator = tester.widget<Text>(textToday);
      expect(indicator.data, dateToday);
    });
  });
}
