import 'package:flutter/material.dart';
import 'package:scouting_app_2024/parts/color_schemes.g.dart';
import 'package:theme_provider/theme_provider.dart';

class ThemeClassifier {
  static AvaliableThemes of(BuildContext context) {
    String name = ThemeProvider.themeOf(context).id;
    for (AvaliableThemes e in AvaliableThemes.values) {
      if (e.name == name) {
        return e;
      }
    }
    return AvaliableThemes.values[0];
  }
}

enum AvaliableThemes {
  light_teal("Light Teal", false),
  dark_teal("Dark Teal"),
  light_peach("Light Peach", false),
  dark_peach("Dark Peach");

  final String properName;
  final bool isDarkMode;

  const AvaliableThemes(this.properName, [this.isDarkMode = true]);
}

final class ThemeBlob {
  static List<AppTheme> export() => <AppTheme>[
        AppTheme(
            id: AvaliableThemes.light_teal.name,
            description: "Light Teal Theme",
            data: ThemeData(
                useMaterial3: true,
                fontFamily: "IBM Plex Sans",
                colorScheme: lightColorScheme)),
        AppTheme(
            id: AvaliableThemes.dark_teal.name,
            description: "Dark Teal Theme",
            data: ThemeData(
                useMaterial3: true,
                fontFamily: "IBM Plex Sans",
                colorScheme: darkColorScheme)),
        AppTheme(
            id: AvaliableThemes.light_peach.name,
            description: "Light Peach Theme",
            data: ThemeData(
                useMaterial3: true,
                fontFamily: "IBM Plex Sans",
                colorScheme: lightColorScheme2)),
        AppTheme(
            id: AvaliableThemes.dark_peach.name,
            description: "Dark Peach Theme",
            data: ThemeData(
                useMaterial3: true,
                fontFamily: "IBM Plex Sans",
                colorScheme: darkColorScheme2))
      ];
}
