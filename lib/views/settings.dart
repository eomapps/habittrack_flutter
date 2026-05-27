import 'package:flutter/material.dart';
import 'package:habittrack/core/constants/app_dimens.dart';
import 'package:habittrack/core/constants/app_strings.dart';
import 'package:habittrack/core/constants/app_text_styles.dart';
import 'package:habittrack/core/utils/ht_utils.dart';
import 'package:habittrack/viewmodels/settings_viewmodel.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => SettingsScreenState();
}

class SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<SettingsViewmodel>();
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppStrings.settings,
          style: AppTextStyles.appBarTitle(context),
        ),
        centerTitle: false,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
      ),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: AppDimens.paddingDateRow,
            child: Text(
              AppStrings.notifications.toUpperCase(),
              style: AppTextStyles.dateRow(context),
            ),
          ),
          SwitchListTile(
            title: Text(
              AppStrings.enableNotifications,
              style: AppTextStyles.habitName(context),
            ),
            value: viewModel.getNotificationsEnabled(),
            onChanged: (value) {
              context.read<SettingsViewmodel>().setNotifications(value);
            },
          ),
          viewModel.getNotificationsEnabled()
              ? ListTile(
                  trailing: Icon(Icons.timer),
                  onTap: () async {
                    final TimeOfDay? time = await showTimePicker(
                      context: context,
                      initialTime: viewModel.getNotificationTime(),
                    );
                    if (time != null) {
                      if (mounted) {
                        viewModel.setNotificationTime(time.hour, time.minute);
                      }
                    }
                  },
                  title: Text(
                    '${AppStrings.notifyAt} ${viewModel.getNotificationTime().hourOfPeriod}:${viewModel.getNotificationTime().minute.toString().padLeft(2, '0')} ${viewModel.getNotificationTime().period.name.toUpperCase()}',
                    style: AppTextStyles.habitName(context),
                  ),
                )
              : const SizedBox.shrink(),
          Padding(
            padding: AppDimens.paddingDateRow,
            child: Text(
              AppStrings.appearance.toUpperCase(),
              style: AppTextStyles.dateRow(context),
            ),
          ),
          SwitchListTile(
            title: Text(
              viewModel.getThemeDark() ? 'Dark Mode' : 'Light Mode',
              style: AppTextStyles.habitName(context),
            ),
            value: viewModel.getThemeDark(),
            onChanged: (value) {
              context.read<SettingsViewmodel>().setThemeDark(value);
            },
          ),
          Spacer(),
          SafeArea(
            minimum: EdgeInsets.only(bottom: 16),
            child: Center(
              child: GestureDetector(
                onTap: () {
                  HTUtils.openUrl();
                },
                child: Text(
                  AppStrings.attribution,
                  style: AppTextStyles.emptyStateTitle(context),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
