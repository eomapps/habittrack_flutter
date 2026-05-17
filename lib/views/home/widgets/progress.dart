import 'package:flutter/material.dart';
import 'package:habittrack/core/constants/app_dimens.dart';
import 'package:habittrack/viewmodels/habit_viewmodel.dart';
import 'package:habittrack/views/home/widgets/progress_card.dart';
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
        if (value.habits.isEmpty) {
          // todo show placeholder
        }
        return ListView.builder(
          itemCount: value.getAllHabitsSortedByStreak.length,
          itemBuilder: (context, index) {
            final habit = value.getAllHabitsSortedByStreak[index];
            return ProgressCard(habit: habit, maxStreak: value.maxStreak);
          },
        );
      },
    );
  }
}
