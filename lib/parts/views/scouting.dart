import 'package:flutter/material.dart';
import 'package:scouting_app_2024/blobs/form_blob.dart';
import 'package:scouting_app_2024/blobs/locale_blob.dart';
import 'package:scouting_app_2024/parts/team.dart';
import 'package:scouting_app_2024/parts/views_delegate.dart';
import 'package:scouting_app_2024/user/team_model.dart';

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

class PlusMinus extends StatefulWidget {
  // Optional: Add any parameters the widget might need
  final int initialValue;
  final Function(int)? onValueChanged; // callback to return value

  // Constructor
  const PlusMinus({super.key, this.initialValue = 0, this.onValueChanged});

  @override
  // ignore: library_private_types_in_public_api
  _PlusMinusState createState() => _PlusMinusState();
}

class _PlusMinusState extends State<PlusMinus> {
  late int _val;
  final int maxValue = 999;

  @override
  void initState() {
    super.initState();
    _val = widget.initialValue;
  }

  void _updateValue(int newVal) {
    if (newVal >= 0 && newVal <= maxValue) {
      // Check for both minimum and maximum limits
      setState(() {
        _val = newVal;
      });
      if (widget.onValueChanged != null) {
        widget.onValueChanged!(_val);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Color primaryColor = Theme.of(context).primaryColor;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        OutlinedButton(
          onPressed: () => _updateValue(_val - 1),
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.all(16),
            side: BorderSide(color: primaryColor, width: 2),
          ),
          child: const Text("-"),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Text(_val.toString(), style: const TextStyle(fontSize: 20)),
        ),
        OutlinedButton(
          onPressed: () => _updateValue(_val + 1),
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.all(16),
            side: BorderSide(color: primaryColor, width: 2),
          ),
          child: const Text("+"),
        ),
      ],
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
                                              icon: const Icon(
                                                  Icons.location_on_rounded),
                                              value: e
                                            ))
                                    .toList(),
                                initialSelection: MatchStartingPosition.middle,
                                onSelect:
                                    (MatchStartingPosition e) /*TODO*/ {})),
                      ])),
                  form_sec(context,
                      backgroundColor: Colors.transparent,
                      header: (
                        icon: Icons.smart_toy_rounded,
                        title: "Autonomous"
                      ),
                      child: form_col(<Widget>[
                        form_label("Note preloaded before game?",
                            icon: const Icon(Icons.trip_origin),
                            child: form_seg_btn_1(
                                segments: NotePreloaded.values
                                    .map<
                                            ({
                                              Icon? icon,
                                              String label,
                                              NotePreloaded value
                                            })>(
                                        (NotePreloaded e) => (
                                              label: formalizeWord(e.name),
                                              icon:
                                                  const Icon(Icons.trip_origin),
                                              value: e
                                            ))
                                    .toList(),
                                initialSelection: NotePreloaded.yes,
                                onSelect: (NotePreloaded e) /*TODO*/ {})),
                        form_label("Taxis?",
                            icon: const Icon(Icons.local_taxi_rounded),
                            child: form_seg_btn_1(
                                segments: TaxiTrueFalse.values
                                    .map<({Icon? icon, String label, TaxiTrueFalse value})>(
                                        (TaxiTrueFalse e) => (
                                              label: formalizeWord(e.name),
                                              icon: const Icon(
                                                  Icons.local_taxi_rounded),
                                              value: e
                                            ))
                                    .toList(),
                                initialSelection: TaxiTrueFalse.no,
                                onSelect: (TaxiTrueFalse e) /*TODO*/ {})),
                        form_label("Scored in Speaker",
                            icon: const Icon(Icons.volume_up),
                            child: PlusMinus(
                              initialValue: 0,
                              onValueChanged: (int value) {
                                // print("Value changed: $value");
                              },
                            )),
                        form_label("Scored in AMP",
                            icon: const Icon(Icons.music_note),
                            child: PlusMinus(
                              initialValue: 0,
                              onValueChanged: (int value) {
                                // print("Value changed: $value");
                              },
                            )),
                        form_label("Missed",
                            icon: const Icon(Icons.call_missed),
                            child: PlusMinus(
                              initialValue: 0,
                              onValueChanged: (int value) {
                                // print("Value changed: $value");
                              },
                            )),
                        form_label("Comments",
                            icon: const Icon(Icons.comment),
                            child: form_txtin(
                                hint: "Enter your comments here",
                                label: "Comments",
                                prefixIcon: const Icon(Icons.edit),
                                dim: 300, // Adjust the width as needed
                                onChanged: (String value) {
                                    // TODO
                                },
                                inputType: TextInputType.multiline,
                            )),
                      ])),
                  form_sec(context,
                      backgroundColor: Colors.transparent,
                      header: (icon: Icons.accessibility, title: "Tele-op"),
                      child: form_col(<Widget>[
                        form_label("Missed",
                            icon: const Icon(Icons.call_missed),
                            child: PlusMinus(
                              initialValue: 0,
                              onValueChanged: (int value) {
                                // print("Value changed: $value");
                              },
                            )),
                        form_label("Plays Defense",
                            icon: const Icon(Icons.shield),
                            child: form_seg_btn_1(
                                segments: PlaysDefense.values
                                    .map<
                                            ({
                                              Icon? icon,
                                              String label,
                                              PlaysDefense value
                                            })>(
                                        (PlaysDefense e) => (
                                              label: formalizeWord(e.name),
                                              icon:
                                                  const Icon(Icons.shield),
                                              value: e
                                            ))
                                    .toList(),
                                initialSelection: PlaysDefense.no,
                                onSelect: (PlaysDefense e) /*TODO*/ {})),
                        form_label("Was Defended?",
                            icon: const Icon(Icons.verified_user),
                            child: form_seg_btn_1(
                                segments: WasDefended.values
                                    .map<({Icon? icon, String label, WasDefended value})>(
                                        (WasDefended e) => (
                                              label: formalizeWord(e.name),
                                              icon: const Icon(
                                                  Icons.verified_user),
                                              value: e
                                            ))
                                    .toList(),
                                initialSelection: WasDefended.no,
                                onSelect: (WasDefended e) /*TODO*/ {})),
                        form_label("Comments",
                            icon: const Icon(Icons.comment),
                            child: form_txtin(
                                hint: "Enter your comments here",
                                label: "Comments",
                                prefixIcon: const Icon(Icons.edit),
                                dim: 300, // Adjust the width as needed
                                onChanged: (String value) {
                                    // TODO
                                },
                                inputType: TextInputType.multiline,
                            )),
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
