import 'package:flutter/material.dart';
import 'package:scouting_app_2024/parts/views/duck/duck_view_navigator.dart';

class DuckToolsView extends StatelessWidget
    implements DuckNavigatorViewTrait {
  const DuckToolsView({super.key});

  @override
  Widget get icon => const Icon(Icons.build_rounded);

  @override
  String get label => "Tools";

  @override
  Widget get view => this;

  @override
  Widget build(BuildContext context) {
    return const Text("Amogus");
  }
}
