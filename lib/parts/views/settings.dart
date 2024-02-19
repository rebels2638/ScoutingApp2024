import 'package:community_material_icon/community_material_icon.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scouting_app_2024/blobs/blobs.dart';
import 'package:scouting_app_2024/parts/bits/prefer_canonical.dart';
import 'package:scouting_app_2024/parts/bits/prefer_compact.dart';
import 'package:scouting_app_2024/parts/bits/prefer_tonal.dart';
import 'package:scouting_app_2024/parts/bits/show_console.dart';
import 'package:scouting_app_2024/parts/bits/show_experimental.dart';
import 'package:scouting_app_2024/parts/bits/show_fps_monitor.dart';
import 'package:scouting_app_2024/parts/bits/show_game_map.dart';
import 'package:scouting_app_2024/parts/bits/use_alt_layout.dart';
import 'package:scouting_app_2024/parts/views_delegate.dart';
import 'package:scouting_app_2024/user/user_telemetry.dart';
import 'package:theme_provider/theme_provider.dart';

import '../../blobs/basic_toggle_switch.dart';

class SettingsView extends StatefulWidget
    implements AppPageViewExporter {
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
              // this might need fixing if we ever need to support phones fully
              Wrap(children: <Widget>[
                if (icon != null) Icon(icon, size: 40),
                const SizedBox(width: 22),
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
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(
          parent: BouncingScrollPhysics()),
      child: Column(
        children: <Widget>[
          Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                AnimatedSwitcher(
                    transitionBuilder:
                        (Widget child, Animation<double> animation) {
                      return ScaleTransition(
                          scale: animation, child: child);
                    },
                    duration: const Duration(milliseconds: 300),
                    switchInCurve: Curves.ease,
                    switchOutCurve: Curves.ease,
                    child: !PreferCompactModal.isCompactPreferred(
                            context)
                        ? // i could reverse the values, but thats just too many ctrl+c ctrl+v
                        preferTonalButton(
                            onPressed: () => launchConfirmDialog(
                                    context,
                                    message: const Text(
                                        "Are you sure you want to reset all user telemetry? This means all of your usage statistics will be removed. However, your scouting data will not be."),
                                    onConfirm: () {
                                  UserTelemetry().reset();
                                  UserTelemetry().resetHard();
                                  UserTelemetry().save();
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(yummySnackBar(
                                          duration: const Duration(
                                              milliseconds: 1500),
                                          margin: null,
                                          width: 300,
                                          icon: Icon(
                                              Icons.save_rounded,
                                              color: ThemeProvider
                                                      .themeOf(
                                                          context)
                                                  .data
                                                  .colorScheme
                                                  .background),
                                          backgroundColor:
                                              ThemeProvider.themeOf(
                                                      context)
                                                  .data
                                                  .colorScheme
                                                  .primary,
                                          message:
                                              "Settings Reset!"));
                                }),
                            icon: const Icon(Icons.replay_rounded),
                            label: const Text("Reset Telemetry"))
                        : FilledButton(
                            onPressed: () => launchConfirmDialog(
                                    context,
                                    message: const Text(
                                        "Are you sure you want to reset all user telemetry? This means all of your usage statistics will be removed. However, your scouting data will not be."),
                                    onConfirm: () {
                                  UserTelemetry().reset();
                                  UserTelemetry().resetHard();
                                  UserTelemetry().save();
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(yummySnackBar(
                                          duration: const Duration(
                                              milliseconds: 1500),
                                          margin: null,
                                          width: 300,
                                          icon: Icon(
                                              Icons.save_rounded,
                                              color: ThemeProvider
                                                      .themeOf(
                                                          context)
                                                  .data
                                                  .colorScheme
                                                  .background),
                                          backgroundColor:
                                              ThemeProvider.themeOf(
                                                      context)
                                                  .data
                                                  .colorScheme
                                                  .primary,
                                          message:
                                              "Settings Reset!"));
                                }),
                            child: const Icon(Icons.replay_rounded))),
                if (ShowConsoleModal.isShowingConsole(context))
                  const SizedBox(width: 12),
                if (ShowConsoleModal.isShowingConsole(context))
                  AnimatedSwitcher(
                      transitionBuilder: (Widget child,
                          Animation<double> animation) {
                        return ScaleTransition(
                            scale: animation, child: child);
                      },
                      duration: const Duration(milliseconds: 300),
                      switchInCurve: Curves.ease,
                      switchOutCurve: Curves.ease,
                      child: !PreferCompactModal.isCompactPreferred(
                              context)
                          ? preferTonalButton(
                              onPressed: () {
                                UserTelemetry().save();
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(yummySnackBar(
                                        duration: const Duration(
                                            milliseconds: 1500),
                                        margin: null,
                                        width: 300,
                                        icon: Icon(Icons.save_rounded,
                                            color: ThemeProvider
                                                    .themeOf(context)
                                                .data
                                                .colorScheme
                                                .background),
                                        backgroundColor:
                                            ThemeProvider.themeOf(
                                                    context)
                                                .data
                                                .colorScheme
                                                .primary,
                                        message: "Settings Saved!"));
                              },
                              icon:
                                  const Icon(Icons.save_alt_rounded),
                              label: const Text("Save Settings"))
                          : FilledButton(
                              onPressed: () {
                                UserTelemetry().save();
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(yummySnackBar(
                                        duration: const Duration(
                                            milliseconds: 1500),
                                        margin: null,
                                        width: 300,
                                        icon: Icon(Icons.save_rounded,
                                            color: ThemeProvider
                                                    .themeOf(context)
                                                .data
                                                .colorScheme
                                                .background),
                                        backgroundColor:
                                            ThemeProvider.themeOf(
                                                    context)
                                                .data
                                                .colorScheme
                                                .primary,
                                        message: "Settings Saved!"));
                              },
                              child: const Icon(
                                  Icons.save_alt_rounded))),
                const SizedBox(width: 12),
                AnimatedSwitcher(
                    transitionBuilder:
                        (Widget child, Animation<double> animation) {
                      return ScaleTransition(
                          scale: animation, child: child);
                    },
                    duration: const Duration(milliseconds: 300),
                    switchInCurve: Curves.ease,
                    switchOutCurve: Curves.ease,
                    child: !PreferCompactModal.isCompactPreferred(
                            context)
                        ? preferTonalButton(
                            onPressed: () async {
                              await launchConfirmDialog(context,
                                  message: Text(UserTelemetry()
                                      .currentModel
                                      .toJson()
                                      .toString()),
                                  onConfirm: () {});
                            },
                            icon: const Icon(
                                Icons.developer_mode_rounded),
                            label: const Text("DEV_VIEW_RAW"))
                        : FilledButton(
                            onPressed: () async {
                              await launchConfirmDialog(context,
                                  message: Text(UserTelemetry()
                                      .currentModel
                                      .toJson()
                                      .toString()),
                                  onConfirm: () {});
                            },
                            child: const Icon(
                                Icons.developer_mode_rounded)))
              ]),
          SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.only(
                  top: 26.0, left: 26, right: 26, bottom: 64),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: strutAll(<Widget>[
                    SettingsView._labelIt(
                        icon: CommunityMaterialIcons.material_design,
                        label: "Prefer Tonal Components",
                        hint:
                            "Tries to use a less sharp color design.",
                        child: BasicToggleSwitch(
                            initialValue: UserTelemetry()
                                .currentModel
                                .preferTonal,
                            onChanged: (bool val) => setState(() {
                                  Provider.of<PreferTonalModal>(
                                          context,
                                          listen: false)
                                      .preferTonal = val;
                                  UserTelemetry()
                                      .currentModel
                                      .preferTonal = val;
                                  UserTelemetry().save();
                                }))),
                    SettingsView._labelIt(
                        icon: CommunityMaterialIcons.book_account,
                        label: "Use canonical components",
                        hint:
                            "Use team colors and other \"FRC\" related styling",
                        child: BasicToggleSwitch(
                            initialValue: UserTelemetry()
                                .currentModel
                                .preferCanonical,
                            onChanged: (bool val) => setState(() {
                                  Provider.of<PreferCanonicalModal>(
                                          context,
                                          listen: false)
                                      .preferCanonical = val;
                                  UserTelemetry()
                                      .currentModel
                                      .preferCanonical = val;
                                  UserTelemetry().save();
                                }))),
                    SettingsView._labelIt(
                        icon: CommunityMaterialIcons.nuke, // lmao
                        label: "Compact layout",
                        hint:
                            "Some UI elements will be swapped out for icon only versions",
                        child: BasicToggleSwitch(
                            initialValue: UserTelemetry()
                                .currentModel
                                .preferCompact,
                            onChanged: (bool val) => setState(() {
                                  Provider.of<PreferCompactModal>(
                                          context,
                                          listen: false)
                                      .preferCompact = val;
                                  UserTelemetry()
                                      .currentModel
                                      .preferCompact = val;
                                  UserTelemetry().save();
                                }))),
                    SettingsView._labelIt(
                        icon: CommunityMaterialIcons.layers_outline,
                        label: "Use Alternative Layout",
                        hint:
                            "Certain UI elements will be laid out differently",
                        child: BasicToggleSwitch(
                            initialValue: UserTelemetry()
                                .currentModel
                                .useAltLayout,
                            onChanged: (bool val) => setState(() {
                                  Provider.of<UseAlternativeLayoutModal>(
                                          context,
                                          listen: false)
                                      .useAlt = val;
                                  UserTelemetry()
                                      .currentModel
                                      .useAltLayout = val;
                                  UserTelemetry().save();
                                }))),
                    SettingsView._labelIt(
                        icon: Icons.terminal_rounded,
                        label: "Show Development Tools",
                        hint:
                            "Opens up certain development tools for debugging and testing",
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
                    SettingsView._labelIt(
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
                    SettingsView._labelIt(
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
                    SettingsView._labelIt(
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
}
