import "package:flutter/material.dart";
import 'package:scouting_app_2024/blobs/blobs.dart';
import 'package:scouting_app_2024/parts/theme.dart';
import "package:theme_provider/theme_provider.dart";

class ThemedAppBundle extends StatelessWidget {
  const ThemedAppBundle({super.key});

  @override
  Widget build(BuildContext context) {
    return ThemeProvider(
        themes: ThemeBlob.export(),
        child: ThemeConsumer(
            child: Builder(
                builder: (BuildContext themeCtxt) => MaterialApp(
                    debugShowCheckedModeBanner: false,
                    theme: ThemeProvider.themeOf(themeCtxt).data,
                    home: const _AppView()))));
  }
}

class _AppView extends StatefulWidget {
  const _AppView();

  @override
  State<_AppView> createState() => _AppViewState();
}

class _AppViewState extends State<_AppView> {
  /// delegates for all of the bottom nav bar items
  late List<BottomNavigationBarItem> _navBarItems;

  @override
  void initState() {
    super.initState();
    _navBarItems = const <BottomNavigationBarItem>[
      BottomNavigationBarItem(
          icon: Icon(Icons.fact_check_outlined),
          label: "Scouting",
          tooltip: "Enter scouting data here",
          activeIcon: Icon(Icons.fact_check_rounded)),
      BottomNavigationBarItem(
          icon: Icon(Icons.collections_bookmark_outlined),
          label: "Past Matches",
          tooltip: "View previously recorded matches",
          activeIcon: Icon(Icons.collections_bookmark_rounded)),
      BottomNavigationBarItem(
          icon: Icon(Icons.settings_applications_outlined),
          label: "Settings",
          tooltip: "Configure preferences for the app",
          activeIcon: Icon(Icons.settings_applications_rounded))
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: BottomNavigationBar(
          items: _navBarItems,
          onTap: (int i) /*TODO*/ {},
        ),
        appBar: AppBar(
            title: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
              const Image(
                image: ExactAssetImage("assets/appicon_header.png"),
                width: 52,
                height: 52,
                isAntiAlias: true,
              ),
              strut(width: 10),
              const Text("2638 Scouting"),
              Tooltip(
                message: "About",
                child: IconButton(
                    onPressed: () /*TODO*/ {},
                    icon: const Icon(Icons.info_outline_rounded)),
              )
            ])),
        body: PageView());
  }
}
