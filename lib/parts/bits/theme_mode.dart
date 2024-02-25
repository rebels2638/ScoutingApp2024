import 'package:flutter/material.dart';
import 'package:scouting_app_2024/parts/theme.dart';
import 'package:scouting_app_2024/user/user_telemetry.dart';
import 'package:theme_provider/theme_provider.dart';

class ThemeModeModal extends ChangeNotifier {
  AvailableTheme value =
      AvailableTheme.of(UserTelemetry().currentModel.selectedTheme);

  AvailableTheme get mode => value;

  set mode(AvailableTheme v) {
    value = v;
    notifyListeners();
  }

  static AvailableTheme getMode(BuildContext context) =>
      AvailableTheme.export.firstWhere((AvailableTheme e) =>
          e.id == ThemeProvider.themeOf(context).id);
}
