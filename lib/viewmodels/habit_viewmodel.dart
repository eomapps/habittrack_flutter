import 'package:eomappshabit_track/data/models/habit.dart';
import 'package:eomappshabit_track/data/repositories/habit_repository.dart';
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
    if (habit.lastCheckedDate == today) {
      return;
    }
    final updated = habit.copyWith(
      streakCount: habit.streakCount + 1,
      lastCheckedDate: today,
    );
    await updateHabit(updated);
  }
}
