import 'package:eomappshabit_track/core/constants/app_strings.dart';
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
        title: Text(
          AppStrings.today,
          style: Theme.of(context).textTheme.headlineLarge,
        ),
        centerTitle: false,
      ),
    );
  }
}
