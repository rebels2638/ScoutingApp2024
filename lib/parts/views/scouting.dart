import "package:flutter/material.dart";
import "package:scouting_app_2024/blobs/blobs.dart";
import "package:scouting_app_2024/blobs/form_blob.dart";
import "package:scouting_app_2024/blobs/inc_dec_blob.dart";
import "package:scouting_app_2024/blobs/locale_blob.dart";
import "package:scouting_app_2024/extern/color.dart";
import "package:scouting_app_2024/parts/team.dart";
import "package:scouting_app_2024/parts/views_delegate.dart";
import "package:scouting_app_2024/extern/datetime.dart";
import "package:scouting_app_2024/user/team_model.dart";
import "package:scouting_app_2024/utils.dart";
import "package:theme_provider/theme_provider.dart";
import 'package:scouting_app_2024/debug.dart';

typedef SectionId = ({String title, IconData icon});

class ScoutingView extends StatefulWidget implements AppPageViewExporter {
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
    DateTime timeNow = DateTime
        .now(); // TODO: this has to be linked up to the backend for it to work
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        children: <Widget>[
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
                    ThemeProvider.themeOf(context).data.colorScheme.background,
                    ThemeProvider.themeOf(context).data.colorScheme.background,
                    ThemeProvider.themeOf(context).data.colorScheme.secondary
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
                                  .secondary
                                  .biContrastingColor())),
                      TextSpan(
                          text:
                              "${timeNow.monthName()} ${timeNow.day}, ${timeNow.year}",
                          style: TextStyle(
                              color: ThemeProvider.themeOf(context)
                                  .data
                                  .colorScheme
                                  .secondary
                                  .biContrastingColor()))
                    ]))),
              ),
            ),
          ),
          strut(height: 20),
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
                          "Number ",
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
                                              icon: const Icon(
                                                  Icons.account_tree_rounded),
                                              value: e
                                            ))
                                    .toList(),
                                initialSelection: MatchType.qualification,
                                onSelect: (MatchType e) /*TODO*/ {
                                  Debug()
                                      .info("Switched match type to ${e.name}");
                                }))
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
                                dim: 300, inputType: TextInputType.number),
                            icon: const Icon(Icons.numbers_rounded)),
                        form_label("Alliance",
                            icon: const Icon(Icons.flag_rounded),
                            child: TeamAllianceSwitch(
                                onChanged:
                                    (TeamAlliance alliance) /*TODO*/ {
                                      Debug().info("[TEAM] Alliance: ${alliance.name}");
                                    })),
                        form_label("Starting Position",
                            icon: const Icon(Icons.location_on_rounded),
                            child: form_seg_btn_1(
                                segments: MatchStartingPosition.values
                                    .map<({Icon? icon, String label, MatchStartingPosition value})>(
                                        (MatchStartingPosition e) => (
                                              label: formalizeWord(e.name),
                                              icon: const Icon(
                                                  Icons.location_on_rounded),
                                              value: e
                                            ))
                                    .toList(),
                                initialSelection: MatchStartingPosition.middle,
                                onSelect: (MatchStartingPosition e) /*TODO*/ {
                                  Debug().info(
                                      "[TEAM] Switched starting position to ${e.name}");
                                })),
                      ])),
                  form_sec(context,
                      backgroundColor: Colors.transparent,
                      header: (
                        icon: Icons.smart_toy_rounded,
                        title: "Autonomous"
                      ),
                      child: form_col(<Widget>[
                        form_label("Note preloaded?",
                            icon: const Icon(Icons.trip_origin),
                            child: BasicToggleSwitch(
                                initialValue: false,
                                onChanged: (bool e) /*TODO*/ {
                                  Debug().info("[AUTO] Note preloaded: $e");
                                })),
                        form_label("Picked up Note?",
                            icon: const Icon(Icons.trip_origin),
                            child: form_seg_btn_1(
                                segments: AutoPickup.values
                                    .map<
                                            ({
                                              Icon? icon,
                                              String label,
                                              AutoPickup value
                                            })>(
                                        (AutoPickup e) => (
                                              label: formalizeWord(e.name),
                                              icon:
                                                  const Icon(Icons.trip_origin),
                                              value: e
                                            ))
                                    .toList(),
                                initialSelection: AutoPickup.no,
                                onSelect: (AutoPickup e) /*TODO*/ {
                                  Debug()
                                      .info("[AUTO] Picked up note: ${e.name}");
                                })),
                        form_label("Taxis?",
                            icon: const Icon(Icons.local_taxi_rounded),
                            child: BasicToggleSwitch(
                                initialValue: false,
                                onChanged: (bool e) /*TODO*/ {
                                  Debug().info("[AUTO] Taxis: $e");
                                })),
                        form_label("Scored in Speaker",
                            icon: const Icon(Icons.volume_up),
                            child: PlusMinus(
                              initialValue: 0,
                              onValueChanged: (int value) /*TODO*/ {
                                Debug()
                                    .info("[AUTO] Scored in Speaker: $value");
                              },
                            )),
                        form_label("Missed Speaker Shots",
                            icon: const Icon(Icons.call_missed),
                            child: PlusMinus(
                              initialValue: 0,
                              onValueChanged: (int value) /*TODO*/ {
                                Debug().info(
                                    "[AUTO] Missed Speaker Shots: $value");
                              },
                            )),
                        form_label("Scored in AMP",
                            icon: const Icon(Icons.music_note),
                            child: PlusMinus(
                              initialValue: 0,
                              onValueChanged: (int value) /*TODO*/ {
                                Debug().info("[AUTO] Scored in AMP: $value");
                              },
                            )),
                        form_label("Missed AMP Shots",
                            icon: const Icon(Icons.call_missed),
                            child: PlusMinus(
                              initialValue: 0,
                              onValueChanged: (int value) /*TODO*/ {
                                Debug().info("[AUTO] Missed AMP Shots: $value");
                              },
                            )),
                        form_label("Comments",
                            icon: const Icon(Icons.comment),
                            child: form_txtin(
                              hint: "Enter your comments here",
                              label: "Comments",
                              dim: 300,
                              onChanged: (String value) /*TODO*/ {},
                              inputType: TextInputType.multiline,
                            )),
                      ])),
                  form_sec(context,
                      backgroundColor: Colors.transparent,
                      header: (icon: Icons.accessibility, title: "Tele-op"),
                      child: form_col(<Widget>[
                        form_label("Plays Defense",
                            icon: const Icon(Icons.shield),
                            child: BasicToggleSwitch(
                                initialValue: false,
                                onChanged: (bool e) /*TODO*/ {
                                  Debug().info("[TELE-OP] Plays defense: $e");
                                })),
                        /*
                        form_label("Plays Defense?",
                            icon: const Icon(Icons.shield),
                            child: form_seg_btn_1(
                                segments: GenericUtils.boolOptions()
                                    .map<
                                            ({
                                              Icon? icon,
                                              String label,
                                              bool value
                                            })>(
                                        (bool e) => (
                                              label: e ? "Yes" : "No",
                                              icon: const Icon(Icons.shield),
                                              value: e
                                            ))
                                    .toList(),
                                initialSelection: false,
                                onSelect: (bool e) /*TODO*/ {
                                  Debug().info(
                                      "Plays defense: ${e ? "Yes" : "No"}");
                                })),
                                */
                        form_label("Was Defended?",
                            icon: const Icon(Icons.verified_user),
                            child: BasicToggleSwitch(
                                initialValue: false,
                                onChanged: (bool e) /*TODO*/ {
                                  Debug().info("[TELE-OP] Was Defended: $e");
                                })),
                        form_label("Scored in Speaker",
                            icon: const Icon(Icons.volume_up),
                            child: PlusMinus(
                              initialValue: 0,
                              onValueChanged: (int value) /*TODO*/ {
                                Debug().info(
                                    "[TELE-OP] Scored in Speaker: $value");
                              },
                            )),
                        form_label("Missed Speaker Shots",
                            icon: const Icon(Icons.call_missed),
                            child: PlusMinus(
                              initialValue: 0,
                              onValueChanged: (int value) /*TODO*/ {
                                Debug().info(
                                    "[TELE-OP] Missed Speaker Shots: $value");
                              },
                            )),
                        form_label("Scored in AMP",
                            icon: const Icon(Icons.music_note),
                            child: PlusMinus(
                              initialValue: 0,
                              onValueChanged: (int value) /*TODO*/ {
                                Debug().info("[TELE-OP] Scored in AMP: $value");
                              },
                            )),
                        form_label("Missed AMP Shots",
                            icon: const Icon(Icons.call_missed),
                            child: PlusMinus(
                              initialValue: 0,
                              onValueChanged: (int value) /*TODO*/ {
                                Debug()
                                    .info("[TELE-OP] Missed AMP Shots: $value");
                              },
                            )),
                        form_label("Comments",
                            icon: const Icon(Icons.comment),
                            child: form_txtin(
                              hint: "Enter your comments here",
                              label: "Comments",
                              dim: 300,
                              onChanged: (String value) /*TODO*/ {},
                              inputType: TextInputType.multiline,
                            )),
                        form_label("Driver rating",
                            icon: const Icon(Icons.call_missed),
                            child: PlusMinusRating(
                              initialValue: 0,
                              onValueChanged: (int value) /*TODO*/ {
                                Debug().info(
                                    "Plays defense: ${value > 0 ? "$value" : "Reset to 0"}");
                              },
                            )),
                      ])),
                  form_sec(context,
                      backgroundColor: Colors.transparent,
                      header: (icon: Icons.accessibility, title: "Endgame"),
                      child: form_col(<Widget>[
                        form_label("Status",
                            icon: const Icon(Icons.shield),
                            child: form_seg_btn_1(
                                segments: EndStatus.values
                                    .map<
                                            ({
                                              Icon? icon,
                                              String label,
                                              EndStatus value
                                            })>(
                                        (EndStatus e) => (
                                              label: formalizeWord(e.name),
                                              icon: const Icon(Icons.shield),
                                              value: e
                                            ))
                                    .toList(),
                                initialSelection: EndStatus.parked,
                                onSelect: (EndStatus e) /*TODO*/ {
                                  Debug().info("[ENDGAME] Status: ${e.name}");
                                })),
                        form_label("Harmony (Used same chain)",
                            icon: const Icon(Icons.people),
                            child: form_seg_btn_1(
                                segments: Harmony.values
                                    .map<
                                            ({
                                              Icon? icon,
                                              String label,
                                              Harmony value
                                            })>(
                                        (Harmony e) => (
                                              label: formalizeWord(e.name),
                                              icon: const Icon(Icons.people),
                                              value: e
                                            ))
                                    .toList(),
                                initialSelection: Harmony.no,
                                onSelect: (Harmony e) /*TODO*/ {
                                  Debug().info("[ENDGAME] Harmony: ${e.name}");
                                })),
                        form_label("Scored in Trap",
                            icon: const Icon(Icons.trip_origin),
                            child: form_seg_btn_1(
                                segments: TrapScored.values
                                    .map<
                                            ({
                                              Icon? icon,
                                              String label,
                                              TrapScored value
                                            })>(
                                        (TrapScored e) => (
                                              label: formalizeWord(e.name),
                                              icon:
                                                  const Icon(Icons.trip_origin),
                                              value: e
                                            ))
                                    .toList(),
                                initialSelection: TrapScored.no,
                                onSelect: (TrapScored e) /*TODO*/ {
                                  Debug().info("[ENDGAME] Scored in trap: ${e.name}");
                                })),
                        form_label("Comments",
                            icon: const Icon(Icons.comment),
                            child: form_txtin(
                              hint: "Enter your comments here",
                              label: "Comments",
                              dim: 300,
                              onChanged: (String value) /*TODO*/ {},
                              inputType: TextInputType.multiline,
                            )),
                      ])),
                  form_sec(context,
                      backgroundColor: Colors.transparent,
                      header: (icon: Icons.accessibility, title: "Other"),
                      child: form_col(<Widget>[
                        form_label("Coopertition",
                            icon: const Icon(Icons.groups),
                            child: BasicToggleSwitch(
                                initialValue: false,
                                onChanged: (bool e) /*TODO*/ {
                                  Debug().info("[OTHER] Coopertition: $e");
                                })),
                        form_label("Breakdown",
                            icon: const Icon(Icons.handyman),
                            child: BasicToggleSwitch(
                                initialValue: false,
                                onChanged: (bool e) /*TODO*/ {
                                  Debug().info("[OTHER] Breakdown: $e");
                                })),
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
