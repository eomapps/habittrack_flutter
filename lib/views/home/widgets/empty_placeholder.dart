import 'package:eomappshabit_track/core/constants/app_colors.dart';
import 'package:eomappshabit_track/core/constants/app_dimens.dart';
import 'package:eomappshabit_track/core/constants/app_strings.dart';
import 'package:eomappshabit_track/core/constants/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class EmptyPlaceholder extends StatelessWidget {
  const EmptyPlaceholder({super.key});

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
              color: AppColors.emptyStateIconBg,
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
            style: AppTextStyles.emptyStateTitle,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: spacing),
          Text(
            AppStrings.addPrompt,
            style: AppTextStyles.emptyStateSub,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
