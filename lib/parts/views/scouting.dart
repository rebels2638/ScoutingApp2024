import 'package:flutter/material.dart';
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
    // DateTime timeNow = DateTime
    //    .now(); // TODO: this has to be linked up to the backend for it to work
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        children: <Widget>[
          /*
          Flexible(
            flex: 0,
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  gradient: LinearGradient(stops: const <double>[
                    0.175,
                    0.45,
                    0.55,
                    0.975
                  ], colors: <Color>[
                    ThemeProvider.themeOf(context)
                        .data
                        .colorScheme
                        .inversePrimary,
                    ThemeProvider.themeOf(context)
                        .data
                        .colorScheme
                        .background,
                    ThemeProvider.themeOf(context)
                        .data
                        .colorScheme
                        .background,
                    ThemeProvider.themeOf(context)
                        .data
                        .colorScheme
                        .inverseSurface
                  ])),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: form_label("Timestamp: ",
                    icon: svgIcon(
                        "assets/icons/pace_FILL0_wght400_GRAD0_opsz24.svg"),
                    child: Text.rich(TextSpan(children: <TextSpan>[
                      TextSpan(
                          text:
                              "${timeNow.hour}:${timeNow.minute}:${timeNow.second}.${timeNow.millisecond}\t",
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: ThemeProvider.themeOf(context)
                                  .data
                                  .colorScheme
                                  .inverseSurface
                                  .biContrastingColor())),
                      TextSpan(
                          text:
                              "${timeNow.monthName()} ${timeNow.day}, ${timeNow.year}",
                          style: TextStyle(
                              color: ThemeProvider.themeOf(context)
                                  .data
                                  .colorScheme
                                  .inverseSurface
                                  .biContrastingColor()))
                    ]))),
              ),
            ),
          ),
          strut(height: 20),
          */
          Flexible(
            child: form_grid_2(
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                children: <Widget>[
                  form_sec(context,
                      backgroundColor: Colors.transparent,
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
                              dim: 300,
                              inputType: TextInputType.number),
                        ),
                        form_label("Type",
                            icon: const Icon(
                                Icons.account_tree_rounded),
                            child: form_seg_btn_1(
                                segments: MatchType.values
                                    .map<({Icon? icon, String label, MatchType value})>(
                                        (MatchType e) => (
                                              label: formalizeWord(
                                                  e.name),
                                              icon: const Icon(Icons
                                                  .account_tree_rounded),
                                              value: e
                                            ))
                                    .toList(),
                                initialSelection:
                                    MatchType.qualification,
                                onSelect: (MatchType e) /*TODO*/ {}))
                      ])),
                  form_sec(context,
                      backgroundColor: Colors.transparent,
                      header: (
                        icon: Icons.people_outline_rounded,
                        title: "Team Information"
                      ),
                      // for each of these information sections, no need to mention the individual word again like "[team] number"
                      child: form_col(<Widget>[
                        form_label("Number",
                            child: form_txtin(
                                dim: 300,
                                inputType: TextInputType.number),
                            icon: const Icon(Icons.numbers_rounded)),
                        form_label("Alliance",
                            icon: const Icon(Icons.flag_rounded),
                            child: TeamAllianceSwitch(
                                onChanged: (TeamAlliance
                                    alliance) /*TODO*/ {})),
                        form_label("Starting Position",
                            icon:
                                const Icon(Icons.location_on_rounded),
                            child: form_seg_btn_1(
                                segments: MatchStartingPosition.values
                                    .map<
                                            ({
                                              Icon? icon,
                                              String label,
                                              MatchStartingPosition value
                                            })>(
                                        (MatchStartingPosition e) => (
                                              label: formalizeWord(
                                                  e.name),
                                              icon: const Icon(Icons
                                                  .location_on_rounded),
                                              value: e
                                            ))
                                    .toList(),
                                initialSelection:
                                    MatchStartingPosition.middle,
                                onSelect: (MatchStartingPosition
                                    e) /*TODO*/ {}))
                      ])),
                  form_sec(context,
                      backgroundColor: Colors.transparent,
                      header: (
                        icon: Icons.smart_toy_rounded,
                        title: "Autonomous"
                      ),
                      child: form_col(<Widget>[
                        form_label("Taxis?",
                            icon:
                                const Icon(Icons.location_on_rounded),
                            child: form_seg_btn_1(
                                segments: TaxiTrueFalse.values
                                    .map<
                                            ({
                                              Icon? icon,
                                              String label,
                                              TaxiTrueFalse value
                                            })>(
                                        (TaxiTrueFalse e) => (
                                              label: formalizeWord(
                                                  e.name),
                                              icon: const Icon(Icons
                                                  .location_on_rounded),
                                              value: e
                                            ))
                                    .toList(),
                                initialSelection:
                                    TaxiTrueFalse.yes,
                                onSelect: (TaxiTrueFalse
                                    e) /*TODO*/ {}))
                      ])),
                ]),
          ),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
