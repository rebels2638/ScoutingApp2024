import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:scouting_app_2024/debug.dart';
import 'package:scouting_app_2024/parts/bits/lock_in.dart';
import 'package:scouting_app_2024/parts/bits/prefer_canonical.dart';
import 'package:scouting_app_2024/parts/bits/prefer_compact.dart';
import 'package:scouting_app_2024/parts/bits/prefer_tonal.dart';
import 'package:scouting_app_2024/parts/bits/show_console.dart';
import 'package:scouting_app_2024/parts/bits/show_experimental.dart';
import 'package:scouting_app_2024/parts/bits/show_fps_monitor.dart';
import 'package:scouting_app_2024/parts/bits/show_game_map.dart';
import 'package:scouting_app_2024/parts/bits/theme_mode.dart';
import 'package:scouting_app_2024/parts/bits/use_alt_layout.dart';
import 'package:scouting_app_2024/parts/theme.dart';
import 'package:theme_provider/theme_provider.dart';

class ThemedAppBundle extends StatelessWidget {
  final Widget child;

  const ThemedAppBundle({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    Debug().info("ThemesLoaded: ${<AppTheme>[
      ...ThemeBlob.export,
      ...ThemeBlob.intricateThemes
    ].length}");
    return ThemeProvider(
        themes: <AppTheme>[
          ...ThemeBlob.export,
          ...ThemeBlob.intricateThemes
        ],
        child: ThemeConsumer(
            child: Builder(
                builder: (BuildContext
                        themeCtxt) => /*lol this is very scuffed XD i hope you can forgive me*/
                    MultiProvider(providers: <SingleChildWidget>[
                      ChangeNotifierProvider<PreferCompactModal>(
                          create: (BuildContext _) =>
                              PreferCompactModal()),
                      ChangeNotifierProvider<
                              UseAlternativeLayoutModal>(
                          create: (BuildContext _) =>
                              UseAlternativeLayoutModal()),
                      ChangeNotifierProvider<PreferCanonicalModal>(
                          create: (BuildContext _) =>
                              PreferCanonicalModal()),
                      ChangeNotifierProvider<PreferTonalModal>(
                          create: (BuildContext _) =>
                              PreferTonalModal()),
                      ChangeNotifierProvider<ShowFPSMonitorModal>(
                          create: (BuildContext _) =>
                              ShowFPSMonitorModal()),
                      ChangeNotifierProvider<ShowExperimentalModal>(
                          create: (BuildContext _) =>
                              ShowExperimentalModal()),
                      ChangeNotifierProvider<ShowGameMapModal>(
                          create: (BuildContext _) =>
                              ShowGameMapModal()),
                      ChangeNotifierProvider<ThemeModeModal>(
                          create: (BuildContext _) =>
                              ThemeModeModal()),
                      ChangeNotifierProvider<ShowConsoleModal>(
                          create: (BuildContext _) =>
                              ShowConsoleModal()),
                      ChangeNotifierProvider<LockedInScoutingModal>(
                          create: (BuildContext _) =>
                              LockedInScoutingModal())
                    ], child: child))));
  }
}
