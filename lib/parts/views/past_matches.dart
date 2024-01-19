import 'package:flutter/material.dart';
import 'package:scouting_app_2024/parts/views_delegate.dart';

class PastMatchesView extends StatelessWidget
    implements AppPageViewExporter {
  const PastMatchesView({super.key});

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
        activeIcon: const Icon(Icons.fact_check_rounded),
        icon: const Icon(Icons.fact_check_outlined),
        label: "Past Matches",
        tooltip: "View data collected from past matches"
      )
    );
  }
}
