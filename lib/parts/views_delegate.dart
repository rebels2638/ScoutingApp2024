import 'package:flutter/material.dart';
import 'package:scouting_app_2024/parts/views/past_matches.dart';
import 'package:scouting_app_2024/parts/views/scouting.dart';
import 'package:scouting_app_2024/parts/views/settings.dart';

// MODIFY THIS PART ONLY
void ensureViewsInitialized() {
  _views = <AppPageViewExporter>[
    const PastMatchesView(),
    const ScoutingView(),
    const SettingsView()
  ];
}

List<AppPageViewExporter>? _views;

List<AppPageViewExporter> getViews() {
  if (_views == null) {
    throw "Failed to find views. You sure it was initialized?";
  }
  return _views!;
}

abstract class AppPageViewExporter {
  /// Gets the information built for this page
  ///
  /// [child] refers to the actual content displayed on that page
  ///
  /// [item] refers to the representation for the navigation bar
  ({
    ({
      IconData icon,
      String label,
      String tooltip,
      IconData activeIcon
    }) item,
    Widget child
  }) exportAppPageView();
}
