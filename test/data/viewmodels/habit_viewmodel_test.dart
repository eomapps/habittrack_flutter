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

  group('toggleHabit - check off', () {
    test(
      'lastCheckedDate rolls back and toggledOn switches to false when streakCount > 1',
      () async {
        final habit = makeHabit(2, makeLastCheckedDate(0));
        final updatedHabit = habit.copyWith(toggledOn: true);
        await habitViewModel.toggleHabit(updatedHabit);
        final captured =
            verify(mockHabitRepository.update(captureAny)).captured.single
                as Habit;
        expect(captured.streakCount, updatedHabit.streakCount - 1);
        expect(captured.lastCheckedDate, makeLastCheckedDate(1));
        expect(captured.toggledOn, false);
      },
    );

    test(
      'lastCheckedDate rolls back and toggledOn switches to false when streakCount == 1',
      () async {
        final habit = makeHabit(1, makeLastCheckedDate(0));
        final updatedHabit = habit.copyWith(toggledOn: true);
        await habitViewModel.toggleHabit(updatedHabit);
        final captured =
            verify(mockHabitRepository.update(captureAny)).captured.single
                as Habit;
        expect(captured.streakCount, updatedHabit.streakCount - 1);
        expect(captured.lastCheckedDate, null);
        expect(captured.toggledOn, false);
      },
    );
  });

  group('toggleHabit - check on', () {
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

    test(
      'allHabitsDoneToday is true after toggling the last unchecked habit on',
      () async {
        final alreadyDone = makeHabit(3, makeLastCheckedDate(0));
        final lastHabit = makeHabit(1, makeLastCheckedDate(1));
        final updatedLastHabit = lastHabit.copyWith(
          toggledOn: true,
          lastCheckedDate: makeLastCheckedDate(0),
          streakCount: 2,
        );
        when(
          mockHabitRepository.getAll(),
        ).thenAnswer((_) async => [alreadyDone, lastHabit]);
        await habitViewModel.getAllHabits();
        expect(habitViewModel.allHabitsDoneToday, false);

        when(
          mockHabitRepository.getAll(),
        ).thenAnswer((_) async => [alreadyDone, updatedLastHabit]);
        await habitViewModel.toggleHabit(lastHabit);
        await habitViewModel.getAllHabits();
        expect(habitViewModel.allHabitsDoneToday, true);
      },
    );
  });

  group('allHabitsDoneToday', () {
    test('returns false when habits list is empty', () {
      expect(habitViewModel.allHabitsDoneToday, false);
    });

    test('returns true when all habits were checked today', () async {
      final habitOne = makeHabit(1, makeLastCheckedDate(0));
      final habitTwo = makeHabit(2, makeLastCheckedDate(0));
      when(
        mockHabitRepository.getAll(),
      ).thenAnswer((_) async => [habitOne, habitTwo]);
      await habitViewModel.getAllHabits();
      expect(habitViewModel.allHabitsDoneToday, true);
    });

    test('returns false when some habits were not checked today', () async {
      final habitOne = makeHabit(1, makeLastCheckedDate(0));
      final habitTwo = makeHabit(2, makeLastCheckedDate(1));
      when(
        mockHabitRepository.getAll(),
      ).thenAnswer((_) async => [habitOne, habitTwo]);
      await habitViewModel.getAllHabits();
      expect(habitViewModel.allHabitsDoneToday, false);
    });

    test('returns false when no habits were checked today', () async {
      final habitOne = makeHabit(1, null);
      final habitTwo = makeHabit(2, makeLastCheckedDate(1));
      when(
        mockHabitRepository.getAll(),
      ).thenAnswer((_) async => [habitOne, habitTwo]);
      await habitViewModel.getAllHabits();
      expect(habitViewModel.allHabitsDoneToday, false);
    });
  });
}
