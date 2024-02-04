import 'package:flutter/material.dart';
import 'package:scouting_app_2024/parts/theme.dart';
import 'package:scouting_app_2024/user/user_telemetry.dart';
import 'package:theme_provider/theme_provider.dart';

class ThemeModeModal extends ChangeNotifier {
  AvaliableThemes value = UserTelemetry().currentModel.selectedTheme;

  AvaliableThemes get mode => value;

  set mode(AvaliableThemes v) {
    value = v;
    notifyListeners();
  }

  static AvaliableThemes getMode(BuildContext context) =>
      AvaliableThemes.values.firstWhere((AvaliableThemes e) =>
          e.name == ThemeProvider.themeOf(context).id);
}
