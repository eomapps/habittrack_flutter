import 'package:flutter_test/flutter_test.dart';
import 'package:habittrack/data/models/habit.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:habittrack/data/repositories/habit_repository.dart';
import 'package:habittrack/viewmodels/habit_viewmodel.dart';
import 'habit_viewmodel_test.mocks.dart';

@GenerateMocks([HabitRepository])
void main() {
  late MockHabitRepository mockHabitRepository;
  late HabitViewModel habitViewModel;

  setUp(() {
    mockHabitRepository = MockHabitRepository();
    habitViewModel = HabitViewModel(mockHabitRepository);
  });

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

  group('database updates streakCount', () {
    test('does not update repository when already checked today', () async {
      final habit = makeHabit(1, makeLastCheckedDate(0));
      await habitViewModel.toggleHabit(habit);
      verifyNever(mockHabitRepository.update(any));
    });

    test('updates repository to 1 when lastCheckedDate == null', () async {
      final habit = makeHabit(0, null);
      await habitViewModel.toggleHabit(habit);
      final captured =
          verify(mockHabitRepository.update(captureAny)).captured.single
              as Habit;
      expect(captured.streakCount, 1);
    });

    test('updates repository by 1 when lastCheckDate was yesterday', () async {
      final habit = makeHabit(3, makeLastCheckedDate(1));
      await habitViewModel.toggleHabit(habit);
      final captured =
          verify(mockHabitRepository.update(captureAny)).captured.single
              as Habit;
      expect(captured.streakCount, 4);
    });

    test('updates repository to 1 if daysSinceLastCheck > 1', () async {
      final habit = makeHabit(4, makeLastCheckedDate(2));
      await habitViewModel.toggleHabit(habit);
      final captured =
          verify(mockHabitRepository.update(captureAny)).captured.single
              as Habit;
      expect(captured.streakCount, 1);
    });
  });
}
