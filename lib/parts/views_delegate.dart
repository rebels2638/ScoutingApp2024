import 'package:flutter/material.dart';

/* this shit dont work!!! plssssss i hate compile time constanting
final class ViewsDelegateManager {
  static final ViewsDelegateManager _singleton =
      ViewsDelegateManager._();
  factory ViewsDelegateManager() => _singleton;
  ViewsDelegateManager._();

  List<Widget> acquireAllWidgets() {
    List<Widget> widgets = <Widget>[];
    if (views != null && views!.isNotEmpty) {
      for (AppPageViewExporter e in views!) {
        widgets.add(e.exportAppPageView().child);
      }
    }
    return widgets;
  }

  List<BottomNavigationBarItem> buildAllItems(BuildContext context) {
    List<BottomNavigationBarItem> items = <BottomNavigationBarItem>[];
    if (views != null && views!.isNotEmpty) {
      for (AppPageViewExporter e in views!) {
        items.add(
            buildNavBarItem(context, e.exportAppPageView().item));
      }
    }
    return items;
  }

  BottomNavigationBarItem buildNavBarItem(
      BuildContext context,
      ({
        Icon icon,
        String label,
        String tooltip,
        Icon activeIcon,
      }) item) {
    return BottomNavigationBarItem(
      icon: Icon(
        item.icon.icon,
        color: ThemeProvider.themeOf(context).data.iconTheme.color,
      ),
      activeIcon: Icon(
        item.icon.icon,
        color: ThemeProvider.themeOf(context).data.iconTheme.color,
      ),
      label: item.label,
      tooltip: item.tooltip,
    );
  }

  List<AppPageViewExporter>? views;

  void initViews() => views = <AppPageViewExporter>[
        const PastMatchesView(),
        const ScoutingView(),
        const AboutAppView(),
        const SettingsView(),
        const ConsoleView()
      ];

  List<AppPageViewExporter> getViews() {
    if (views == null) {
      throw "Failed to find views. You sure it was initialized?";
    }
    return views!;
  }
}
*/

abstract class AppPageViewExporter {
  /// Gets the information built for this page
  ///
  /// [child] refers to the actual content displayed on that page
  ///
  /// [item] refers to the representation for the navigation bar
  ({
    ({Icon icon, String label, String tooltip, Icon activeIcon}) item,
    Widget child
  }) exportAppPageView();
}
