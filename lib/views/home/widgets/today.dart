import 'dart:async';

import 'package:flutter/material.dart';
import 'package:habittrack/core/constants/app_dimens.dart';
import 'package:habittrack/core/constants/app_strings.dart';
import 'package:habittrack/core/constants/app_text_styles.dart';
import 'package:habittrack/core/utils/ht_utils.dart';
import 'package:habittrack/viewmodels/habit_viewmodel.dart';
import 'package:habittrack/views/home/widgets/today_placeholder.dart';
import 'package:habittrack/views/home/widgets/habit_card.dart';
import 'package:provider/provider.dart';

/// How long until the next local midnight. Keeps the leftover seconds,
/// so a check at 11:59 still waits until 12:00.
Duration timeUntilNextMidnight(DateTime now) {
  final nextMidnight = DateTime(now.year, now.month, now.day + 1);
  return nextMidnight.difference(now);
}

class TodayScreen extends StatefulWidget {
  final DateTime? dateTime;
  const TodayScreen({super.key, this.dateTime});

  @override
  State<TodayScreen> createState() => _TodayScreenState();
}

class _TodayScreenState extends State<TodayScreen> with WidgetsBindingObserver {
  late String dateToday;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HabitViewModel>().getAllHabits();
    });
    dateToday = HTUtils.getFormattedDate(widget.dateTime);
    _initTimer();
  }

  void _initTimer() {
    timer = Timer(timeUntilNextMidnight(DateTime.now()), onEnd);
  }

  void onEnd() {
    if (mounted) {
      _refreshForNewDay();
      _initTimer();
    }
  }

  void _refreshForNewDay() {
    final nowLabel = HTUtils.getFormattedDate(DateTime.now());
    if (nowLabel == dateToday) return;

    setState(() {
      dateToday = nowLabel;
    });
    context.read<HabitViewModel>().resetTogglesForNewDay();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      setState(() {
        dateToday = HTUtils.getFormattedDate(DateTime.now());
      });
      context.read<HabitViewModel>().resetTogglesForNewDay();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: AppDimens.paddingDateRow,
          child: Text(
            dateToday,
            style: AppTextStyles.dateRow(context),
            key: const Key('date-today-text'),
          ),
        ),
        Consumer<HabitViewModel>(
          builder: (context, value, child) {
            if (value.habits.isEmpty) {
              return const Expanded(child: Center(child: TodayPlaceholder()));
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
                      style: AppTextStyles.sectionLabel(context),
                    ),
                  ),
                  ...notDone.map((habit) => HabitCard(habit: habit)),
                ],
                if (done.isNotEmpty) ...[
                  Padding(
                    padding: AppDimens.paddingSectionLabel,
                    child: Text(
                      AppStrings.doneToday,
                      style: AppTextStyles.sectionLabel(context),
                    ),
                  ),
                  ...done.map((habit) => HabitCard(habit: habit, isDone: true)),
                ],
              ],
            );
          },
        ),
      ],
    );
  }
}
