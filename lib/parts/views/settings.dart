import 'package:community_material_icon/community_material_icon.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scouting_app_2024/blobs/blobs.dart';
import 'package:scouting_app_2024/parts/appview.dart';
import "package:scouting_app_2024/parts/bits/prefer_canonical.dart";
import 'package:scouting_app_2024/parts/bits/prefer_compact.dart';
import 'package:scouting_app_2024/parts/bits/prefer_tonal.dart';
import 'package:scouting_app_2024/parts/bits/show_console.dart';
import 'package:scouting_app_2024/parts/bits/show_experimental.dart';
import 'package:scouting_app_2024/parts/bits/show_fps_monitor.dart';
import 'package:scouting_app_2024/parts/bits/show_hints.dart';
import 'package:scouting_app_2024/parts/bits/show_legacy_items.dart';
import 'package:scouting_app_2024/parts/bits/show_scrollbar.dart';
import 'package:scouting_app_2024/parts/bits/use_alt_layout.dart';
import 'package:scouting_app_2024/parts/views_delegate.dart';
import 'package:scouting_app_2024/user/env.dart';
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

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsLabeledItem extends StatelessWidget {
  const _SettingsLabeledItem({
    required this.icon,
    required this.label,
    required this.hint,
    required this.child,
  });

  final IconData? icon;
  final String label;
  final String? hint;
  final Widget child;

  @override
  Widget build(BuildContext context) => Center(
        child: Row(children: <Widget>[
          if (!DeviceEnv.isPhone) const Spacer(flex: 2),
          // this might need fixing if we ever need to support phones fully
          if (icon != null) FittedBox(child: Icon(icon, size: 34)),
          const SizedBox(width: 18),
          child,
          const SizedBox(width: 18),
          Flexible(
              flex: 2,
              child: hint == null
                  ? Text(label,
                      softWrap: true,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold))
                  : Text.rich(
                      TextSpan(children: <InlineSpan>[
                        TextSpan(
                            text: "$label\n",
                            style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold)),
                        TextSpan(
                            text: hint,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w300,
                            ))
                      ]),
                      softWrap: true)),
          if (!DeviceEnv.isPhone) const Spacer(flex: 2),
        ]),
      );
}

