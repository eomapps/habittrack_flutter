import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habittrack/core/constants/app_dimens.dart';
import 'package:habittrack/core/constants/app_strings.dart';
import 'package:habittrack/core/constants/app_text_styles.dart';
import 'package:habittrack/core/utils/ht_utils.dart';
import 'package:habittrack/views/home/widgets/today_placeholder.dart';
import 'package:habittrack/views/home/widgets/habit_card.dart';
import 'package:habittrack/main.dart';

class TodayScreen extends ConsumerStatefulWidget {
  final DateTime? dateTime;
  const TodayScreen({super.key, this.dateTime});

  @override
  ConsumerState<TodayScreen> createState() => _TodayScreenState();
}

class _TodayScreenState extends ConsumerState<TodayScreen>
    with WidgetsBindingObserver {
  late String dateToday;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(habitProvider.notifier).getAllHabits();
    });
    dateToday = HTUtils.getFormattedDate(widget.dateTime);
    _initTimer();
  }

  void _initTimer() {
    final now = DateTime.now().add(Duration(days: 1));
    final nextMidnight = DateTime(now.year, now.month, now.day);
    final durationToUse = nextMidnight.difference(DateTime.now());
    if (durationToUse.inMinutes <= 0) {
      if (HTUtils.getFormattedDate(DateTime.now()) != dateToday) {
        setState(() {
          dateToday = HTUtils.getFormattedDate(DateTime.now());
        });
      }
      timer = Timer(Duration(hours: 24), () => onEnd());
    } else {
      timer = Timer(Duration(minutes: durationToUse.inMinutes), () => onEnd());
    }
  }

  void onEnd() {
    if (mounted) {
      if (HTUtils.getFormattedDate(DateTime.now()) != dateToday) {
        setState(() {
          dateToday = HTUtils.getFormattedDate(DateTime.now());
        });
      }
      _initTimer();
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      setState(() {
        dateToday = HTUtils.getFormattedDate(DateTime.now());
      });
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
    final habits = ref.watch(habitProvider);
    final today = DateTime.now().toIso8601String().substring(0, 10);
    final notDone = habits.where((h) => h.lastCheckedDate != today).toList();
    final done = habits.where((h) => h.lastCheckedDate == today).toList();
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
        if (habits.isEmpty)
          const Expanded(child: Center(child: TodayPlaceholder())),
        if (habits.isNotEmpty)
          Column(
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
          ),
      ],
    );
  }
}
