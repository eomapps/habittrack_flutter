import 'package:habittrack/data/models/habit.dart';
import 'package:habittrack/data/repositories/habit_repository.dart';
import 'package:flutter/material.dart';
import 'dart:math';

class HabitViewModel extends ChangeNotifier {
  final HabitRepository _repository;
  HabitViewModel(this._repository);

  List<Habit> _habits = [];
  bool _isLoading = false;

  List<Habit> get habits => _habits;
  bool get isLoading => _isLoading;

  Future<void> getAllHabits() async {
    _isLoading = true;
    notifyListeners();
    _habits.clear();
    _habits = await _repository.getAll();
    _isLoading = false;
    notifyListeners();
  }

  Future<void> insertHabit(Habit habit) async {
    final insertedHabit = await _repository.insert(habit);
    _habits.add(insertedHabit);
    notifyListeners();
  }

  Future<void> updateHabit(Habit habit) async {
    await _repository.update(habit);
    final index = _habits.indexWhere((h) => h.id == habit.id);
    if (index != -1) {
      _habits[index] = habit;
    }
    notifyListeners();
  }

  Future<void> deleteHabit(Habit habit) async {
    await _repository.delete(habit.id!);
    _habits.removeWhere((h) => h.id == habit.id);
    notifyListeners();
  }

  Future<void> toggleHabit(Habit habit) async {
    // was not toggled on before tap
    if (!habit.toggledOn) {
      final today = DateTime.now().toIso8601String().substring(0, 10);

      // The user never had a streak (first-time), so now setting to 1
      if (habit.lastCheckedDate == null) {
        final updated = habit.copyWith(
          streakCount: 1,
          lastCheckedDate: today,
          toggledOn: true,
        );
        await updateHabit(updated);
        return;
      }

      // habit.lastCheckedDate has value
      // so we need to see how many days have passed since then
      final lastChecked = DateTime.parse(habit.lastCheckedDate!);
      final daysSinceLastCheck = DateTime.now().difference(lastChecked).inDays;

      // if only 1 day has passed (it was yesterday) then increment newStreakCount by 1
      // if > 1 day has passed, reset newStreakCount to 1 to start a new streak
      int newStreakCount;
      if (daysSinceLastCheck == 1) {
        newStreakCount = habit.streakCount + 1;
      } else {
        newStreakCount = 1;
      }

      final updated = habit.copyWith(
        streakCount: newStreakCount,
        lastCheckedDate: today,
        toggledOn: true,
      );
      await updateHabit(updated);
    } else {
      // was toggled on before tap
      // streakCount is always >= 1 when toggledOn, so these two branches are exhaustive
      if (habit.streakCount > 1) {
        final lastChecked = DateTime.parse(habit.lastCheckedDate!);
        final updatedCheckedDated = lastChecked.subtract(
          const Duration(days: 1),
        );
        final updatedDateString = updatedCheckedDated
            .toIso8601String()
            .substring(0, 10);
        final updated = habit.copyWith(
          lastCheckedDate: updatedDateString,
          toggledOn: false,
          streakCount: habit.streakCount - 1,
        );
        await updateHabit(updated);
      } else if (habit.streakCount == 1) {
        final updated = habit.copyWith(
          lastCheckedDate: null,
          toggledOn: false,
          streakCount: 0,
        );
        await updateHabit(updated);
      }
    }
  }

  List<Habit> get getAllHabitsSortedByStreak {
    final sorted = List<Habit>.from(_habits);
    sorted.sort((b, a) => a.streakCount.compareTo(b.streakCount));
    return sorted;
  }

  int get maxStreak {
    if (_habits.isEmpty) return 1;
    return _habits.map((h) => h.streakCount).reduce(max);
  }
}
