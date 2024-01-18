import 'package:flutter/material.dart';
import 'package:theme_provider/theme_provider.dart';

final class ThemeBlob {
  static List<AppTheme> export() => <AppTheme>[
        AppTheme(
            id: "default_teal",
            description: "Default Teal Theme",
            data: ThemeData(
                useMaterial3: true,
                fontFamily: "IBM Plex Sans",
                primaryColor: Colors.teal.shade300)),
        AppTheme(
            id: "default_light",
            description: "Default Orange Theme",
            data: ThemeData(
                useMaterial3: true,
                fontFamily: "IBM Plex Sans",
                primaryColor: Colors.orange.shade400))
      ];
}

