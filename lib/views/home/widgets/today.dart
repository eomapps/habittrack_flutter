import 'package:flutter/material.dart';
import 'package:habittrack/core/constants/app_dimens.dart';
import 'package:habittrack/core/constants/app_strings.dart';
import 'package:habittrack/core/constants/app_text_styles.dart';
import 'package:habittrack/core/utils/ht_utils.dart';
import 'package:habittrack/data/models/habit.dart';
import 'package:habittrack/viewmodels/habit_viewmodel.dart';

import 'package:habittrack/views/home/widgets/empty_placeholder.dart';
import 'package:habittrack/views/home/widgets/habit_card.dart';
import 'package:provider/provider.dart';

class TodayScreen extends StatefulWidget {
  const TodayScreen({super.key});

  @override
  State<TodayScreen> createState() => _TodayScreenState();
}

class _TodayScreenState extends State<TodayScreen> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(HTUtils.getFormattedDate(), style: AppTextStyles.dateRow),
        ),
        Consumer<HabitViewModel>(
          builder: (context, value, child) {
            if (value.habits.isEmpty) {
              return const Expanded(child: Center(child: EmptyPlaceholder()));
            }

            final today = DateTime.now().toIso8601String().substring(0, 10);
            final notDone = value.habits
                .where((h) => h.lastCheckedDate != today)
                .toList();
            final done = value.habits
                .where((h) => h.lastCheckedDate == today)
                .toList();

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (notDone.isNotEmpty) ...[
                  Padding(
                    padding: AppDimens.paddingSectionLabel,
                    child: Text(
                      AppStrings.notDone,
                      style: AppTextStyles.sectionLabel,
                    ),
                  ),
                  ...notDone.map((habit) => HabitCard(habit: habit)),
                ],
                if (done.isNotEmpty) ...[
                  Padding(
                    padding: AppDimens.paddingSectionLabel,
                    child: Text(
                      AppStrings.doneToday,
                      style: AppTextStyles.sectionLabel,
                    ),
                  ),
                  ...done.map((habit) => HabitCard(habit: habit)),
                ],
              ],
            );
          },
        ),
      ],
    );
  }
}
