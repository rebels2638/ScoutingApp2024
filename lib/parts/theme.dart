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
  default_light("Default Light", false),
  default_dark("Default Dark"),
  mint("Mint", false),
  forest("Forest"),
  peach("Peach", false),
  plum("Plum");


  final String properName;
  final bool isDarkMode;

  const AvaliableThemes(this.properName, [this.isDarkMode = true]);
}

final class ThemeBlob {
  static List<AppTheme> export() => <AppTheme>[
        AppTheme(
            id: AvaliableThemes.default_dark.name,
            description: "Default Dark Theme",
            data: ThemeData(
                useMaterial3: true,
                fontFamily: "IBM Plex Sans",
                colorScheme: darkColorScheme3)),
        AppTheme(
            id: AvaliableThemes.default_light.name,
            description: "Default Light Theme",
            data: ThemeData(
                useMaterial3: true,
                fontFamily: "IBM Plex Sans",
                colorScheme: lightColorScheme3)),
        
        AppTheme(
            id: AvaliableThemes.mint.name,
            description: "Mint Theme",
            data: ThemeData(
                useMaterial3: true,
                fontFamily: "IBM Plex Sans",
                colorScheme: lightColorScheme)),
        AppTheme(
            id: AvaliableThemes.forest.name,
            description: "Forest Theme",
            data: ThemeData(
                useMaterial3: true,
                fontFamily: "IBM Plex Sans",
                colorScheme: darkColorScheme)),
        AppTheme(
            id: AvaliableThemes.peach.name,
            description: "Peach Theme",
            data: ThemeData(
                useMaterial3: true,
                fontFamily: "IBM Plex Sans",
                colorScheme: lightColorScheme2)),
        AppTheme(
            id: AvaliableThemes.plum.name,
            description: "Plum Theme",
            data: ThemeData(
                useMaterial3: true,
                fontFamily: "IBM Plex Sans",
                colorScheme: darkColorScheme2)),

      ];
}
