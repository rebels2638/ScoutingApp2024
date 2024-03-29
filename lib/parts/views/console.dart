import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scouting_app_2024/blobs/blobs.dart';
import 'package:scouting_app_2024/blobs/hints_blob.dart';
import 'package:scouting_app_2024/blobs/locale_blob.dart';
import 'package:scouting_app_2024/debug.dart';
import 'package:scouting_app_2024/parts/bits/show_hints.dart';
import 'package:scouting_app_2024/parts/views_delegate.dart';
import 'package:scouting_app_2024/shared.dart';
import 'package:scouting_app_2024/user/models/ephemeral_data.dart';
import 'package:scouting_app_2024/user/scouting_telemetry.dart';
import 'package:scouting_app_2024/user/user_telemetry.dart';
import 'package:theme_provider/theme_provider.dart';

class ConsoleView extends StatelessWidget
    implements AppPageViewExporter {
  const ConsoleView({super.key});

  @override
  Widget build(BuildContext context) {
    return _ConsoleComponent();
  }

  @override
  ({
    Widget child,
    ({Icon activeIcon, Icon icon, String label, String tooltip}) item
  }) exportAppPageView() {
    return (
      child: this,
      item: (
        activeIcon: const Icon(Icons.dataset_rounded),
        icon: const Icon(Icons.dataset_outlined),
        label: "Console",
        tooltip: "In app debug console"
      )
    );
  }
}

class _ConsoleComponent extends StatefulWidget {
  @override
  State<_ConsoleComponent> createState() => ConsoleStateComponent();
}

