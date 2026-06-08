import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habittrack/main.dart';
import 'package:habittrack/views/home/widgets/progress_card.dart';
import 'package:habittrack/views/home/widgets/progress_placeholder.dart';

class ProgressScreen extends ConsumerStatefulWidget {
  const ProgressScreen({super.key});

  @override
  ConsumerState<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends ConsumerState<ProgressScreen> {
  @override
  Widget build(BuildContext context) {
    ref.watch(habitProvider);
    final notifier = ref.read(habitProvider.notifier);
    final habitsWithStreak = notifier.getAllHabitsSortedByStreak
        .where((h) => h.computedStreak > 0)
        .toList();
    final maxStreak = notifier.maxStreak;
    return habitsWithStreak.isEmpty
        ? Center(child: ProgressPlaceholder())
        : ListView.builder(
            itemCount: habitsWithStreak.length,
            itemBuilder: (context, index) {
              final habit = habitsWithStreak[index];
              return ProgressCard(habit: habit, maxStreak: maxStreak);
            },
          );
  }
}
