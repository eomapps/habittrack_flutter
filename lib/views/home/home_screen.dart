import 'package:habittrack/core/constants/app_colors.dart';
import 'package:habittrack/core/constants/app_dimens.dart';
import 'package:habittrack/core/constants/app_strings.dart';
import 'package:habittrack/core/constants/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:habittrack/views/add_edit_habit/add_edit_delete_habit_bottom_sheet.dart';
import 'package:habittrack/views/home/widgets/progress.dart';
import 'package:habittrack/views/home/widgets/today.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  final List<Widget> _tabs = [TodayScreen(), ProgressScreen()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _currentIndex == 0 ? AppStrings.today : AppStrings.progress,
          style: AppTextStyles.appBarTitle,
        ),
        centerTitle: false,
        actions: [
          _currentIndex == 0
              ? Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: GestureDetector(
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        builder: (BuildContext context) {
                          return Wrap(
                            children: [AddEditDeleteHabitBottomSheet()],
                          );
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
              : const SizedBox.shrink(),
        ],
      ),
      body: IndexedStack(index: _currentIndex, children: _tabs),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        selectedLabelStyle: AppTextStyles.navLabelActive,
        unselectedLabelStyle: AppTextStyles.navLabel,
        backgroundColor: AppColors.card,
        selectedItemColor: AppColors.purple,
        unselectedItemColor: AppColors.muted,
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
    );
  }
}
