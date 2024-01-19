import "package:flutter/material.dart";
import 'package:scouting_app_2024/blobs/blobs.dart';
import 'package:scouting_app_2024/parts/theme.dart';
import 'package:scouting_app_2024/parts/views_delegate.dart';
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
                    darkTheme: ThemeProvider.themeOf(themeCtxt).data,
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
  late PageController _pageController;
  bool _isDark = false;

  @override
  void initState() {
    super.initState();
    ViewsDelegateManager().initViews();
    _pageController = PageController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButtonLocation:
            FloatingActionButtonLocation.endFloat,
        floatingActionButton: Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  FloatingActionButton(
                      heroTag: null,
                      onPressed: () /*TODO*/ {},
                      child: const Icon(Icons.upload_rounded)),
                  strut(width: 10),
                  FloatingActionButton(
                      heroTag: null,
                      onPressed: () {
                        ThemeProvider.controllerOf(context).setTheme(
                            _isDark
                                ? "default_light"
                                : "default_dark");
                        setState(() => _isDark = !_isDark);
                      },
                      child: _isDark
                          ? const Icon(Icons.nightlight_round)
                          : const Icon(Icons.wb_sunny_rounded))
                ])),
        bottomNavigationBar: BottomNavigationBar(
          items: ViewsDelegateManager().buildAllItems(context),
          onTap: (int i) => _pageController.animateToPage(i,
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInBack),
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
            ])),
        body: PageView(
            allowImplicitScrolling: false,
            controller: _pageController,
            children: ViewsDelegateManager().acquireAllWidgets()));
  }
}
