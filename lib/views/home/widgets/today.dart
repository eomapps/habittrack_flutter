import 'package:flutter/material.dart';
import 'package:habittrack/core/utils/ht_utils.dart';

import 'package:habittrack/views/home/widgets/empty_placeholder.dart';

class TodayScreen extends StatefulWidget {
  const TodayScreen({super.key});

  @override
  State<TodayScreen> createState() => _TodayScreenState();
}

class _TodayScreenState extends State<TodayScreen> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(HTUtils.getFormattedDate()),
        ),
        Expanded(child: Center(child: EmptyPlaceholder())),
      ],
    );
  }
}
