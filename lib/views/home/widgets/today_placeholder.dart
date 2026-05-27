import 'package:habittrack/core/constants/app_colors.dart';
import 'package:habittrack/core/constants/app_dimens.dart';
import 'package:habittrack/core/constants/app_strings.dart';
import 'package:habittrack/core/constants/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:habittrack/core/utils/context_extensions.dart';

class TodayPlaceholder extends StatelessWidget {
  const TodayPlaceholder({super.key});

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
              child: SvgPicture.asset(
                'assets/images/home_icon.svg',
                width: 48,
                height: 48,
                fit: BoxFit.contain,
              ),
            ),
          ),
          SizedBox(height: spacing),
          Text(
            AppStrings.noHabitsYet,
            style: AppTextStyles.emptyStateTitle(context),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: spacing),
          Text(
            AppStrings.addPrompt,
            style: AppTextStyles.emptyStateSub(context),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
