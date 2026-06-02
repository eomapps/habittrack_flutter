import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:habittrack/core/constants/app_dimens.dart';
import 'package:habittrack/core/constants/app_strings.dart';
import 'package:habittrack/core/constants/app_text_styles.dart';
import 'package:habittrack/core/utils/ht_utils.dart';
import 'package:habittrack/viewmodels/settings_viewmodel.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

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
            value: viewModel.notificationsEnabled,
            onChanged: (value) async {
              if (!value) {
                context.read<SettingsViewmodel>().setNotifications(false);
                return;
              }
              final canEnable = await viewModel.canEnableNotifications();
              if (!context.mounted) return;
              if (canEnable == true) {
                context.read<SettingsViewmodel>().setNotifications(true);
              } else {
                showDialog(
                  context: context,
                  builder: (_) => _buildNotificationsBlockedDialog(context),
                );
              }
            },
          ),
          viewModel.notificationsEnabled
              ? ListTile(
                  trailing: const Icon(Icons.timer),
                  onTap: () async {
                    final TimeOfDay? time = await showTimePicker(
                      context: context,
                      initialTime: viewModel.notificationTime,
                    );
                    if (context.mounted) {
                      if (time != null) {
                        viewModel.setNotificationTime(time.hour, time.minute);
                      }
                    }
                  },
                  title: Text(
                    '${AppStrings.notifyAt} ${viewModel.notificationTime.hourOfPeriod}:${viewModel.notificationTime.minute.toString().padLeft(2, '0')} ${viewModel.notificationTime.period.name.toUpperCase()}',
                    style: AppTextStyles.habitName(context),
                  ),
                )
              : const SizedBox.shrink(),
          if (viewModel.notificationsBlockedByOS)
            ListTile(
              title: Text(
                AppStrings.checkNotificationsPermission,
                style: AppTextStyles.habitName(context),
              ),
              trailing: const Icon(Icons.refresh),
              onTap: () async {
                final canEnable = await viewModel.canEnableNotifications();
                if (!context.mounted) return;
                if (canEnable == true) {
                  context.read<SettingsViewmodel>().setNotifications(true);
                } else {
                  showDialog(
                    context: context,
                    builder: (_) => _buildNotificationsBlockedDialog(context),
                  );
                }
              },
            ),
          Padding(
            padding: AppDimens.paddingDateRow,
            child: Text(
              AppStrings.appearance.toUpperCase(),
              style: AppTextStyles.dateRow(context),
            ),
          ),
          SwitchListTile(
            title: Text(
              viewModel.themeDark ? 'Dark Mode' : 'Light Mode',
              style: AppTextStyles.habitName(context),
            ),
            value: viewModel.themeDark,
            onChanged: (value) {
              context.read<SettingsViewmodel>().setThemeDark(value);
            },
          ),
          const Spacer(),
          SafeArea(
            minimum: const EdgeInsets.only(bottom: 16),
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

  Widget _buildNotificationsBlockedDialog(BuildContext context) {
    return AlertDialog(
      title: const Text(AppStrings.notificationsBlocked),
      content: const Text(AppStrings.openSettingsPrompt),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text(AppStrings.cancel),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            AppSettings.openAppSettings();
          },
          child: const Text(AppStrings.openSettings),
        ),
      ],
    );
  }
}
