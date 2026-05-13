import 'package:habittrack/core/constants/app_colors.dart';
import 'package:habittrack/core/constants/app_dimens.dart';
import 'package:habittrack/core/constants/app_strings.dart';
import 'package:habittrack/core/constants/app_text_styles.dart';
import 'package:habittrack/views/home/widgets/empty_placeholder.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<StatefulWidget> createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.today, style: AppTextStyles.appBarTitle),
        centerTitle: false,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: GestureDetector(
              onTap: () {
                // TODO implement to open the addeditbottomsheet
              },
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
          ),
        ],
      ),
      body: Column(children: [Expanded(child: EmptyPlaceholder())]),
    );
  }
}
