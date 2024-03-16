import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:scouting_app_2024/debug.dart';
import 'package:scouting_app_2024/parts/app_setup_view.dart';
import 'package:scouting_app_2024/parts/appview.dart';
import 'package:scouting_app_2024/parts/bits/appbar_celebrate.dart';
import 'package:scouting_app_2024/parts/bits/duc_bit.dart';
import 'package:scouting_app_2024/parts/bits/lock_in.dart';
import 'package:scouting_app_2024/parts/bits/prefer_canonical.dart';
import 'package:scouting_app_2024/parts/bits/prefer_compact.dart';
import 'package:scouting_app_2024/parts/bits/prefer_tonal.dart';
import 'package:scouting_app_2024/parts/bits/seen_patchnotes.dart';
import 'package:scouting_app_2024/parts/bits/show_console.dart';
import 'package:scouting_app_2024/parts/bits/show_experimental.dart';
import 'package:scouting_app_2024/parts/bits/show_fps_monitor.dart';
import 'package:scouting_app_2024/parts/bits/show_hints.dart';
import 'package:scouting_app_2024/parts/bits/show_scrollbar.dart';
import 'package:scouting_app_2024/parts/bits/theme_mode.dart';
import 'package:scouting_app_2024/parts/bits/use_alt_layout.dart';
import 'package:scouting_app_2024/parts/theme.dart';
import 'package:scouting_app_2024/user/duc_telemetry.dart';
import 'package:scouting_app_2024/user/user_telemetry.dart';
import 'package:theme_provider/theme_provider.dart';

class ThemedAppBundle extends StatelessWidget {
  final Widget child;

  const ThemedAppBundle(
      {super.key, this.child = const IntermediateMaterialApp()});

  @override
  Widget build(BuildContext context) {
    Debug().info("ThemesLoaded: ${<AppTheme>[
      ...ThemeBlob.export,
      ...ThemeBlob.intricateThemes
    ].length}");
    Debug().watchdog(
        "Received pArmed=${UserTelemetry().currentModel.profileArmed}");
    return _Bundler(
        // dont care about the ternary bullshit crap of a repetitve shit it is
        // fuck it, u want to refactor it? well it works fine, fuck your morals!
        child: UserTelemetry().currentModel.profileArmed
            ? Builder(
                builder: (BuildContext
                        themeCtxt) => /*lol this is very scuffed XD i hope you can forgive me*/
                    MultiProvider(providers: <SingleChildWidget>[
                      ChangeNotifierProvider<ShowScrollBarModal>(
                          create: (BuildContext _) =>
                              ShowScrollBarModal()),
                      ChangeNotifierProvider<SeenPatchNotesModal>(
                          create: (BuildContext _) =>
                              SeenPatchNotesModal()),
                      ChangeNotifierProvider<ShowHintsGuideModal>(
                          create: (BuildContext _) =>
                              ShowHintsGuideModal()),
                      ChangeNotifierProvider<DucBaseBit>(
                          create: (BuildContext _) => DucBaseBit(
                              DucTelemetry()
                                  .allHollisticEntries)), // loaded cuz fuck yes >:)
                      ChangeNotifierProvider<AppBarCelebrationModal>(
                          create: (BuildContext _) =>
                              AppBarCelebrationModal()),
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
                      ChangeNotifierProvider<ThemeModeModal>(
                          create: (BuildContext _) =>
                              ThemeModeModal()),
                      ChangeNotifierProvider<ShowConsoleModal>(
                          create: (BuildContext _) =>
                              ShowConsoleModal()),
                      ChangeNotifierProvider<LockedInScoutingModal>(
                          create: (BuildContext _) =>
                              LockedInScoutingModal())
                    ], child: child))
            : AppSetupView(
                routineChild: Builder(
                    builder: (BuildContext
                            themeCtxt) => /*lol this is very scuffed XD i hope you can forgive me*/
                        MultiProvider(providers: <SingleChildWidget>[
                          ChangeNotifierProvider<ShowScrollBarModal>(
                              create: (BuildContext _) =>
                                  ShowScrollBarModal()),
                          ChangeNotifierProvider<SeenPatchNotesModal>(
                              create: (BuildContext _) =>
                                  SeenPatchNotesModal()),
                          ChangeNotifierProvider<ShowHintsGuideModal>(
                              create: (BuildContext _) =>
                                  ShowHintsGuideModal()),
                          ChangeNotifierProvider<DucBaseBit>(
                              create: (BuildContext _) => DucBaseBit(
                                  DucTelemetry()
                                      .allHollisticEntries)), // loaded cuz fuck yes >:)
                          ChangeNotifierProvider<
                                  AppBarCelebrationModal>(
                              create: (BuildContext _) =>
                                  AppBarCelebrationModal()),
                          ChangeNotifierProvider<PreferCompactModal>(
                              create: (BuildContext _) =>
                                  PreferCompactModal()),
                          ChangeNotifierProvider<
                                  UseAlternativeLayoutModal>(
                              create: (BuildContext _) =>
                                  UseAlternativeLayoutModal()),
                          ChangeNotifierProvider<
                                  PreferCanonicalModal>(
                              create: (BuildContext _) =>
                                  PreferCanonicalModal()),
                          ChangeNotifierProvider<PreferTonalModal>(
                              create: (BuildContext _) =>
                                  PreferTonalModal()),
                          ChangeNotifierProvider<ShowFPSMonitorModal>(
                              create: (BuildContext _) =>
                                  ShowFPSMonitorModal()),
                          ChangeNotifierProvider<
                                  ShowExperimentalModal>(
                              create: (BuildContext _) =>
                                  ShowExperimentalModal()),
                          ChangeNotifierProvider<ThemeModeModal>(
                              create: (BuildContext _) =>
                                  ThemeModeModal()),
                          ChangeNotifierProvider<ShowConsoleModal>(
                              create: (BuildContext _) =>
                                  ShowConsoleModal()),
                          ChangeNotifierProvider<
                                  LockedInScoutingModal>(
                              create: (BuildContext _) =>
                                  LockedInScoutingModal())
                        ], child: child))));
  }
}

class _Bundler extends StatelessWidget {
  final Widget child;

  const _Bundler({required this.child});

  @override
  Widget build(BuildContext context) {
    return ThemeProvider(themes: <AppTheme>[
      ...ThemeBlob.export,
      ...ThemeBlob.intricateThemes
    ], child: ThemeConsumer(child: child));
  }
}
