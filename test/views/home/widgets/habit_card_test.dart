import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:habittrack/core/utils/ht_utils.dart';
import 'package:habittrack/data/models/habit.dart';
import 'package:habittrack/viewmodels/habit_viewmodel.dart';
import 'package:habittrack/views/home/widgets/habit_card.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

import '../../../data/viewmodels/habit_viewmodel_test.mocks.dart';

void main() {
  late MockHabitRepository mockHabitRepository;
  late HabitViewModel habitViewModel;
  late Habit testHabit;

  setUp(() {
    mockHabitRepository = MockHabitRepository();
    habitViewModel = HabitViewModel(mockHabitRepository);
    testHabit = Habit(
      title: HTUtils.getInSentenceCase('morning run'),
      colorHex: '#FF5733',
      lastCheckedDate: null,
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

  testWidgets('HabitCard shows habit title', (WidgetTester tester) async {
    await tester.pumpWidget(buildHabitCard());
    expect(
      find.text(HTUtils.getInSentenceCase(testHabit.title)),
      findsOneWidget,
    );
  });
}
