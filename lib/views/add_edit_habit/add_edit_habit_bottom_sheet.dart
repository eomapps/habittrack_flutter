import 'package:flutter/material.dart';
import 'package:habittrack/core/constants/app_colors.dart';
import 'package:habittrack/core/constants/app_dimens.dart';
import 'package:habittrack/core/constants/app_strings.dart';
import 'package:habittrack/core/constants/app_text_styles.dart';

class AddEditHabitBottomSheet extends StatefulWidget {
  const AddEditHabitBottomSheet({super.key});

  @override
  State<AddEditHabitBottomSheet> createState() =>
      _AddEditHabitBottomSheetState();
}

class _AddEditHabitBottomSheetState extends State<AddEditHabitBottomSheet> {
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
            TextField(), //TODO style
            Text(
              AppStrings.colorChoice.toUpperCase(),
              style: AppTextStyles.emptyStateSub,
            ),
            // TODO add colors
            // Row(
            //   children: [],
            // )
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
                    // TODO implement
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
}
