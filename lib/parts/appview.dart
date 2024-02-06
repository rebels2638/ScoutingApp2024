import 'dart:io';
import 'package:community_material_icon/community_material_icon.dart';
import "package:flutter/material.dart";
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:scouting_app_2024/blobs/blobs.dart';
import 'package:scouting_app_2024/debug.dart';
import 'package:scouting_app_2024/parts/bits/lock_in.dart';
import 'package:scouting_app_2024/parts/bits/perf_overlay.dart';
import 'package:scouting_app_2024/parts/bits/show_console.dart';
import 'package:scouting_app_2024/parts/bits/show_experimental.dart';
import 'package:scouting_app_2024/parts/bits/show_fps_monitor.dart';
import 'package:scouting_app_2024/parts/bits/show_game_map.dart';
import 'package:scouting_app_2024/parts/bits/theme_mode.dart';
import 'package:scouting_app_2024/shared.dart';
import 'package:scouting_app_2024/user/shared.dart';
import 'package:scouting_app_2024/parts/theme.dart';
import 'package:scouting_app_2024/parts/views/views.dart';
import 'package:scouting_app_2024/user/user_telemetry.dart';
import 'package:show_fps/show_fps.dart';
import "package:theme_provider/theme_provider.dart";
import 'package:url_launcher/url_launcher.dart';

GlobalKey<NavigatorState> globalNavKey = GlobalKey<NavigatorState>();

class ThemedAppBundle extends StatelessWidget {
  const ThemedAppBundle({super.key});

  @override
  Widget build(BuildContext context) {
    return ThemeProvider(
        themes: ThemeBlob.export(),
        child: ThemeConsumer(
            child: Builder(
                builder: (BuildContext
                        themeCtxt) => /*lol this is very scuffed XD i hope you can forgive me*/
                    MultiProvider(providers: <SingleChildWidget>[                      ChangeNotifierProvider<ShowFPSMonitorModal>(
                          create: (BuildContext _) =>
                              ShowFPSMonitorModal()),
                      ChangeNotifierProvider<ShowExperimentalModal>(
                          create: (BuildContext _) =>
                              ShowExperimentalModal()),
                      ChangeNotifierProvider<ShowGameMapModal>(
                          create: (BuildContext _) =>
                              ShowGameMapModal()),
                      ChangeNotifierProvider<ThemeModeModal>(
                          create: (BuildContext _) =>
                              ThemeModeModal()),
                      ChangeNotifierProvider<ShowConsoleModal>(
                          create: (BuildContext _) =>
                              ShowConsoleModal()),
                      ChangeNotifierProvider<PerformanceOverlayModal>(
                          create: (BuildContext _) =>
                              PerformanceOverlayModal()),
                      ChangeNotifierProvider<LockedInScoutingModal>(
                          create: (BuildContext _) =>
                              LockedInScoutingModal())
                    ], child: const IntermediateMaterialApp()))));
  }
}

class IntermediateMaterialApp extends StatelessWidget {
  const IntermediateMaterialApp({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      showPerformanceOverlay:
          Provider.of<PerformanceOverlayModal>(context, listen: false)
              .show,
      debugShowCheckedModeBanner: false,
      theme: ThemeProvider.themeOf(context).data,
      darkTheme: ThemeProvider.themeOf(context).data,
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
  /// delegates for all of the bottom nav bar items
  late TextEditingController _themeSelectorController;
  int _bottomNavBarIndexer = 0;

  @override
  void initState() {
    super.initState();
    _themeSelectorController = TextEditingController();
  }

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
        const ScoutingSessionViewDelegate().exportAppPageView();
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
    }) gameMapView = const GameMapView().exportAppPageView();
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
            icon: gameMapView.item.icon,
            label: gameMapView.item.label,
            selectedIcon: gameMapView.item.activeIcon,
            tooltip: gameMapView.item.tooltip),
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
        gameMapView.child,
      if (LockedInScoutingModal.isCasual(context) &&
          ShowConsoleModal.isShowingConsole(context))
        consoleView.child,
    ];
    Future<void>.delayed(Duration.zero, () {
      if (ThemeClassifier.of(context) !=
          UserTelemetry().currentModel.selectedTheme) {
        setState(() => ThemeProvider.controllerOf(context).setTheme(
            UserTelemetry().currentModel.selectedTheme.name));
      }
    });
    return Scaffold(
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
            actions: <Widget>[
              IconButton.filledTonal(
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
                  icon: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 500),
                      child: LockedInScoutingModal.isCasual(context)
                          ? const Icon(CommunityMaterialIcons
                              .lock_open_variant)
                          : const Icon(CommunityMaterialIcons.lock))),
              strut(width: 10),
              Padding(
                padding: const EdgeInsets.only(right: 16),
                child: IconButton.filledTonal(
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext ctxt) {
                            return AlertDialog(
                                title: const Text("Theme Select"),
                                content: DropdownMenu<
                                        AvaliableThemes>(
                                    initialSelection:
                                        ThemeClassifier.of(context),
                                    controller:
                                        _themeSelectorController,
                                    requestFocusOnTap: true,
                                    label: const Text("Theme Name"),
                                    onSelected: (AvaliableThemes? theme) =>
                                        setState(() {
                                          if (theme != null) {
                                            UserTelemetry()
                                                    .currentModel
                                                    .selectedTheme =
                                                theme;
                                            ThemeProvider
                                                    .controllerOf(
                                                        context)
                                                .setTheme(theme.name);
                                            Debug().info(
                                                "Switched theme to ${theme.properName}");
                                          }
                                        }),
                                    dropdownMenuEntries: AvaliableThemes
                                        .values
                                        .map<DropdownMenuEntry<AvaliableThemes>>(
                                            (AvaliableThemes e) => DropdownMenuEntry<
                                                    AvaliableThemes>(
                                                value: e,
                                                label: e.properName,
                                                leadingIcon: e.isDarkMode
                                                    ? const Icon(
                                                        Icons.nightlight_round)
                                                    : const Icon(Icons.wb_sunny_rounded)))
                                        .toList()),
                                actions: <Widget>[
                                  TextButton.icon(
                                      onPressed: () async {
                                        Debug().info(
                                            "User affirmed theme change");
                                        Navigator.of(context).pop();
                                        UserTelemetry()
                                                .currentModel
                                                .selectedTheme =
                                            ThemeClassifier.of(
                                                context);
                                        await UserTelemetry().save();
                                      },
                                      icon: const Icon(
                                          Icons.check_rounded),
                                      label: const Text("Ok",
                                          style: TextStyle(
                                              fontWeight:
                                                  FontWeight.bold)))
                                ]);
                          });
                    },
                    icon: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 500),
                      child: ThemeClassifier.of(context).isDarkMode
                          ? const Icon(Icons.nightlight_round)
                          : const Icon(Icons.wb_sunny_rounded),
                    )),
              )
            ],
            centerTitle: true,
            title: LockedInScoutingModal.isCasual(context)
                ? Center(
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          GestureDetector(
                            onTap: () async => await launchConfirmDialog(
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
                          strut(width: 10),
                          const Text(APP_CANONICAL_NAME,
                              style: TextStyle(
                                  fontWeight: FontWeight.w500)),
                          strut(width: 10),
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
                        ]),
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
