import 'package:flutter/material.dart';
import 'package:habittrack/core/constants/app_colors.dart';
import 'package:habittrack/core/constants/app_dimens.dart';
import 'package:habittrack/core/constants/app_strings.dart';
import 'package:habittrack/core/constants/app_text_styles.dart';
import 'package:habittrack/core/utils/context_extensions.dart';

class ProgressPlaceholder extends StatelessWidget {
  const ProgressPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    final spacing = MediaQuery.of(context).size.height * 0.02;

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 64,
            width: 64,
            decoration: BoxDecoration(
              color: context.colors.emptyStateIconBg,
              borderRadius: BorderRadius.circular(
                AppDimens.radiusEmptyStateIconBox,
              ),
            ),
            child: Center(
              child: Icon(
                Icons.bar_chart_rounded,
                color: AppColors.purpleMid,
                size: 48,
              ),
            ),
          ),
          SizedBox(height: spacing),
          Text(
            AppStrings.noProgressYet,
            style: AppTextStyles.emptyStateTitle(context),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: spacing),
          Text(
            AppStrings.addProgress,
            style: AppTextStyles.emptyStateSub(context),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
