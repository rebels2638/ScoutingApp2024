import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:scouting_app_2024/blobs/blobs.dart';
import 'package:scouting_app_2024/blobs/locale_blob.dart';
import 'package:scouting_app_2024/blobs/stopwatch_blob.dart';
import 'package:scouting_app_2024/parts/bits/perf_overlay.dart';
import 'package:scouting_app_2024/parts/views_delegate.dart';
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

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(children: <Widget>[
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
                onPressed: () => launchConfirmDialog(context,
                    message: const Text("Debug Show CONFIRM_DIALOG"),
                    onConfirm: () {}),
                icon: const Icon(Icons.check_box_rounded),
                label: const Text("CONFIRM_DIALOG",
                    style: TextStyle(fontWeight: FontWeight.bold))),
            TextButton.icon(
                onPressed: () => throw "Debug Error box.",
                icon:
                    const Icon(Icons.security_update_warning_rounded),
                label: const Text("THROW_NOW",
                    style: TextStyle(fontWeight: FontWeight.bold))),
            TextButton.icon(
                onPressed: Provider.of<PerformanceOverlayModal>(
                        context,
                        listen: false /*dont touch this */)
                    .toggle,
                icon: const Icon(Icons.grain_rounded),
                label: const Text("Performance Overlay",
                    style: TextStyle(fontWeight: FontWeight.bold)))
          ]),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(14.0),
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14)),
                child: SingleChildScrollView(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        for (String t in internalConsoleBuffer)
                          Padding(
                            padding: // shitty way to do a strut lol
                                const EdgeInsets.only(bottom: 10),
                            child: Container(
                                decoration: BoxDecoration(
                                  color: ThemeProvider.themeOf(
                                                  context)
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
                                          color: ThemeProvider
                                                          .themeOf(
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
                                          fontFamily:
                                              "IBM Plex Mono")),
                                )),
                          )
                      ]),
                ),
              ),
            ),
          )
        ]);
  }
}
