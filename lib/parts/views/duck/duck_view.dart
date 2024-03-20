import 'package:community_material_icon/community_material_icon.dart';
import 'package:flutter/material.dart';
import 'package:scouting_app_2024/parts/views_delegate.dart';

/*
  __
<(o )___
 ( ._> /
  `---'
  __
<(o )___
 ( ._> /
  `---'
  __
<(o )___
 ( ._> /
  `---'
  __
<(o )___
 ( ._> /
  `---'
  __
<(o )___
 ( ._> /
  `---'
  __
<(o )___
 ( ._> /
  `---'
  __
<(o )___
 ( ._> /
  `---'

  quack quack quack
 */

class DuckView extends StatelessWidget
    implements AppPageViewExporter {
  const DuckView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container();
  }

  @override
  ({
    Widget child,
    ({Icon activeIcon, Icon icon, String label, String tooltip}) item
  }) exportAppPageView() {
    return (
      child: this,
      item: (
        activeIcon: const Icon(CommunityMaterialIcons.duck),
        icon: const Icon(CommunityMaterialIcons.duck),
        label: "Duc",
        tooltip: "Integrated Data Collection"
      )
    );
  }
}
