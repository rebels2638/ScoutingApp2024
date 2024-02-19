import 'dart:io';
import 'package:community_material_icon/community_material_icon.dart';
import "package:flutter/material.dart";
import 'package:provider/provider.dart';
import 'package:scouting_app_2024/blobs/blobs.dart';
import 'package:scouting_app_2024/debug.dart';
import 'package:scouting_app_2024/parts/bits/lock_in.dart';
import 'package:scouting_app_2024/parts/bits/prefer_compact.dart';
import 'package:scouting_app_2024/parts/bits/show_console.dart';
import 'package:scouting_app_2024/parts/bits/show_experimental.dart';
import 'package:scouting_app_2024/parts/bits/show_fps_monitor.dart';
import 'package:scouting_app_2024/parts/bits/show_game_map.dart';
import 'package:scouting_app_2024/shared.dart';
import 'package:scouting_app_2024/user/shared.dart';
import 'package:scouting_app_2024/parts/theme.dart';
import 'package:scouting_app_2024/parts/views/views.dart';
import 'package:scouting_app_2024/user/user_telemetry.dart';
import 'package:show_fps/show_fps.dart';
import 'package:scouting_app_2024/blobs/extended_fab_blob.dart';
import "package:theme_provider/theme_provider.dart";
import 'package:url_launcher/url_launcher.dart';

import 'theme_classifier.dart';
import 'views/scouting_session_view_delegate.dart' as rr;

GlobalKey<ScaffoldState> _globalScaffoldKey =
    GlobalKey<ScaffoldState>();

class IntermediateMaterialApp extends StatelessWidget {
  const IntermediateMaterialApp({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeProvider.themeOf(context).data,
      home: ShowFPS(
          alignment: Alignment.topLeft,
          visible: ShowFPSMonitorModal.isShowingFPSMonitor(context),
          showChart: true,
          borderRadius: const BorderRadius.only(
              bottomRight: Radius.circular(8)),
          child: _AppView()),
    );
  }
}

class _AppView extends StatefulWidget {
  final PageController pageController = PageController();
  _AppView();

  @override
  State<_AppView> createState() => _AppViewState();
}

class _AppViewState extends State<_AppView> {
  int _bottomNavBarIndexer = 0;

