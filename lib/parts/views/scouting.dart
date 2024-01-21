import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:scouting_app_2024/blobs/form_blob.dart';
import 'package:scouting_app_2024/blobs/locale_blob.dart';
import 'package:scouting_app_2024/parts/team.dart';
import 'package:scouting_app_2024/parts/views_delegate.dart';
import 'package:scouting_app_2024/user/team_model.dart';

typedef SectionId = ({String title, IconData icon});

class ScoutingView extends StatefulWidget
    implements AppPageViewExporter {
  const ScoutingView({super.key});

  @override
  State<ScoutingView> createState() => _ScoutingViewState();

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

class _ScoutingViewState extends State<ScoutingView>
    with AutomaticKeepAliveClientMixin<ScoutingView> {
  @override
  Widget build(BuildContext context) {
    // MOCKUP, NOT FINAL
    super.build(context);
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: form_grid_2(
          crossAxisCount: 2,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          pattern: <QuiltedGridTile>[
            const QuiltedGridTile(1, 1),
            const QuiltedGridTile(1, 1),
            const QuiltedGridTile(1, 1),
            const QuiltedGridTile(1, 1),
          ],
          children: <Widget>[
            form_sec(context,
                header: (
                  icon: Icons.account_tree_rounded,
                  title: "Match Information"
                ),
                child: form_col(<Widget>[
                  form_label("Scouters",
                      icon: const Icon(Icons.people_rounded),
                      child: form_txtin(dim: 300)),
                  form_label(
                    "Number",
                    icon: const Icon(Icons.numbers_rounded),
                    child: form_txtin(
                        dim: 300, inputType: TextInputType.number),
                  ),
                  form_label("Type",
                      icon: const Icon(Icons.account_tree_rounded),
                      child: form_seg_btn_1(
                          segments: MatchType.values
                              .map<({Icon? icon, String label, MatchType value})>(
                                  (MatchType e) => (
                                        label: formalizeWord(e.name),
                                        icon: const Icon(Icons
                                            .account_tree_rounded),
                                        value: e
                                      ))
                              .toList(),
                          initialSelection: MatchType.qualification,
                          onSelect: (MatchType e) /*TODO*/ {}))
                ])),
            form_sec(context,
                header: (
                  icon: Icons.people_outline_rounded,
                  title: "Team Information"
                ),
                child: form_col(<Widget>[
                  form_label("Team Number",
                      child: form_txtin(
                          dim: 300, inputType: TextInputType.number),
                      icon: const Icon(Icons.numbers_rounded)),
                  form_label("Alliance",
                      icon: const Icon(Icons.flag_rounded),
                      child: TeamAllianceSwitch(
                          onChanged:
                              (TeamAlliance alliance) /*TODO*/ {})),
                  form_label("Starting Position",
                      icon: const Icon(Icons.location_on_rounded),
                      child: form_seg_btn_1(
                          segments: MatchStartingPosition.values
                              .map<({Icon? icon, String label, MatchStartingPosition value})>(
                                  (MatchStartingPosition e) => (
                                        label: formalizeWord(e.name),
                                        icon: const Icon(Icons
                                            .location_on_rounded),
                                        value: e
                                      ))
                              .toList(),
                          initialSelection:
                              MatchStartingPosition.middle,
                          onSelect:
                              (MatchStartingPosition e) /*TODO*/ {}))
                ])),
          ]),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