class ConsoleStateComponent extends State<_ConsoleComponent> {
  static final List<String> internalConsoleBuffer = <String>[];
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          if (ShowHintsGuideModal.isShowingHints(context))
            const ApexHintsBlob("Developer Section!",
                "This part of the app is designed for debugging and development purposes, so some features may compromise the app's stability."),
          const SizedBox(height: 14),
          Wrap(runSpacing: 6, spacing: 6, children: <Widget>[
            TextButton.icon(
                onPressed: () =>
                    setState(() => internalConsoleBuffer.clear()),
                icon: const Icon(Icons.cleaning_services_rounded),
                label: const Text("Clear",
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontFamily: "IBM Plex Mono"))),
            TextButton.icon(
                onPressed: () => setState(() {}),
                icon: const Icon(Icons.refresh_rounded),
                label: const Text("Refresh",
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontFamily: "IBM Plex Mono"))),
            TextButton.icon(
                onPressed: () async => await Clipboard.setData(
                    ClipboardData(
                        text: collateListString(
                            internalConsoleBuffer))),
                icon: const Icon(Icons.copy_all_rounded),
                label: const Text("Copy",
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontFamily: "IBM Plex Mono"))),
            TextButton.icon(
                onPressed: () => ScaffoldMessenger.of(context)
                    .showSnackBar(yummySnackBar(
                        margin: null,
                        backgroundColor:
                            ThemeProvider.themeOf(context)
                                .data
                                .colorScheme
                                .primary,
                        message: "Amogus",
                        icon: Icon(Icons.adb_rounded,
                            color: ThemeProvider.themeOf(context)
                                .data
                                .colorScheme
                                .background))),
                icon: const Icon(Icons.window_rounded),
                label: const Text("Yummy Regular",
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontFamily: "IBM Plex Mono"))),
            TextButton.icon(
                onPressed: () => ScaffoldMessenger.of(context)
                    .showSnackBar(yummyWarningSnackBar("Amogus")),
                icon: const Icon(Icons.window_rounded),
                label: const Text("Yummy Warning",
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontFamily: "IBM Plex Mono"))),
            TextButton.icon(
                onPressed: () => ScaffoldMessenger.of(context)
                    .showSnackBar(yummyDeadlySnackBar("Amogus")),
                icon: const Icon(Icons.window_rounded),
                label: const Text("Yummy Deadly",
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontFamily: "IBM Plex Mono"))),
            TextButton.icon(
                onPressed: () => launchConfirmDialog(context,
                    message: Container(
                      decoration: BoxDecoration(
                          color: ThemeProvider.themeOf(context)
                              .data
                              .colorScheme
                              .background
                              .withOpacity(0.8),
                          borderRadius: BorderRadius.circular(8)),
                      child: Column(
                        children: <Widget>[
                          TextButton.icon(
                              onPressed: () async =>
                                  await Clipboard.setData(
                                      ClipboardData(
                                          text: jsonEncode(
                                              UserTelemetry()
                                                  .currentModel
                                                  .toJson()))),
                              icon: const Icon(Icons.copy_rounded),
                              label: const Text("Copy",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontFamily: "IBM Plex Mono"))),
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Text(
                                jsonEncode(UserTelemetry()
                                    .currentModel
                                    .toJson()),
                                style: const TextStyle(
                                    fontFamily: "IBM Plex Mono",
                                    fontWeight: FontWeight.w600)),
                          ),
                        ],
                      ),
                    ),
                    title: "User Prefs RAW",
                    onConfirm: () {}),
                icon: const Icon(Icons.subscript_rounded),
                label: const Text("User Prefs",
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontFamily: "IBM Plex Mono"))),
            TextButton.icon(
                onPressed: () => launchNumberPickerDialog(context,
                    minValue: 0,
                    maxValue: 999,
                    headerMessage: "Number Picker (ig)",
                    onChange: (int res) {}),
                icon: const Icon(Icons.check_box_rounded),
                label: const Text("NumberPicker Dialog",
                    style: TextStyle(fontWeight: FontWeight.bold))),
            TextButton.icon(
                onPressed: () => launchConfirmDialog(context,
                    message: const Text("Debug Show CONFIRM_DIALOG"),
                    onConfirm: () {}),
                icon: const Icon(Icons.check_box_rounded),
                label: const Text("CONFIRM_DIALOG",
                    style: TextStyle(fontWeight: FontWeight.bold))),
            TextButton.icon(
                onPressed: () async =>
                    await launchAssuredConfirmDialog(context,
                        message: "TEST",
                        title: "TEST",
                        onConfirm: () {}),
                icon: const Icon(Icons.add_box_rounded),
                label: const Text("AssureInfBox",
                    style: TextStyle(fontWeight: FontWeight.bold))),
            TextButton.icon(
                onPressed: () => throw "Debug Error box.",
                icon:
                    const Icon(Icons.security_update_warning_rounded),
                label: const Text("THROW_NOW",
                    style: TextStyle(fontWeight: FontWeight.bold))),
            TextButton.icon(
                onPressed: () async {
                  List<String> pms = <String>[];
                  ScoutingTelemetry()
                      .forEach((EphemeralScoutingData? data) {
                    pms.add(data?.compressedFormat ?? "null");
                  });
                  await launchConfirmDialog(context,
                      message: SingleChildScrollView(
                          child: Text.rich(TextSpan(
                              children: <InlineSpan>[
                            for (String pm in pms)
                              TextSpan(text: "$pm\n\n")
                          ]))),
                      onConfirm: () {});
                },
                icon: const Icon(Icons.list_rounded),
                label: const Text("PMs",
                    style: TextStyle(fontWeight: FontWeight.bold))),
            FilledButton.tonal(
                onPressed: () {
                  _scrollController.animateTo(
                      _scrollController.position.maxScrollExtent,
                      duration: const Duration(milliseconds: 200),
                      curve:
                          Curves.easeOut); // reference for later :D
                },
                child: const Text("Scroll to Bottom")),
            FilledButton.tonal(
                onPressed: () {
                  Debug().info(
                      "BUFFER_USAGE: ${internalConsoleBuffer.length} of ${Shared.MAX_LOG_LENGTH} (${(internalConsoleBuffer.length / Shared.MAX_LOG_LENGTH) * 100}%)");
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      showCloseIcon: true,
                      behavior: SnackBarBehavior.fixed,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                      content: Center(
                        child: Text(
                            "${internalConsoleBuffer.length} of ${Shared.MAX_LOG_LENGTH} (${(internalConsoleBuffer.length / Shared.MAX_LOG_LENGTH) * 100}%)"),
                      )));
                },
                child: const Text("Display buffer usage"))
          ]),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14)),
              child: SingleChildScrollView(
                controller: _scrollController,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      for (String t in internalConsoleBuffer)
                        Padding(
                          padding: // shitty way to do a strut lol
                              const EdgeInsets.only(bottom: 10),
                          child: Container(
                              decoration: BoxDecoration(
                                color: ThemeProvider.themeOf(context)
                                            .data
                                            .colorScheme
                                            .brightness ==
                                        Brightness.dark
                                    ? ThemeProvider.themeOf(context)
                                        .data
                                        .colorScheme
                                        .onSurface
                                    : ThemeProvider.themeOf(context)
                                        .data
                                        .colorScheme
                                        .onInverseSurface,
                                borderRadius:
                                    BorderRadius.circular(8),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(t,
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        color: ThemeProvider.themeOf(
                                                        context)
                                                    .data
                                                    .colorScheme
                                                    .brightness ==
                                                Brightness.light
                                            ? ThemeProvider.themeOf(
                                                    context)
                                                .data
                                                .colorScheme
                                                .onSurface
                                            : ThemeProvider.themeOf(
                                                    context)
                                                .data
                                                .colorScheme
                                                .onInverseSurface,
                                        fontFamily: "IBM Plex Mono")),
                              )),
                        )
                    ]),
              ),
            ),
          )
        ]);
  }
}
