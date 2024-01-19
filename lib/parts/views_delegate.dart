import 'package:flutter/material.dart';
import 'package:scouting_app_2024/parts/views/views.dart';

final class ViewsDelegateManager {
  static List<Widget> acquireAllWidgets() {
    List<Widget> widgets = <Widget>[];
    if (views != null && views!.isNotEmpty) {
      for (AppPageViewExporter e in views!) {
        widgets.add(e.exportAppPageView().child);
      }
    }
    return widgets;
  }

  static List<BottomNavigationBarItem> buildAllItems() {
    List<BottomNavigationBarItem> items = <BottomNavigationBarItem>[];
    if (views != null && views!.isNotEmpty) {
      for (AppPageViewExporter e in views!) {
        ({
          Icon icon,
          String label,
          String tooltip,
          Icon activeIcon
        }) r = e.exportAppPageView().item;
        items.add(BottomNavigationBarItem(
            icon: r.icon,
            activeIcon: r.activeIcon,
            label: r.label,
            tooltip: r.tooltip));
      }
    }
    return items;
  }

  static List<AppPageViewExporter>? views;

  static void initViews() => views = <AppPageViewExporter>[
        const PastMatchesView(),
        const ScoutingView(),
        const SettingsView(),
        const AboutAppView()
      ];

  static List<AppPageViewExporter> getViews() {
    if (views == null) {
      throw "Failed to find views. You sure it was initialized?";
    }
    return views!;
  }
}

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
