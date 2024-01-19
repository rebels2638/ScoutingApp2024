import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
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
