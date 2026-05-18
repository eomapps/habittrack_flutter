import 'package:flutter/material.dart';
import 'package:habittrack/core/constants/app_colors.dart';
import 'package:habittrack/core/constants/app_dimens.dart';
import 'package:habittrack/core/constants/app_strings.dart';
import 'package:habittrack/core/constants/app_text_styles.dart';
import 'package:habittrack/data/models/habit.dart';
import 'package:habittrack/viewmodels/habit_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:habittrack/core/utils/color_extensions.dart';

class AddEditHabitBottomSheet extends StatefulWidget {
  final Habit? habit;
  final bool isEdit;

  const AddEditHabitBottomSheet({super.key, this.isEdit = false, this.habit});

  @override
  State<AddEditHabitBottomSheet> createState() =>
      _AddEditHabitBottomSheetState();
}

class _AddEditHabitBottomSheetState extends State<AddEditHabitBottomSheet> {
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

      // if (_selectedColor == Color(0xFF378ADD)) {
      //   _selectedIndex = 0;
      // } else if (_selectedColor == Color(0xFFD85A30)) {
      //   _selectedIndex = 1;
      // } else if (_selectedColor == Color(0xFF1D9E75)) {
      //   _selectedIndex = 2;
      // } else if (_selectedColor == Color(0xFF534AB7)) {
      //   _selectedIndex = 3;
      // } else if (_selectedColor == Color(0xFFD4537E)) {
      //   _selectedIndex = 4;
      // }
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
                    width: AppDimens.sheetHandleWidth, // 36
                    height: AppDimens.sheetHandleHeight, // 4
                    decoration: BoxDecoration(
                      color: AppColors.border,
                      borderRadius: BorderRadius.circular(
                        AppDimens.radiusSheetHandle,
                      ), // 2
                    ),
                  ),
                ),
                SizedBox(height: 14),
                Text(
                  widget.isEdit
                      ? AppStrings.editHabit.toUpperCase()
                      : AppStrings.newHabit.toUpperCase(),
                  style: AppTextStyles.sheetTitle,
                ),
              ],
            ),
          ),
          Text(AppStrings.habitName, style: AppTextStyles.emptyStateSub),
          SizedBox(height: 6),
          TextField(
            controller: _habitNameController,
            decoration: InputDecoration(
              fillColor: AppColors.cardBg,
              filled: true,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 9,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppDimens.radiusFormInput),
                borderSide: BorderSide(color: AppColors.border, width: 1),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppDimens.radiusFormInput),
                borderSide: BorderSide(
                  color: AppColors.border,
                  width: 1,
                ), // same — no blue flash
              ),
            ),
          ),
          const SizedBox(height: 14),
          Text(AppStrings.colorChoice, style: AppTextStyles.emptyStateSub),
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
                  context.read<HabitViewModel>().updateHabit(updated);
                } else {
                  context.read<HabitViewModel>().insertHabit(
                    Habit(
                      title: _habitNameController.text,
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
                  color: Colors.black.withOpacity(0.35),
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
              // if (_habitNameController.text.isNotEmpty) {
              //   context.read<HabitViewModel>().deleteHabit(
              //     widget.habit!,
              //   );
              //   Navigator.pop(context);
              // }
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
                style: AppTextStyles.sheetTitle,
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
                  if (_habitNameController.text.isNotEmpty) {
                    context.read<HabitViewModel>().deleteHabit(widget.habit!);
                    Navigator.pop(context);
                  }
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
