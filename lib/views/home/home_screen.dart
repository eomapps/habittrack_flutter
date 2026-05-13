import 'package:eomappshabit_track/core/constants/app_strings.dart';
import 'package:eomappshabit_track/views/home/widgets/empty_placeholder.dart';
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
      appBar: AppBar(title: Text(AppStrings.today), centerTitle: false),
      body: Column(children: [Expanded(child: EmptyPlaceholder())]),
    );
  }
}
