import 'package:habittrack/data/models/habit.dart';
import 'package:habittrack/data/repositories/habit_repository.dart';
import 'package:flutter/material.dart';

class HabitViewModel extends ChangeNotifier {
  final HabitRepository _repository;
  HabitViewModel(this._repository);

  List<Habit> _habits = [];
  bool _isLoading = false;

  List<Habit> get habits => _habits;
  bool get isLoading => _isLoading;

  Future<void> getAllHabits() async {
    _isLoading = true;
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
    final today = DateTime.now().toIso8601String().substring(0, 10);

    // Don't let the user check off the same habit today twice
    if (habit.lastCheckedDate == today) {
      return;
    }

    // The user never had had a streak (first-time), so now setting to 1
    if (habit.lastCheckedDate == null) {
      final updated = habit.copyWith(streakCount: 1, lastCheckedDate: today);
      await updateHabit(updated);
      return;
    }

    // habit.lastCheckedDate has value
    //so we need to see how many days have passed since then
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
    );
    await updateHabit(updated);
  }
}
