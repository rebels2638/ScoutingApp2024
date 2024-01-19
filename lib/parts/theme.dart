import 'package:flutter/material.dart';
import 'package:scouting_app_2024/parts/color_schemes.g.dart';
import 'package:theme_provider/theme_provider.dart';

final class ThemeBlob {
  static List<AppTheme> export() => <AppTheme>[
        AppTheme(
            id: "default_dark",
            description: "Default Dark Theme",
            data: ThemeData(
                useMaterial3: true,
                fontFamily: "IBM Plex Sans",
                colorScheme: darkColorScheme)),
        AppTheme(
            id: "default_light",
            description: "Default Light Theme",
            data: ThemeData(
                useMaterial3: true,
                fontFamily: "IBM Plex Sans",
                colorScheme: lightColorScheme))
      ];
}
