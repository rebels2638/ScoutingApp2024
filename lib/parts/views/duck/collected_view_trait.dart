import 'package:flutter/material.dart';
import 'package:scouting_app_2024/parts/views/duck/duck_view_navigator.dart';

class DuckCollectedDataView extends StatelessWidget
    implements DuckNavigatorViewTrait {
  const DuckCollectedDataView({super.key});

  @override
  Widget get icon => const Icon(Icons.data_array_rounded);

  @override
  String get label => "Collected Data";

  @override
  Widget get view => this;

  @override
  Widget build(BuildContext context) {
    return const Center(
        child: Text.rich(TextSpan(
            text: "Coming Soon",
            style:
                TextStyle(fontWeight: FontWeight.bold, fontSize: 32),
            children: <InlineSpan>[
          TextSpan(
              text: "\nUse Legacy Tools for now.",
              style: TextStyle(
                  fontSize: 18,
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.w400))
        ])));
  }
}
