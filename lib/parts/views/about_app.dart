import 'package:flutter/material.dart';
import 'package:scouting_app_2024/parts/views_delegate.dart';

class AboutAppView extends StatelessWidget
    implements AppPageViewExporter {
  const AboutAppView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text("Todo: About App"));
  }

  @override
  ({
    Widget child,
    ({Icon activeIcon, Icon icon, String label, String tooltip}) item
  }) exportAppPageView() {
    return (
      child: this,
      item: (
        activeIcon: const Icon(Icons.info_rounded),
        icon: const Icon(Icons.info_outline_rounded),
        label: "About",
        tooltip: "About 2638 Scouting Application"
      )
    );
  }
}
