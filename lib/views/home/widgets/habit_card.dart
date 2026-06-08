import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habittrack/core/constants/app_dimens.dart';
import 'package:habittrack/core/constants/app_text_styles.dart';
import 'package:habittrack/core/utils/context_extensions.dart';
import 'package:habittrack/core/utils/ht_utils.dart';
import 'package:habittrack/data/models/habit.dart';
import 'package:habittrack/main.dart';
import 'package:habittrack/views/add_edit_habit/add_edit_delete_habit_bottom_sheet.dart';

class HabitCard extends ConsumerStatefulWidget {
  final Habit habit;
  final bool isDone;

  const HabitCard({super.key, required this.habit, this.isDone = false});

  @override
  ConsumerState<HabitCard> createState() => _HabitCardState();
}

class _HabitCardState extends ConsumerState<HabitCard> {
  @override
  Widget build(BuildContext context) {
    ref.watch(habitProvider);
    return GestureDetector(
      key: const Key('habit-card-tap'),
      onTap: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          builder: (BuildContext context) {
            return Wrap(
              children: [
                AddEditDeleteHabitBottomSheet(
                  habit: widget.habit,
                  isEdit: true,
                ),
              ],
            );
          },
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: context.colors.cardBg,
          borderRadius: BorderRadius.circular(AppDimens.radiusCard),
          border: Border.all(color: context.colors.border, width: 1),
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
                    style: AppTextStyles.habitName(context),
                  ),
                  const SizedBox(width: 2),
                  Text(
                    widget.habit.getStreakMessage,
                    style: AppTextStyles.habitStreak(context),
                  ),
                ],
              ),
            ),
            GestureDetector(
              key: const Key('habit-check-tap'),
              onTap: () {
                ref.read(habitProvider.notifier).toggleHabit(widget.habit);
              },
              behavior: HitTestBehavior.opaque,
              child: Container(
                height: AppDimens.checkCircleSize,
                width: AppDimens.checkCircleSize,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: widget.isDone
                      ? Color(
                          int.parse(
                            '0xFF${widget.habit.colorHex.substring(1)}',
                          ),
                        )
                      : context.colors.card,
                  boxShadow: widget.isDone ? [AppDimens.checkDoneShadow] : null,
                  border: widget.isDone
                      ? null
                      : Border.all(color: context.colors.border, width: 1.5),
                ),
                child: widget.isDone
                    ? const Icon(Icons.check, color: Colors.white)
                    : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
