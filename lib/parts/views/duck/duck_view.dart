import 'package:community_material_icon/community_material_icon.dart';
import 'package:flutter/material.dart';
import 'package:scouting_app_2024/blobs/hints_blob.dart';
import 'package:scouting_app_2024/parts/views/duck/collected_view_trait.dart';
import 'package:scouting_app_2024/parts/views/duck/duck_view_navigator.dart';
import 'package:scouting_app_2024/parts/views/duck/tools_view_trait.dart';
import 'package:scouting_app_2024/parts/views/views.dart';
import 'package:scouting_app_2024/parts/views_delegate.dart';
import 'package:scouting_app_2024/user/user_telemetry.dart';

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

class DuckView extends StatefulWidget implements AppPageViewExporter {
  final List<DuckNavigatorViewTrait> _views;

  DuckView({super.key})
      : _views = <DuckNavigatorViewTrait>[
          const DuckToolsView(),
          const DuckCollectedDataView(),
        ];

  @override
  State<DuckView> createState() => _DuckViewState();

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
        label: "DUC",
        tooltip: "Integrated Data Collection"
      )
    );
  }
}

class _DuckViewState extends State<DuckView>
    with SingleTickerProviderStateMixin {
  late TabController _controller;
  bool _addedLegacyItem = false;

  @override
  void initState() {
    super.initState();
    if (!_addedLegacyItem &&
        UserTelemetry().currentModel.showLegacyItems) {
      _addedLegacyItem = true;
      widget._views.add(const DataHostingView());
    }
    _controller =
        TabController(length: widget._views.length, vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: UserTelemetry().currentModel.showHints
            ? const Padding(
                padding: EdgeInsets.all(8.0),
                child: WarningHintsBlob("Scouting Leaders Only",
                    "Integrated Data Collection DUC"),
              )
            : const Row(
                children: <Widget>[
                  Icon(CommunityMaterialIcons.duck),
                  SizedBox(width: 6),
                  Text("DUC"),
                ],
              ),
        centerTitle: true,
        bottom: TabBar(tabs: <Widget>[
          for (DuckNavigatorViewTrait view in widget._views)
            Tab(icon: view.icon, text: view.label)
        ], controller: _controller),
      ),
      body: TabBarView(
        controller: _controller,
        children: <Widget>[
          for (DuckNavigatorViewTrait view in widget._views) view.view
        ],
      ),
    );
  }
}
