import 'package:flutter/material.dart';
import 'package:scouting_app_2024/parts/theme.dart';
import 'package:theme_provider/theme_provider.dart';

mixin ThemeClassifier {
  static AvailableTheme of(BuildContext context) {
    String name = ThemeProvider.themeOf(context).id;
    for (AvailableTheme e in AvailableTheme.export) {
      if (e.id == name) {
        return e;
      }
    }
    return AvailableTheme.export[0];
  }
}
