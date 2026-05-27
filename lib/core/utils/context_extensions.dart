import 'package:flutter/material.dart';
import 'package:habittrack/core/constants/app_color_tokens.dart';

extension AppContextExtensions on BuildContext {
  AppColorTokens get colors => Theme.of(this).extension<AppColorTokens>()!;
}
