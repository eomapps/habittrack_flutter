import 'package:flutter/material.dart';
import 'package:habittrack/core/constants/app_colors.dart';
import 'package:habittrack/core/constants/app_dimens.dart';
import 'package:habittrack/core/constants/app_text_styles.dart';
import 'package:habittrack/core/utils/ht_utils.dart';
import 'package:habittrack/data/models/habit.dart';
import 'package:habittrack/viewmodels/habit_viewmodel.dart';
import 'package:provider/provider.dart';

class HabitCard extends StatefulWidget {
  final Habit habit;
  final bool isDone;

  const HabitCard({super.key, required this.habit, this.isDone = false});

  @override
  State<HabitCard> createState() => _HabitCardState();
}

class _HabitCardState extends State<HabitCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(AppDimens.radiusCard),
        border: Border.all(color: AppColors.border, width: 1),
      ),
      margin: AppDimens.paddingHabitCardMargin,
      padding: AppDimens.paddingHabitCard,
      child: Row(
        children: [
          Container(
            height: AppDimens.colorDotSize,
            width: AppDimens.colorDotSize,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Color(
                int.parse('0xFF${widget.habit.colorHex.substring(1)}'),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  HTUtils.getInSentenceCase(widget.habit.title),
                  style: AppTextStyles.habitName,
                ),
                const SizedBox(width: 2),
                Text(
                  widget.habit.streakCount > 0
                      ? '🔥 ${widget.habit.computedStreak} day streak'
                      : 'No streak yet',
                  style: AppTextStyles.habitStreak,
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          GestureDetector(
            onTap: () {
              context.read<HabitViewModel>().toggleHabit(widget.habit);
            },
            child: Container(
              height: AppDimens.checkCircleSize,
              width: AppDimens.checkCircleSize,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: widget.isDone
                    ? Color(
                        int.parse('0xFF${widget.habit.colorHex.substring(1)}'),
                      )
                    : AppColors.card,
                boxShadow: widget.isDone ? [AppDimens.checkDoneShadow] : null,
                border: widget.isDone
                    ? null
                    : Border.all(color: AppColors.border, width: 1.5),
              ),
              child: widget.isDone
                  ? Icon(Icons.check, color: Colors.white)
                  : null,
            ),
          ),
        ],
      ),
    );
  }
}
