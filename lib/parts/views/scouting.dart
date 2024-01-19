import 'package:flutter/material.dart';
import 'package:scouting_app_2024/parts/views_delegate.dart';

class ScoutingView extends StatelessWidget
    implements AppPageViewExporter {
  const ScoutingView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text("Todo: Scouting"));
  }

  @override
  ({
    Widget child,
    ({
      IconData activeIcon,
      IconData icon,
      String label,
      String tooltip
    }) item
  }) exportAppPageView() {
    return (
      child: this,
      item: (
        activeIcon: Icons.data_thresholding_rounded,
        icon: Icons.data_thresholding_rounded,
        label: "Scouting",
        tooltip: "Data collection screen for observing matches"
      )
    );
  }
}
