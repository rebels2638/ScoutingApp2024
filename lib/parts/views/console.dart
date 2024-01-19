import 'package:flutter/material.dart';
import 'package:scouting_app_2024/parts/views_delegate.dart';

class ConsoleView extends StatelessWidget
    implements AppPageViewExporter {
  const ConsoleView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text("Todo: Past Matches"));
  }

  @override
  ({
    Widget child,
    ({Icon activeIcon, Icon icon, String label, String tooltip}) item
  }) exportAppPageView() {
    return (
      child: this,
      item: (
        activeIcon: const Icon(Icons.dataset_rounded),
        icon: const Icon(Icons.dataset_outlined),
        label: "About",
        tooltip: "About 2638 Scouting Application"
      )
    );
  }
}