  @override
  Widget build(BuildContext context) {
    ({
      Widget child,
      ({
        Icon activeIcon,
        Icon icon,
        String label,
        String tooltip
      }) item
    }) settingsView = const SettingsView().exportAppPageView();
    ({
      Widget child,
      ({
        Icon activeIcon,
        Icon icon,
        String label,
        String tooltip
      }) item
      // this is the only delegate that formally implements this feature where the view is not directly shown but through a delegate that can forward operations
    }) scoutingView =
        const rr.ScoutingSessionViewDelegate().exportAppPageView();
    ({
      Widget child,
      ({
        Icon activeIcon,
        Icon icon,
        String label,
        String tooltip
      }) item
    }) pastMatchesView = const PastMatchesView().exportAppPageView();
    ({
      Widget child,
      ({
        Icon activeIcon,
        Icon icon,
        String label,
        String tooltip
      }) item
    }) aboutAppView = const AboutAppView().exportAppPageView();
    ({
      Widget child,
      ({
        Icon activeIcon,
        Icon icon,
        String label,
        String tooltip
      }) item
    }) gameInfoView = const GameInfoView().exportAppPageView();
    ({
      Widget child,
      ({
        Icon activeIcon,
        Icon icon,
        String label,
        String tooltip
      }) item
    }) consoleView = const ConsoleView().exportAppPageView();
    ({
      Widget child,
      ({
        Icon activeIcon,
        Icon icon,
        String label,
        String tooltip
      }) item
    })? dataHostView;
    if (Platform.isWindows) {
      dataHostView = const DataHostingView().exportAppPageView();
    }
    List<NavigationDestination> bottomItems = <NavigationDestination>[
      // plsplsplspls make sure this matches with the following PageView's children ordering D:
      if (dataHostView != null &&
          ShowExperimentalModal.isShowingExperimental(context))
        NavigationDestination(
            icon: dataHostView.item.icon,
            label: dataHostView.item.label,
            selectedIcon: dataHostView.item.activeIcon,
            tooltip: dataHostView.item.tooltip),
      NavigationDestination(
          icon: scoutingView.item.icon,
          label: scoutingView.item.label,
          selectedIcon: scoutingView.item.activeIcon,
          tooltip: scoutingView.item.tooltip),
      NavigationDestination(
          icon: pastMatchesView.item.icon,
          label: pastMatchesView.item.label,
          selectedIcon: pastMatchesView.item.activeIcon,
          tooltip: pastMatchesView.item.tooltip),
      if (LockedInScoutingModal.isCasual(context))
        NavigationDestination(
            icon: settingsView.item.icon,
            label: settingsView.item.label,
            selectedIcon: settingsView.item.activeIcon,
            tooltip: settingsView.item.tooltip),
      if (LockedInScoutingModal.isCasual(context))
        NavigationDestination(
            icon: aboutAppView.item.icon,
            label: aboutAppView.item.label,
            selectedIcon: aboutAppView.item.activeIcon,
            tooltip: aboutAppView.item.tooltip),
      if (LockedInScoutingModal.isCasual(context) &&
          ShowGameMapModal.isShowingConsole(context))
        NavigationDestination(
            icon: gameInfoView.item.icon,
            label: gameInfoView.item.label,
            selectedIcon: gameInfoView.item.activeIcon,
            tooltip: gameInfoView.item.tooltip),
      if (LockedInScoutingModal.isCasual(context) &&
          ShowConsoleModal.isShowingConsole(context))
        NavigationDestination(
            icon: consoleView.item.icon,
            label: consoleView.item.label,
            selectedIcon: consoleView.item.activeIcon,
            tooltip: consoleView.item.tooltip)
    ];
    List<Widget> pageViewWidgets = <Widget>[
      if (dataHostView != null &&
          ShowExperimentalModal.isShowingExperimental(context))
        dataHostView.child,
      scoutingView.child,
      pastMatchesView.child,
      if (LockedInScoutingModal.isCasual(context)) settingsView.child,
      if (LockedInScoutingModal.isCasual(context)) aboutAppView.child,
      if (LockedInScoutingModal.isCasual(context) &&
          ShowGameMapModal.isShowingConsole(context))
        gameInfoView.child,
      if (LockedInScoutingModal.isCasual(context) &&
          ShowConsoleModal.isShowingConsole(context))
        consoleView.child,
    ];
    Future<void>.delayed(Duration.zero, () {
      if (ThemeClassifier.of(context) !=
          AvaliableTheme.of(
              UserTelemetry().currentModel.selectedTheme)) {
        setState(() => ThemeProvider.controllerOf(context)
            .setTheme(UserTelemetry().currentModel.selectedTheme));
      }
    });
    return Scaffold(
        key: _globalScaffoldKey,
        floatingActionButton: ExpFabBlob(
            defaultWidget:
                const Icon(CommunityMaterialIcons.star_four_points),
            distance: 80,
            children: <Widget>[
              ActionButton(
                onPressed: () {
                  Provider.of<LockedInScoutingModal>(context,
                          listen: false)
                      .toggle();
                  Debug().info(
                      "BottomItems: ${bottomItems.length} and $_bottomNavBarIndexer for PageView length: ${pageViewWidgets.length}");
                  // use a loop to find where the scouting view is
                  for (int i = 0; i < bottomItems.length; i++) {
                    if (bottomItems[i].label.contains("Scouting")) {
                      Debug().info(
                          "BottomNavBar -> Found Scouting view at $i");
                      setState(() {
                        _bottomNavBarIndexer = i;
                        widget.pageController.animateToPage(
                            _bottomNavBarIndexer,
                            duration:
                                const Duration(milliseconds: 500),
                            curve: Curves.ease);
                      });
                    }
                  }
                },
                icon: Icon(
                    LockedInScoutingModal.isCasual(context)
                        ? Icons.lock_open_rounded
                        : Icons.lock_rounded,
                    color: ThemeProvider.themeOf(context)
                        .data
                        .iconTheme
                        .color),
              ),
              ActionButton(
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext ctxt) {
                          List<AppTheme> appThemes = context
                                  .findAncestorWidgetOfExactType<
                                      ThemeProvider>()
                                  ?.themes ??
                              <AppTheme>[];
                          return AlertDialog(
                              scrollable: true,
                              title: const Row(children: <Widget>[
                                 Icon(Icons.palette_rounded),
                                 SizedBox(width: 10),
                                 Text("Theme Library")
                              ]),
                              content: SingleChildScrollView(
                                  child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.start,
                                children: <Widget>[
                                  Text.rich(
                                      TextSpan(children: <InlineSpan>[
                                        TextSpan(
                                            text: AvaliableTheme.of(
                                                    ThemeClassifier.of(
                                                            context)
                                                        .id)
                                                .properName,
                                            style: const TextStyle(
                                                fontWeight:
                                                    FontWeight.bold)),
                                        TextSpan(
                                            text:
                                                ", a Material ${ThemeProvider.themeOf(context).data.useMaterial3 ? "3" : "2"} theme")
                                      ]),
                                      style: const TextStyle(
                                          fontSize: 18)),
                                  const SizedBox(height: 10),
                                  Wrap(children: <Widget>[
                                    for (AppTheme e in appThemes)
                                      Padding(
                                        padding:
                                            const EdgeInsets.all(8.0),
                                        child: e.id !=
                                                ThemeClassifier.of(context)
                                                    .id
                                            ? ElevatedButton.icon(
                                                style: ButtonStyle(
                                                    visualDensity:
                                                        VisualDensity
                                                            .comfortable,
                                                    backgroundColor:
                                                        MaterialStateProperty.all<Color>(e
                                                            .data
                                                            .primaryColor),
                                                    iconColor: MaterialStateProperty.all<Color>(e
                                                            .data
                                                            .iconTheme
                                                            .color ??
                                                        Colors.black),
                                                    foregroundColor:
                                                        MaterialStateProperty.all<Color>(
                                                            e.data.iconTheme.color ?? Colors.black),
                                                    iconSize: MaterialStateProperty.all<double>(30),
                                                    shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                                                    padding: MaterialStateProperty.all<EdgeInsetsGeometry>(const EdgeInsets.all(14))),
                                                onPressed: () {
                                                  ThemeProvider
                                                          .controllerOf(
                                                              context)
                                                      .setTheme(e.id);
                                                  UserTelemetry()
                                                          .currentModel
                                                          .selectedTheme =
                                                      ThemeClassifier.of(
                                                              context)
                                                          .id;
                                                  UserTelemetry()
                                                      .save();
                                                },
                                                icon: Column(
                                                  children: <Widget>[
                                                    Icon(
                                                        AvaliableTheme
                                                            .of(
                                                      e.id,
                                                    ).icon),
                                                    const SizedBox(height: 6),
                                                    if (e.data
                                                            .brightness ==
                                                        Brightness
                                                            .dark)
                                                      const Icon(
                                                          Icons
                                                              .nightlight_round,
                                                          size: 14)
                                                    else
                                                      const Icon(
                                                          Icons
                                                              .wb_sunny_rounded,
                                                          size: 14)
                                                  ],
                                                ),
                                                label: Text.rich(TextSpan(children: <InlineSpan>[
                                                  TextSpan(
                                                      text: AvaliableTheme
                                                              .of(e
                                                                  .id)
                                                          .properName,
                                                      style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight
                                                                  .bold,
                                                          fontSize:
                                                              18)),
                                                  const TextSpan(
                                                      text: "\nBy "),
                                                  TextSpan(
                                                      text: AvaliableTheme
                                                              .of(e
                                                                  .id)
                                                          .author,
                                                      style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight
                                                                  .w400,
                                                          fontSize:
                                                              12,
                                                          fontStyle:
                                                              FontStyle
                                                                  .italic))
                                                ])))
                                            : OutlinedButton.icon(
                                                style: ButtonStyle(visualDensity: VisualDensity.comfortable, iconColor: MaterialStateProperty.all<Color>(e.data.iconTheme.color ?? Colors.black), foregroundColor: MaterialStateProperty.all<Color>(e.data.iconTheme.color ?? Colors.black), iconSize: MaterialStateProperty.all<double>(30), shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))), padding: MaterialStateProperty.all<EdgeInsetsGeometry>(const EdgeInsets.all(14))),
                                                onPressed: () {
                                                  ThemeProvider
                                                          .controllerOf(
                                                              context)
                                                      .setTheme(e.id);
                                                  UserTelemetry()
                                                          .currentModel
                                                          .selectedTheme =
                                                      ThemeClassifier.of(
                                                              context)
                                                          .id;
                                                  UserTelemetry()
                                                      .save();
                                                },
                                                icon: Column(
                                                  children: <Widget>[
                                                    Icon(
                                                        AvaliableTheme
                                                            .of(
                                                      e.id,
                                                    ).icon),
                                                    const SizedBox(height: 6),
                                                    if (e.data
                                                            .brightness ==
                                                        Brightness
                                                            .dark)
                                                      const Icon(
                                                          Icons
                                                              .nightlight_round,
                                                          size: 14)
                                                    else
                                                      const Icon(
                                                          Icons
                                                              .wb_sunny_rounded,
                                                          size: 14)
                                                  ],
                                                ),
                                                label: Text.rich(TextSpan(children: <InlineSpan>[
                                                  TextSpan(
                                                      text: AvaliableTheme
                                                              .of(e
                                                                  .id)
                                                          .properName,
                                                      style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight
                                                                  .bold,
                                                          fontSize:
                                                              18)),
                                                  const TextSpan(
                                                      text: "\nBy "),
                                                  TextSpan(
                                                      text: AvaliableTheme
                                                              .of(e
                                                                  .id)
                                                          .author,
                                                      style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight
                                                                  .w400,
                                                          fontSize:
                                                              12,
                                                          fontStyle:
                                                              FontStyle
                                                                  .italic))
                                                ]))),
                                      )
                                  ]),
                                ],
                              )),
                              actions: <Widget>[
                                TextButton.icon(
                                    onPressed: () {
                                      Navigator.of(ctxt)
                                          .pop(); // i debugged this shit a fuck ton, it kept closing the scaffold. reaosn? it was using the original build(BuildContext) which was already gone lmao, fuck they should have nested shadowing rules
                                      UserTelemetry()
                                              .currentModel
                                              .selectedTheme =
                                          ThemeClassifier.of(context)
                                              .id;
                                      UserTelemetry().save();
                                    },
                                    icon: const Icon(
                                        Icons.check_rounded),
                                    label: const Text("Set",
                                        style: TextStyle(
                                            fontWeight:
                                                FontWeight.bold)))
                              ]);
                        });
                  },
                  icon: Icon(Icons.palette_rounded,
                      color: ThemeProvider.themeOf(context)
                          .data
                          .iconTheme
                          .color))
            ]),
        bottomNavigationBar: AnimatedSwitcher(
            duration: const Duration(milliseconds: 600),
            switchInCurve: Curves.easeInOut,
            switchOutCurve: Curves.easeIn,
            child: NavigationBar(
              selectedIndex: _bottomNavBarIndexer,
              destinations: bottomItems,
              onDestinationSelected: (int i) {
                Debug().info(
                    "BottomNavBar -> PageView move to $i and was at ${widget.pageController.page} for builder length: ${bottomItems.length}");
                widget.pageController.animateToPage(i,
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.ease);
                setState(() => _bottomNavBarIndexer = i);
              },
            )),
        appBar: AppBar(
            forceMaterialTransparency: true,
            centerTitle: true, // i forgor
            title: LockedInScoutingModal.isCasual(context)
                ? Center(
                    child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        switchInCurve: Curves.ease,
                        switchOutCurve: Curves.ease,
                        transitionBuilder: (Widget child,
                            Animation<double> animation) {
                          return SlideTransition(
                            position: Tween<Offset>(
                                    begin: const Offset(0, 0.5),
                                    end: const Offset(0, 0))
                                .animate(animation),
                            child: child,
                          );
                        },
                        child: PreferCompactModal.isCompactPreferred(
                                context)
                            ? GestureDetector(
                                onTap: () async =>
                                    await launchConfirmDialog(context,
                                        message: const Text(
                                            "You are about to visit the Rebel Robotics' website"),
                                        onConfirm: () async =>
                                            await launchUrl(Uri.parse(
                                                RebelRoboticsShared
                                                    .website))),
                                child: const Hero(
                                  tag: "RebelsLogo",
                                  child: Image(
                                    image: ExactAssetImage(
                                        "assets/appicon_header.png"),
                                    width: 52,
                                    height: 52,
                                  ),
                                ),
                              )
                            : Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.center,
                                children: <Widget>[
                                    GestureDetector(
                                      onTap: () async =>
                                          await launchConfirmDialog(
                                              context,
                                              message: const Text(
                                                  "You are about to visit the Rebel Robotics' website"),
                                              onConfirm: () async =>
                                                  await launchUrl(Uri.parse(
                                                      RebelRoboticsShared
                                                          .website))),
                                      child: const Hero(
                                        tag: "RebelsLogo",
                                        child: Image(
                                          image: ExactAssetImage(
                                              "assets/appicon_header.png"),
                                          width: 52,
                                          height: 52,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    const Text(APP_CANONICAL_NAME,
                                        style: TextStyle(
                                            fontWeight:
                                                FontWeight.w500)),
                                    const SizedBox(width: 10),
                                    GestureDetector(
                                        onTap: () async =>
                                            await launchConfirmDialog(
                                                context,
                                                message: const Text(
                                                    "You are about to visit the FRC Game Overview website"),
                                                onConfirm: () async =>
                                                    await launchUrl(Uri.parse(
                                                        FIRSTCrescendoShared
                                                            .website))),
                                        child: const Image(
                                            height: 20,
                                            image: ExactAssetImage(
                                                "assets/crescendo/crescendo_header.png"))),
                                  ])),
                  )
                : Container()) /*lmao */,
        body: Padding(
            padding: const EdgeInsets.all(10.0),
            child: RepaintBoundary(
              child: PageView(
                // this keeps the bottom nav bar index and the page view index in sync. this is kind of unoptimized in the sense of setState
                onPageChanged: (int pageNow) =>
                    setState(() => _bottomNavBarIndexer = pageNow),
                scrollDirection: Axis.horizontal,
                allowImplicitScrolling:
                    false, // prevent users from accidentally swiping
                controller: widget.pageController,
                children: pageViewWidgets,
              ),
            )));
  }
}