class _SettingsViewState extends State<SettingsView> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(
          parent: BouncingScrollPhysics()),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Wrap(
              alignment: WrapAlignment.center,
              runSpacing: 4,
              spacing: 6,
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
                            onPressed:
                                () => launchConfirmDialog(context,
                                        message: const Text(
                                            "Are you sure you want to reset all user telemetry? This means all of your usage statistics will be removed. However, your scouting data will not be."),
                                        onConfirm: () {
                                      UserTelemetry().reset();
                                      UserTelemetry().resetHard();
                                      UserTelemetry().save();
                                      ScaffoldMessenger.of(
                                              globalScaffoldKey
                                                  .currentState!
                                                  .context)
                                          .showSnackBar(yummySnackBar(
                                              duration:
                                                  const Duration(
                                                      milliseconds:
                                                          1500),
                                              margin: null,
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
                            onPressed:
                                () => launchConfirmDialog(context,
                                        message:
                                            const Text("Are you sure you want to reset all user telemetry? This means all of your usage statistics will be removed. However, your scouting data will not be."),
                                        onConfirm: () {
                                      UserTelemetry().reset();
                                      UserTelemetry().resetHard();
                                      UserTelemetry().save();
                                      ScaffoldMessenger.of(
                                              globalScaffoldKey
                                                  .currentState!
                                                  .context)
                                          .showSnackBar(yummySnackBar(
                                              duration:
                                                  const Duration(
                                                      milliseconds:
                                                          1500),
                                              margin: null,
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
                            onPressed: () {
                              UserTelemetry().save();
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(yummySnackBar(
                                      duration: const Duration(
                                          milliseconds: 1500),
                                      margin: null,
                                      icon: Icon(Icons.save_rounded,
                                          color:
                                              ThemeProvider.themeOf(
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
                                      message: "Settings Saved!"));
                            },
                            icon: const Icon(Icons.save_alt_rounded),
                            label: const Text("Save Settings"))
                        : FilledButton(
                            onPressed: () {
                              UserTelemetry().save();
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(yummySnackBar(
                                      duration: const Duration(
                                          milliseconds: 1500),
                                      margin: null,
                                      icon: Icon(Icons.save_rounded,
                                          color:
                                              ThemeProvider.themeOf(
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
                                      message: "Settings Saved!"));
                            },
                            child:
                                const Icon(Icons.save_alt_rounded))),
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
                  top: 26.0, left: 12, right: 12, bottom: 64),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: strutAll(<Widget>[
                        _SettingsLabeledItem(
                            icon: CommunityMaterialIcons
                                .chemical_weapon,
                            label: "Scouting Leader Mode",
                            hint:
                                "Enables the DUC collection tool for scouting leaders",
                            child: BasicToggleSwitch(
                                initialValue: UserTelemetry()
                                    .currentModel
                                    .showExperimental,
                                onChanged: (bool val) {
                                  Provider.of<ShowExperimentalModal>(
                                              context,
                                              listen: false)
                                          .showingExperimental =
                                      val; // the name is going to be off, but who cares lmao
                                  UserTelemetry()
                                      .currentModel
                                      .showExperimental = val;
                                  UserTelemetry().save();
                                })),
                        _SettingsLabeledItem(
                            icon: CommunityMaterialIcons
                                .material_design,
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
                        _SettingsLabeledItem(
                            icon: CommunityMaterialIcons
                                .gesture_swipe_vertical,
                            label: "Show Scroll Bars",
                            hint:
                                "Makes scroll bars on certain pages disappear or appear (requires restart)",
                            child: BasicToggleSwitch(
                                initialValue: UserTelemetry()
                                    .currentModel
                                    .showScrollbar,
                                onChanged: (bool val) {
                                  Provider.of<ShowScrollBarModal>(
                                              context,
                                              listen: false)
                                          .showingScrollbar =
                                      val; // the name is going to be off, but who cares lmao
                                  UserTelemetry()
                                      .currentModel
                                      .showScrollbar = val;
                                  UserTelemetry().save();
                                })),
                        _SettingsLabeledItem(
                            icon: Icons.history_rounded,
                            label: "Show Legacy Items",
                            hint:
                                "Certain app features that were once deprecated will be shown again. Use with caution",
                            child: BasicToggleSwitch(
                                initialValue: UserTelemetry()
                                    .currentModel
                                    .showLegacyItems,
                                onChanged: (bool val) {
                                  if (val) {
                                    launchInformDialog(
                                      context,
                                      title: "Warning!",
                                      message: const Text.rich(
                                          TextSpan(
                                              children: <InlineSpan>[
                                            TextSpan(
                                                text:
                                                    "Legacy components are "),
                                            TextSpan(
                                                text: "deprecated",
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight
                                                            .bold)),
                                            TextSpan(
                                                text:
                                                    ". They are not guaranteed to work properly and may be removed in the future!"),
                                          ])),
                                    );
                                  }
                                  Provider.of<ShowLegacyItemsModal>(
                                          context,
                                          listen: false)
                                      .showingLegacyItems = val;
                                  UserTelemetry()
                                      .currentModel
                                      .showLegacyItems = val;
                                  UserTelemetry().save();
                                })),
                        _SettingsLabeledItem(
                            icon: CommunityMaterialIcons
                                .skull_crossbones_outline,
                            label: "Show Hints",
                            hint:
                                "Allows the application to show hints and tips to the user",
                            child: BasicToggleSwitch(
                                initialValue: UserTelemetry()
                                    .currentModel
                                    .showHints,
                                onChanged: (bool val) {
                                  Provider.of<ShowHintsGuideModal>(
                                          context,
                                          listen: false)
                                      .showingHints = val;
                                  UserTelemetry()
                                      .currentModel
                                      .showHints = val;
                                  UserTelemetry().save();
                                })),
                        _SettingsLabeledItem(
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
                        _SettingsLabeledItem(
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
                        _SettingsLabeledItem(
                            icon:
                                CommunityMaterialIcons.layers_outline,
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
                        _SettingsLabeledItem(
                            icon: Icons.terminal_rounded,
                            label: "Show Development Tools",
                            hint:
                                "Opens up certain development tools for debugging and testing",
                            child: BasicToggleSwitch(
                                initialValue: UserTelemetry()
                                    .currentModel
                                    .showConsole, // i feel like we could somehow combine it with the preceding Provider.of because both are going to traverse the tree anyways
                                onChanged: (bool val) {
                                  Provider.of<ShowConsoleModal>(
                                          context,
                                          listen: false)
                                      .showingConsole = val;
                                  UserTelemetry()
                                      .currentModel
                                      .showConsole = val;
                                  UserTelemetry().save();
                                })),
                        _SettingsLabeledItem(
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
                      ], height: 38)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
