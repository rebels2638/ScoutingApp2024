import 'package:flutter/material.dart';

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
