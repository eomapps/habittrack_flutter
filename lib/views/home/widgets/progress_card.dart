import 'package:flutter/material.dart';
import 'package:habittrack/core/constants/app_colors.dart';
import 'package:habittrack/core/constants/app_dimens.dart';
import 'package:habittrack/core/constants/app_text_styles.dart';
import 'package:habittrack/core/utils/context_extensions.dart';
import 'package:habittrack/core/utils/ht_utils.dart';
import 'package:habittrack/data/models/habit.dart';

class ProgressCard extends StatelessWidget {
  final Habit habit;
  final int maxStreak;

  const ProgressCard({super.key, required this.habit, required this.maxStreak});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.colors.cardBg,
        borderRadius: BorderRadius.circular(AppDimens.radiusCard),
        border: Border.all(color: context.colors.border, width: 1),
      ),
      margin: AppDimens.paddingProgressBody,
      padding: AppDimens.paddingProgressRowPad,
      child: Row(
        children: [
          Container(
            height: AppDimens.colorDotSize,
            width: AppDimens.colorDotSize,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Color(int.parse('0xFF${habit.colorHex.substring(1)}')),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  HTUtils.getInSentenceCase(habit.title),
                  style: AppTextStyles.progressName(context),
                ),
                SizedBox(height: AppDimens.progressRowGap),
                LinearProgressIndicator(
                  borderRadius: BorderRadius.circular(
                    AppDimens.radiusProgressBar,
                  ),
                  value: habit.streakCount / maxStreak,
                  backgroundColor: context.colors.bg,
                  minHeight: AppDimens.progressBarHeight,
                  color: Color(int.parse('0xFF${habit.colorHex.substring(1)}')),
                ),
                const SizedBox(height: 2),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Text(
            '${habit.computedStreak}d',
            style: AppTextStyles.progressStreak(context),
          ),
        ],
      ),
    );
  }
}
