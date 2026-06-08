import 'package:flutter_riverpod/legacy.dart';
import 'package:habittrack/core/constants/app_strings.dart';
import 'package:habittrack/core/notifications/notification_service.dart';
import 'package:habittrack/data/models/habit.dart';
import 'package:habittrack/data/repositories/habit_repository.dart';
import 'package:flutter/material.dart';
import 'dart:math';

class HabitViewModel extends StateNotifier<List<Habit>> {
  final HabitRepository _repository;
  bool _isLoading = false;
  String? _error;

  String? get error => _error;
  bool get isLoading => _isLoading;

  HabitViewModel(this._repository) : super([]);

  Future<void> getAllHabits() async {
    try {
      _isLoading = true;
      state = await _repository.getAll();
      _isLoading = false;
    } catch (e) {
      debugPrint('getAllHabits failed: $e');
      _error = AppStrings.errorGetAllHabitsFailed;
    }
  }

  Future<void> insertHabit(Habit habit) async {
    try {
      final insertedHabit = await _repository.insert(habit);
      state = [...state, insertedHabit];
    } catch (e) {
      debugPrint('insertHabit failed: $e');
      _error = AppStrings.errorInsertHabitFailed;
    }
  }

  Future<void> updateHabit(Habit habit) async {
    try {
      await _repository.update(habit);
      state = [for (final h in state) h.id == habit.id ? habit : h];
    } catch (e) {
      debugPrint('updateHabit failed: $e');
      _error = AppStrings.errorUpdateHabitFailed;
    }
  }

  Future<void> deleteHabit(Habit habit) async {
    try {
      await _repository.delete(habit.id!);
      state = state.where((h) => h.id != habit.id).toList();
    } catch (e) {
      debugPrint('deleteHabit failed: $e');
      _error = AppStrings.errorDeleteHabitFailed;
    }
  }

  Future<void> toggleHabit(Habit habit) async {
    // was not toggled on before tap
    if (!habit.toggledOn) {
      final today = DateTime.now().toIso8601String().substring(0, 10);

      final Habit updated;
      // The user never had a streak (first-time), so now setting to 1
      if (habit.lastCheckedDate == null) {
        updated = habit.copyWith(
          streakCount: 1,
          lastCheckedDate: today,
          toggledOn: true,
        );
      } else {
        // habit.lastCheckedDate has value
        // so we need to see how many days have passed since then
        final lastChecked = DateTime.parse(habit.lastCheckedDate!);
        final daysSinceLastCheck = DateTime.now()
            .difference(lastChecked)
            .inDays;

        // if only 1 day has passed (it was yesterday) then increment newStreakCount by 1
        // if > 1 day has passed, reset newStreakCount to 1 to start a new streak
        final newStreakCount = daysSinceLastCheck == 1
            ? habit.streakCount + 1
            : 1;
        updated = habit.copyWith(
          streakCount: newStreakCount,
          lastCheckedDate: today,
          toggledOn: true,
        );
      }
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

    final service = NotificationsService.instance;
    if (service.viewmodel?.notificationsEnabled == true) {
      await service.scheduleNotification(allDoneToday: allHabitsDoneToday);
    }
  }

  List<Habit> get getAllHabitsSortedByStreak {
    final sorted = List<Habit>.from(state);
    sorted.sort((b, a) => a.streakCount.compareTo(b.streakCount));
    return sorted;
  }

  int get maxStreak {
    if (state.isEmpty) return 1;
    return state.map((h) => h.streakCount).reduce(max);
  }

  void clearError() => _error = null;

  bool get allHabitsDoneToday {
    if (state.isEmpty) return false;
    final today = DateTime.now().toIso8601String().substring(0, 10);
    return state.every((h) => h.lastCheckedDate == today);
  }
}
