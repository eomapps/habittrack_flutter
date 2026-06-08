import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habittrack/core/constants/app_dimens.dart';
import 'package:habittrack/core/constants/app_strings.dart';
import 'package:habittrack/core/constants/app_text_styles.dart';
import 'package:habittrack/core/utils/ht_utils.dart';
import 'package:habittrack/main.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final notifier = ref.read(settingsProvider.notifier);
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
            key: const Key('settings-notifications-switch'),
            title: Text(
              AppStrings.enableNotifications,
              style: AppTextStyles.habitName(context),
            ),
            value: settings.notificationsEnabled,
            onChanged: (value) async {
              if (!value) {
                notifier.setNotifications(false);
                return;
              }
              final canEnable = await notifier.canEnableNotifications();
              if (!context.mounted) return;
              if (canEnable == true) {
                notifier.setNotifications(true);
              } else {
                showDialog(
                  context: context,
                  builder: (_) => _buildNotificationsBlockedDialog(context),
                );
              }
            },
          ),
          settings.notificationsEnabled
              ? ListTile(
                  trailing: const Icon(Icons.timer),
                  onTap: () async {
                    final TimeOfDay? time = await showTimePicker(
                      context: context,
                      initialTime: notifier.notificationTime,
                    );
                    if (context.mounted) {
                      if (time != null) {
                        notifier.setNotificationTime(time.hour, time.minute);
                      }
                    }
                  },
                  title: Text(
                    '${AppStrings.notifyAt} ${settings.notificationTime.hourOfPeriod}:${settings.notificationTime.minute.toString().padLeft(2, '0')} ${settings.notificationTime.period.name.toUpperCase()}',
                    style: AppTextStyles.habitName(context),
                  ),
                )
              : const SizedBox.shrink(),
          if (settings.notificationsBlockedByOS)
            ListTile(
              title: Text(
                AppStrings.checkNotificationsPermission,
                style: AppTextStyles.habitName(context),
              ),
              trailing: const Icon(Icons.refresh),
              onTap: () async {
                final canEnable = await notifier.canEnableNotifications();
                if (!context.mounted) return;
                if (canEnable == true) {
                  notifier.setNotifications(true);
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
            key: const Key('settings-themes-switch'),
            title: Text(
              settings.themeDark ? AppStrings.darkMode : AppStrings.lightMode,
              style: AppTextStyles.habitName(context),
            ),
            value: settings.themeDark,
            onChanged: (value) {
              notifier.setThemeDark(value);
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
