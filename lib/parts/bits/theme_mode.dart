import 'package:flutter/material.dart';
import 'package:scouting_app_2024/parts/theme.dart';
import 'package:scouting_app_2024/user/user_telemetry.dart';
import 'package:theme_provider/theme_provider.dart';

class ThemeModeModal extends ChangeNotifier {
  AvaliableTheme value =
      AvaliableTheme.of(UserTelemetry().currentModel.selectedTheme);

  AvaliableTheme get mode => value;

  set mode(AvaliableTheme v) {
    value = v;
    notifyListeners();
  }

  static AvaliableTheme getMode(BuildContext context) =>
      AvaliableTheme.export.firstWhere((AvaliableTheme e) =>
          e.id == ThemeProvider.themeOf(context).id);
}
