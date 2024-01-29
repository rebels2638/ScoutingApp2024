import 'package:flutter/material.dart';
import 'package:scouting_app_2024/parts/views_delegate.dart';

class GameInfoView extends StatelessWidget
    implements AppPageViewExporter {
  const GameInfoView({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.asset("assets/crescendo/field.png")
              ]),
        ));
  }

  @override
  ({
    Widget child,
    ({Icon activeIcon, Icon icon, String label, String tooltip}) item
  }) exportAppPageView() {
    return (
      child: this,
      item: (
        activeIcon: const Icon(Icons.map_rounded),
        icon: const Icon(Icons.map_outlined),
        label: "Game",
        tooltip: "Information related to the current FRC Game"
      )
    );
  }
}
