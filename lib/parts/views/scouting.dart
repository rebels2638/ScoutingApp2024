import 'package:flutter/material.dart';
import 'package:scouting_app_2024/blobs/form_blob.dart';
import 'package:scouting_app_2024/parts/team.dart';
import 'package:scouting_app_2024/parts/views_delegate.dart';

typedef SectionId = ({String title, IconData icon});

class ScoutingView extends StatelessWidget
    implements AppPageViewExporter {
  const ScoutingView({super.key});
  @override
  Widget build(BuildContext context) {
    // MOCKUP, NOT FINAL
    return Scaffold(
        body: form_grid_1(children: <Widget>[
      form_grid_sec(context,
          header: (
            icon: Icons.info_outline_rounded,
            title: "Match Information"
          ),
          child: TeamAllianceSwitch(onChanged: (_) {})),
      form_grid_sec(context,
          header: (
            icon: Icons.info_outline_rounded,
            title: "Match Information"
          ),
          child: TeamAllianceSwitch(onChanged: (_) {})),
    ]));
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
