import 'package:community_material_icon/community_material_icon.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scouting_app_2024/blobs/blobs.dart';
import 'package:scouting_app_2024/parts/bits/show_console.dart';
import 'package:scouting_app_2024/parts/bits/show_experimental.dart';
import 'package:scouting_app_2024/parts/bits/show_fps_monitor.dart';
import 'package:scouting_app_2024/parts/bits/show_game_map.dart';
import 'package:scouting_app_2024/parts/bits/show_pastmatches_lockedin.dart';
import 'package:scouting_app_2024/parts/theme.dart';
import 'package:scouting_app_2024/parts/views_delegate.dart';
import 'package:scouting_app_2024/user/user_telemetry.dart';
import 'package:theme_provider/theme_provider.dart';

class SettingsView extends StatelessWidget
    implements AppPageViewExporter {
  const SettingsView({super.key});

  @pragma("vm:prefer-inline")
  static Widget _labelIt(
          {IconData? icon,
          required String label,
          String? hint,
          required Widget child}) =>
      Padding(
        padding: const EdgeInsets.all(15),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    if (icon != null) Icon(icon, size: 40),
                    strut(width: 22),
                    if (hint == null)
                      Text(label,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold))
                    else
                      Text.rich(TextSpan(children: <InlineSpan>[
                        TextSpan(
                            text: "$label\n",
                            style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold)),
                        TextSpan(
                            text: hint,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w300,
                            ))
                      ]))
                  ]),
              child
            ]),
      );

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          FilledButton.tonalIcon(
              style: ThemeBlob.exportBtnBlobStyle(),
              onPressed: () {
                UserTelemetry().save();
                ScaffoldMessenger.of(context).showSnackBar(
                    yummySnackBar(
                        duration: const Duration(milliseconds: 1500),
                        margin: null,
                        width: 300,
                        icon: Icon(Icons.save_rounded,
                            color: ThemeProvider.themeOf(context)
                                .data
                                .colorScheme
                                .background),
                        backgroundColor:
                            ThemeProvider.themeOf(context)
                                .data
                                .colorScheme
                                .primary,
                        message: "Settings Saved!"));
              },
              icon: const Icon(Icons.save_alt_rounded),
              label: const Text("Save Settings")),
          SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.all(26.0),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: strutAll(<Widget>[
                    _labelIt(
                        icon: Icons.history_rounded,
                        label: "Show Past Matches Locked In",
                        hint:
                            "While locked in, you are still able to view past matches",
                        child: BasicToggleSwitch(
                            initialValue: UserTelemetry()
                                .currentModel
                                .showPastMatchesWhileLockedIn,
                            onChanged: (bool val) {
                              Provider.of<ShowPastMatchesWhileLockedInModal>(
                                          context,
                                          listen: false)
                                      .showingPastMatchesWhileLockedIn =
                                  val;
                              UserTelemetry()
                                  .currentModel
                                  .showPastMatchesWhileLockedIn = val;
                              UserTelemetry().save();
                            })),
                    _labelIt(
                        icon: Icons.terminal_rounded,
                        label: "Show Development Console",
                        hint:
                            "A page for debug and development purposes",
                        child: BasicToggleSwitch(
                            initialValue: UserTelemetry()
                                .currentModel
                                .showConsole, // i feel like we could somehow combine it with the preceding Provider.of because both are going to traverse the tree anyways
                            onChanged: (bool val) {
                              Provider.of<ShowConsoleModal>(context,
                                      listen: false)
                                  .showingConsole = val;
                              UserTelemetry()
                                  .currentModel
                                  .showConsole = val;
                              UserTelemetry().save();
                            })),
                    _labelIt(
                        icon: Icons.map,
                        label: "Show Game Map",
                        hint:
                            "This page shows an overview of the game",
                        child: BasicToggleSwitch(
                            initialValue: UserTelemetry()
                                .currentModel
                                .showGameMap,
                            onChanged: (bool val) {
                              Provider.of<ShowGameMapModal>(context,
                                      listen: false)
                                  .showingGameMap = val;
                              UserTelemetry()
                                  .currentModel
                                  .showGameMap = val;
                              UserTelemetry().save();
                            })),
                    _labelIt(
                        icon: CommunityMaterialIcons.chemical_weapon,
                        label: "Show Experimental Elements",
                        hint:
                            "Use with caution, enables experimental features",
                        child: BasicToggleSwitch(
                            initialValue: UserTelemetry()
                                .currentModel
                                .showExperimental,
                            onChanged: (bool val) {
                              Provider.of<ShowExperimentalModal>(
                                      context,
                                      listen: false)
                                  .showingExperimental = val;
                              UserTelemetry()
                                  .currentModel
                                  .showExperimental = val;
                              UserTelemetry().save();
                            })),
                    _labelIt(
                        icon: Icons.numbers_rounded,
                        label: "Show FPS Monitor",
                        hint:
                            "Enables a FPS monitor in the top left corner of the screen",
                        child: BasicToggleSwitch(
                            initialValue: UserTelemetry()
                                .currentModel
                                .showFPSMonitor,
                            onChanged: (bool val) {
                              Provider.of<ShowFPSMonitorModal>(
                                      context,
                                      listen: false)
                                  .showingFPSMonitor = val;
                              UserTelemetry()
                                  .currentModel
                                  .showFPSMonitor = val;
                              UserTelemetry().save();
                            })),
                  ], height: 16)),
            ),
          ),
        ],
      ),
    );
  }

  @override
  ({
    Widget child,
    ({Icon activeIcon, Icon icon, String label, String tooltip}) item
  }) exportAppPageView() {
    return (
      child: this,
      item: (
        activeIcon: const Icon(Icons.settings_applications_rounded),
        icon: const Icon(Icons.settings_applications_outlined),
        label: "Settings",
        tooltip: "Configure preferences for the application"
      )
    );
  }
}
