import 'dart:async';

import 'package:habittrack/core/constants/app_colors.dart';
import 'package:habittrack/core/constants/app_dimens.dart';
import 'package:habittrack/core/constants/app_strings.dart';
import 'package:habittrack/core/constants/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:habittrack/core/notifications/notification_handler.dart';
import 'package:habittrack/core/utils/context_extensions.dart';
import 'package:habittrack/views/add_edit_habit/add_edit_delete_habit_bottom_sheet.dart';
import 'package:habittrack/views/home/widgets/progress.dart';
import 'package:habittrack/views/home/widgets/today.dart';
import 'package:habittrack/views/settings.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  int _currentIndex = 0;
  final List<Widget> _tabs = [TodayScreen(), ProgressScreen()];
  late StreamSubscription _notificationSub;
  bool _handlingNotificationTap = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    // Defer until after first frame so the navigator is ready and no
    // partially-restored route (e.g. SettingsScreen from a previous task
    // stack) is visible when popUntil fires.
    WidgetsBinding.instance.addPostFrameCallback((_) => _checkNotificationFlag());
    _notificationSub = notificationTapStream.stream.listen((_) {
      if (!mounted) return;
      Navigator.of(context).popUntil((route) => route.isFirst);
      setState(() => _currentIndex = 0);
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) _checkNotificationFlag();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _notificationSub.cancel();
    super.dispose();
  }

  Future<void> _checkNotificationFlag() async {
    if (_handlingNotificationTap) return;
    _handlingNotificationTap = true;
    try {
      final prefs = await SharedPreferences.getInstance();
      if (prefs.getBool(AppStrings.notificationTapped) ?? false) {
        await prefs.remove(AppStrings.notificationTapped);
        if (mounted) {
          Navigator.of(context).popUntil((route) => route.isFirst);
          setState(() => _currentIndex = 0);
        }
      }
    } finally {
      _handlingNotificationTap = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _currentIndex == 0 ? AppStrings.today : AppStrings.progress,
          style: AppTextStyles.appBarTitle(context),
        ),
        centerTitle: false,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (context) => const SettingsScreen(),
                ),
              );
            },
            icon: Icon(Icons.settings),
            color: AppColors.purpleMid,
          ),
        ],
      ),
      body: IndexedStack(index: _currentIndex, children: _tabs),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        selectedLabelStyle: AppTextStyles.navLabelActive,
        unselectedLabelStyle: AppTextStyles.navLabel(context),
        backgroundColor: context.colors.card,
        selectedItemColor: AppColors.purple,
        unselectedItemColor: context.colors.muted,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.today_rounded, size: 18),
            label: AppStrings.today,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart_rounded, size: 18),
            label: AppStrings.progress,
          ),
        ],
      ),
      floatingActionButton: getFABButton(),
    );
  }

  Widget getFABButton() {
    return _currentIndex == 0
        ? Padding(
            padding: const EdgeInsets.only(right: 12),
            child: GestureDetector(
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  builder: (BuildContext context) {
                    return Wrap(children: [AddEditDeleteHabitBottomSheet()]);
                  },
                );
              },
              behavior: HitTestBehavior.opaque,
              child: Container(
                height: AppDimens.fabSize,
                width: AppDimens.fabSize,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.purple,
                  boxShadow: [AppDimens.fabShadow],
                ),
                child: Icon(Icons.add, color: Colors.white, size: 20),
              ),
            ),
          )
        : const SizedBox.shrink();
  }
}
