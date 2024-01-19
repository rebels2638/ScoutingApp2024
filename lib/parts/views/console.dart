import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:scouting_app_2024/blobs/debug.dart';
import 'package:scouting_app_2024/parts/views_delegate.dart';
import 'package:scouting_app_2024/shared.dart';
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

final List<String> _buffer = <String>[];

class _ConsoleComponent extends StatefulWidget {
  @override
  State<_ConsoleComponent> createState() => _ConsoleComponentState();
}

class _ConsoleComponentState extends State<_ConsoleComponent> {
  void _check(LogRecord record) {
    if (_buffer.length >= Shared.MAX_LOG_LENGTH) {
      _buffer.clear();
    }
    _buffer.add(Debug().stdIOPrettifier.call(record));
  }

  @override
  void initState() {
    super.initState();
    Debug().listen(_check);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(children: <Widget>[
            TextButton.icon(
                onPressed: () => setState(() => _buffer.clear()),
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
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        for (String t in _buffer)
                          Padding(
                            padding: // shitty way to do a struct lol
                                const EdgeInsets.only(bottom: 10),
                            child: Container(
                                decoration: BoxDecoration(
                                  color:
                                      ThemeProvider.themeOf(context)
                                          .data
                                          .colorScheme
                                          .brightness == Brightness.dark ?  ThemeProvider.themeOf(context)
                                          .data
                                          .colorScheme
                                          .onSurface :  ThemeProvider.themeOf(context)
                                          .data
                                          .colorScheme
                                          .onInverseSurface,
                                  borderRadius:
                                      BorderRadius.circular(8),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(t,
                                      style: const TextStyle(
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
