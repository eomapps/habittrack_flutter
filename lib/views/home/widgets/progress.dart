import 'package:flutter/material.dart';
import 'package:habittrack/viewmodels/habit_viewmodel.dart';
import 'package:habittrack/views/home/widgets/progress_card.dart';
import 'package:habittrack/views/home/widgets/progress_placeholder.dart';
import 'package:provider/provider.dart';

class ProgressScreen extends StatefulWidget {
  const ProgressScreen({super.key});

  @override
  State<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer<HabitViewModel>(
      builder: (context, value, child) {
        final habitsWithStreak = value.getAllHabitsSortedByStreak
            .where((h) => h.computedStreak > 0)
            .toList();
        if (habitsWithStreak.isEmpty) {
          return const ProgressPlaceholder();
        }
        return ListView.builder(
          itemCount: habitsWithStreak.length,
          itemBuilder: (context, index) {
            final habit = habitsWithStreak[index];
            return ProgressCard(habit: habit, maxStreak: value.maxStreak);
          },
        );
      },
    );
  }
}
