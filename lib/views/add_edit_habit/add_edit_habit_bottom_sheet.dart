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
  const AddEditHabitBottomSheet({super.key});

  @override
  State<AddEditHabitBottomSheet> createState() =>
      _AddEditHabitBottomSheetState();
}

class _AddEditHabitBottomSheetState extends State<AddEditHabitBottomSheet> {
  TextEditingController _habitNameController = TextEditingController();
  int _selectedIndex = 0;
  Color _selectedColor = AppColors.blue;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: AppDimens.paddingSheet,
      decoration: BoxDecoration(borderRadius: AppDimens.radiusBottomSheet),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
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
                  Text(
                    AppStrings.newHabit.toUpperCase(),
                    style: AppTextStyles.sheetTitle,
                  ),
                ],
              ),
            ),
            Text(AppStrings.habitName, style: AppTextStyles.emptyStateSub),
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
                  borderRadius: BorderRadius.circular(
                    AppDimens.radiusFormInput,
                  ),
                  borderSide: BorderSide(color: AppColors.border, width: 1),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(
                    AppDimens.radiusFormInput,
                  ),
                  borderSide: BorderSide(
                    color: AppColors.border,
                    width: 1,
                  ), // same — no blue flash
                ),
              ),
            ),
            const SizedBox(height: 14),
            Text(
              AppStrings.colorChoice.toUpperCase(),
              style: AppTextStyles.emptyStateSub,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _getColorChoice(AppColors.blue, 0),
                _getColorChoice(AppColors.orange, 1),
                _getColorChoice(AppColors.green, 2),
                _getColorChoice(AppColors.purple, 3),
                _getColorChoice(AppColors.pink, 4),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(AppColors.purple),
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
                      context.read<HabitViewModel>().insertHabit(
                        Habit(
                          title: _habitNameController.text,
                          colorHex: _selectedColor.toHex(),
                        ),
                      );
                      Navigator.pop(context);
                    }
                  },
                  child: Text(
                    AppStrings.saveHabit,
                    style: AppTextStyles.saveButton,
                  ),
                ),
              ),
            ),
          ],
        ),
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
}
