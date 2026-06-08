import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habittrack/core/constants/app_colors.dart';
import 'package:habittrack/core/constants/app_dimens.dart';
import 'package:habittrack/core/constants/app_strings.dart';
import 'package:habittrack/core/constants/app_text_styles.dart';
import 'package:habittrack/core/utils/context_extensions.dart';
import 'package:habittrack/core/utils/ht_utils.dart';
import 'package:habittrack/data/models/habit.dart';
import 'package:habittrack/core/utils/color_extensions.dart';
import 'package:habittrack/main.dart';

class AddEditDeleteHabitBottomSheet extends ConsumerStatefulWidget {
  final Habit? habit;
  final bool isEdit;

  const AddEditDeleteHabitBottomSheet({
    super.key,
    this.isEdit = false,
    this.habit,
  });

  @override
  ConsumerState<AddEditDeleteHabitBottomSheet> createState() =>
      _AddEditDeleteHabitBottomSheetState();
}

class _AddEditDeleteHabitBottomSheetState
    extends ConsumerState<AddEditDeleteHabitBottomSheet> {
  final TextEditingController _habitNameController = TextEditingController();
  int _selectedIndex = 0;
  Color _selectedColor = AppColors.blue;
  bool _confirmedDelete = false;

  @override
  void initState() {
    super.initState();
    if (widget.isEdit && widget.habit != null) {
      _habitNameController.text = widget.habit!.title;
      _selectedColor = Color(
        int.parse('0xFF${widget.habit!.colorHex.substring(1)}'),
      );
      List<Color> colors = [
        Color(0xFF378ADD),
        Color(0xFFD85A30),
        Color(0xFF1D9E75),
        Color(0xFF534AB7),
        Color(0xFFD4537E),
      ];
      _selectedIndex = colors.indexWhere(
        (c) =>
            c == Color(int.parse('0xFF${widget.habit!.colorHex.substring(1)}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: AppDimens.paddingSheet,
      decoration: BoxDecoration(borderRadius: AppDimens.radiusBottomSheet),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: AppDimens.paddingSheetHandleTitle,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: AppDimens.sheetHandleWidth,
                    height: AppDimens.sheetHandleHeight,
                    decoration: BoxDecoration(
                      color: context.colors.border,
                      borderRadius: BorderRadius.circular(
                        AppDimens.radiusSheetHandle,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 14),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.isEdit
                          ? AppStrings.editHabit.toUpperCase()
                          : AppStrings.newHabit.toUpperCase(),
                      style: AppTextStyles.sheetTitle(context),
                    ),
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      padding: EdgeInsets.zero,
                      icon: Icon(Icons.cancel_outlined),
                      constraints: const BoxConstraints(),
                      visualDensity: VisualDensity.compact,
                    ),
                  ],
                ),
              ],
            ),
          ),
          Text(
            AppStrings.habitName,
            style: AppTextStyles.emptyStateSub(context),
          ),
          SizedBox(height: 6),
          TextField(
            controller: _habitNameController,
            decoration: InputDecoration(
              fillColor: context.colors.cardBg,
              filled: true,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 9,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppDimens.radiusFormInput),
                borderSide: BorderSide(color: context.colors.border, width: 1),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppDimens.radiusFormInput),
                borderSide: BorderSide(color: context.colors.border, width: 1),
              ),
            ),
          ),
          const SizedBox(height: 14),
          Text(
            AppStrings.colorChoice,
            style: AppTextStyles.emptyStateSub(context),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _getColorChoice(AppColors.blue, 0),
                _getColorChoice(AppColors.orange, 1),
                _getColorChoice(AppColors.green, 2),
                _getColorChoice(AppColors.purple, 3),
                _getColorChoice(AppColors.pink, 4),
              ],
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ButtonStyle(
                backgroundColor: WidgetStatePropertyAll(AppColors.purple),
                shape: WidgetStateProperty.all<OutlinedBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppDimens.radiusButton),
                  ),
                ),
              ),
              onPressed: () {
                if (widget.isEdit) {
                  final updated = widget.habit!.copyWith(
                    title: _habitNameController.text,
                    colorHex: _selectedColor.toHex(),
                  );
                  ref.read(habitProvider.notifier).updateHabit(updated);
                } else {
                  ref
                      .read(habitProvider.notifier)
                      .insertHabit(
                        Habit(
                          title: HTUtils.getInSentenceCase(
                            _habitNameController.text,
                          ),
                          colorHex: _selectedColor.toHex(),
                        ),
                      );
                }
                Navigator.pop(context);
              },
              child: Text(
                widget.isEdit ? AppStrings.updateHabit : AppStrings.saveHabit,
                style: AppTextStyles.saveButton,
              ),
            ),
          ),
          if (widget.isEdit) ...[
            SizedBox(
              width: double.infinity,
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: _confirmedDelete
                    ? _makeConfirmationRow()
                    : _makeDeleteButton(),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _getColorChoice(Color color, int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedIndex = index;
          _selectedColor = color;
        });
      },
      child: Container(
        height: AppDimens.colorSwatchSize,
        width: AppDimens.colorSwatchSize,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color,
          border: _selectedIndex == index
              ? Border.all(
                  color: Colors.black.withValues(alpha: 0.35),
                  width: 2,
                  strokeAlign: BorderSide.strokeAlignOutside,
                )
              : null,
        ),
        child: _selectedIndex == index
            ? const Icon(Icons.check, color: Colors.white, size: 14)
            : null,
      ),
    );
  }

  Widget _makeDeleteButton() {
    return Column(
      children: [
        const SizedBox(height: 10),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            style: ButtonStyle(
              backgroundColor: WidgetStatePropertyAll(AppColors.red),
              shape: WidgetStateProperty.all<OutlinedBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppDimens.radiusButton),
                ),
              ),
            ),
            onPressed: () {
              setState(() {
                _confirmedDelete = true;
              });
            },
            child: Text(
              AppStrings.deleteHabit,
              style: AppTextStyles.saveButton,
            ),
          ),
        ),
      ],
    );
  }

  Widget _makeConfirmationRow() {
    return Column(
      children: [
        const SizedBox(height: 10),
        SizedBox(
          width: double.infinity,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppStrings.confirmationPrompt,
                style: AppTextStyles.sheetTitle(context),
              ),
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll(AppColors.red),
                  shape: WidgetStateProperty.all<OutlinedBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        AppDimens.radiusButton,
                      ),
                    ),
                  ),
                ),
                onPressed: () {
                  ref.read(habitProvider.notifier).deleteHabit(widget.habit!);
                  Navigator.pop(context);
                },
                child: Text(
                  AppStrings.yes.toUpperCase(),
                  style: AppTextStyles.saveButton,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
