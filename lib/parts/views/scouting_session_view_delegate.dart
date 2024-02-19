import 'package:flutter/material.dart';
import 'package:scouting_app_2024/parts/views_delegate.dart';

class ScoutingSessionViewDelegate extends StatelessWidget
    implements AppPageViewExporter {
  const ScoutingSessionViewDelegate({super.key});

  @override
  Widget build(BuildContext context) {
    return const ScoutingSessionViewDelegate();
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
