import 'package:flutter/material.dart';

// MODIFY THIS PART ONLY
void ensureViewsInitialized() {
  _views = <AppPageViewExporter>[

  ];
}

List<AppPageViewExporter>? _views;

List<AppPageViewExporter> getViews() {
  if(_views == null) {
    throw 
  }
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
