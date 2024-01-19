import 'package:flutter/material.dart';
import 'package:scouting_app_2024/parts/views_delegate.dart';

class SettingsView extends StatelessWidget
    implements AppPageViewExporter {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text("Todo: Settings"));
  }

  @override
  ({
    Widget child,
    ({Icon activeIcon, Icon icon, String label, String tooltip}) item
  }) exportAppPageView() {
    return (
      child: this,
      item: (
        activeIcon: const Icon(Icons.settings_applications_rounded),
        icon: const Icon(Icons.settings_applications_outlined),
        label: "Settings",
        tooltip: "Configure preferences for the application"
      )
    );
  }
}
