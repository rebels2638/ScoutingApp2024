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
    ({Icon activeIcon, Icon icon, String label, String tooltip}) item
  }) exportAppPageView() {
    return (
      child: this,
      item: (
        activeIcon: const Icon(Icons.data_thresholding_rounded),
        icon: const Icon(Icons.data_thresholding_outlined),
        label: "Scouting",
        tooltip: "Data collection screen for observing matches"
      )
    );
  }
}
