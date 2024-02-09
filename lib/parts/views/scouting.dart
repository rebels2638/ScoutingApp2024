import "dart:convert";

import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:scouting_app_2024/blobs/blobs.dart";
import "package:scouting_app_2024/blobs/form_blob.dart";
import "package:scouting_app_2024/blobs/inc_dec_blob.dart";
import "package:scouting_app_2024/blobs/locale_blob.dart";
import "package:scouting_app_2024/parts/bits/show_experimental.dart";
import "package:scouting_app_2024/user/models/epehemeral_data.dart";
import 'package:scouting_app_2024/user/models/team_bloc.dart';
import "package:scouting_app_2024/parts/team.dart";
import "package:scouting_app_2024/parts/views_delegate.dart";
import 'package:scouting_app_2024/user/models/team_model.dart';
import 'package:scouting_app_2024/debug.dart';
import 'package:community_material_icon/community_material_icon.dart';
import "package:scouting_app_2024/user/scouting_telemetry.dart";

typedef SectionId = ({String title, IconData icon});

// so much boilerplate bruh lmao
class ScoutingSessionViewDelegate extends StatelessWidget
    implements AppPageViewExporter {
  const ScoutingSessionViewDelegate({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ScoutingSessionBloc>(
        create: (BuildContext _) => ScoutingSessionBloc(),
        child: _ScoutingSessionViewDelegate());
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

class _ScoutingSessionViewDelegate extends StatefulWidget {
  @override
  State<_ScoutingSessionViewDelegate> createState() =>
      _ScoutingSessionViewDelegateState();
}

class _ScoutingSessionViewDelegateState
    extends State<_ScoutingSessionViewDelegate> {
  late bool _showScoutingSession;

  @override
  void initState() {
    super.initState();
    _showScoutingSession = false;
  }

  @override
  Widget build(BuildContext context) {
    return _showScoutingSession
        ? const ScoutingView()
        : Center(
            // i feel liek this useless
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: strutAll(<Widget>[
                  const Text("Scouting Session",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 24)),
                  ElevatedButton(
                      style: ButtonStyle(
                          shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(16)))),
                      onPressed: () {
                        Debug().info(
                            "Moving from SCOUTING_SESSION_LAUNCHER to SCOUTING_SESSION");
                        setState(() => _showScoutingSession = true);
                      },
                      child: Padding(
                        // a lot of the constraints here come from here: https://m3.material.io/components/floating-action-button/specs
                        // altho kind shitty lmao, fuck it
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                            mainAxisAlignment:
                                MainAxisAlignment.center,
                            children: <Widget>[
                              const Icon(
                                  Icons.pending_actions_rounded),
                              strut(height: 14),
                              const Text.rich(
                                  TextSpan(children: <InlineSpan>[
                                    TextSpan(
                                        text: "New Session\n",
                                        style: TextStyle(
                                            fontWeight:
                                                FontWeight.w600,
                                            fontSize: 18)),
                                    TextSpan(
                                        text:
                                            "Launch a new scouting form",
                                        style: TextStyle(
                                            fontWeight:
                                                FontWeight.w400,
                                            fontSize: 12))
                                  ]),
                                  textAlign: TextAlign.center)
                            ]),
                      )),
                ], height: 78)),
          );
  }
}

class ScoutingView extends StatefulWidget {
  const ScoutingView({super.key});

  @override
  State<ScoutingView> createState() => _ScoutingViewState();
}

class _ScoutingViewState extends State<ScoutingView>
    with AutomaticKeepAliveClientMixin<ScoutingView> {
  @override
  Widget build(BuildContext context) {
    // MOCKUP, NOT FINAL
    super.build(context);
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        children: <Widget>[
          Flexible(
              flex: 0,
              child: Wrap(
                  children: strutAll(<Widget>[
                FilledButton.icon(
                    style: ButtonStyle(
                        shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(8)))),
                    icon: const Icon(Icons.exit_to_app_rounded),
                    label: const Text("Exit Session"),
                    onPressed: () {}),
                FilledButton.icon(
                    style: ButtonStyle(
                        shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(8)))),
                    icon:
                        const Icon(Icons.bluetooth_connected_rounded),
                    label: const Text("Beam Session"),
                    onPressed: () {}),
                FilledButton.icon(
                    style: ButtonStyle(
                        shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(8)))),
                    icon: const Icon(CommunityMaterialIcons.qrcode),
                    label: const Text("Export Session"),
                    onPressed: () {}),
                FilledButton.icon(
                    style: ButtonStyle(
                        shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(8)))),
                    icon: const Icon(Icons.save_rounded),
                    label: const Text("Save Session"),
                    onPressed: () {
                      EphemeralScoutingData data =
                          EphemeralScoutingData.fromHollistic(context
                              .read<ScoutingSessionBloc>()
                              .exportHollistic());
                      ScoutingTelemetry().put(data);
                      Debug().info(
                          "Saved an entry of ${data.id}=${data.toString()}");
                    }),
                if (ShowExperimentalModal.isShowingExperimental(context))
                  FilledButton.icon(
                      style: ButtonStyle(
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(8)))),
                      icon:
                          const Icon(Icons.spatial_tracking_rounded),
                      label: const Text("View Raw"),
                      onPressed: () async => await launchConfirmDialog(
                          context,
                          message: Text.rich(TextSpan(
                              text:
                                  "RAW\n${jsonEncode(context.read<ScoutingSessionBloc>().exportMapDeep().toString())}\n\nHollistic\n${jsonEncode(context.read<ScoutingSessionBloc>().exportHollistic().toString())}\n\nEphemeral\n${EphemeralScoutingData.fromHollistic(context.read<ScoutingSessionBloc>().exportHollistic())}")),
                          onConfirm: () {})),
              ], width: 12))),
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
                          child: form_numpick(context,
                              label: "Picker",
                              icon: const Icon(
                                  CommunityMaterialIcons.counter),
                              minValue: 1,
                              maxValue: 999,
                              headerMessage: "Match Number",
                              onChange: (int number) {
                            Debug().info(
                                "UPDATE match number to $number");
                            context
                                .read<ScoutingSessionBloc>()
                                .prelim
                                .matchNumber = number;
                            context
                                .read<ScoutingSessionBloc>()
                                .add(PrelimUpdateEvent());
                          }),
                        ),
                        form_label("Type",
                            icon: const Icon(
                                Icons.account_tree_rounded),
                            child: form_seg_btn_1(
                                segments: MatchType.values
                                    .map<
                                            ({
                                              Icon? icon,
                                              String label,
                                              MatchType value
                                            })>(
                                        (MatchType e) => (
                                              label: formalizeWord(
                                                  e.name),
                                              icon: null,
                                              value: e
                                            ))
                                    .toList(),
                                initialSelection:
                                    MatchType.qualification,
                                onSelect: (MatchType e) {
                                  Debug().info(
                                      "Switched match type to ${e.name}");
                                  context
                                      .read<ScoutingSessionBloc>()
                                      .prelim
                                      .matchType = e;
                                  context
                                      .read<ScoutingSessionBloc>()
                                      .add(PrelimUpdateEvent());
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
                            child: form_numpick(context,
                                label: "Picker",
                                icon: const Icon(
                                    CommunityMaterialIcons.counter),
                                minValue: 1,
                                maxValue: 9999,
                                headerMessage: "Team Number",
                                onChange: (int number) {
                              Debug().info(
                                  "UPDATE team number to $number");
                              context
                                  .read<ScoutingSessionBloc>()
                                  .prelim
                                  .teamNumber = number;
                              context
                                  .read<ScoutingSessionBloc>()
                                  .add(PrelimUpdateEvent());
                            }),
                            icon: const Icon(Icons.numbers_rounded)),
                        form_label("Alliance",
                            icon: const Icon(Icons.flag_rounded),
                            child: TeamAllianceSwitch(
                                onChanged: (TeamAlliance alliance) {
                          Debug().info(
                              "[TEAM] Alliance: ${alliance.name}");
                          context
                              .read<ScoutingSessionBloc>()
                              .prelim
                              .alliance = alliance;
                          context
                              .read<ScoutingSessionBloc>()
                              .add(PrelimUpdateEvent());
                        })),
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
                                              icon: null,
                                              value: e
                                            ))
                                    .toList(),
                                initialSelection:
                                    MatchStartingPosition.middle,
                                onSelect: (MatchStartingPosition e) {
                                  Debug().info(
                                      "[TEAM] Switched starting position to ${e.name}");
                                  context
                                      .read<ScoutingSessionBloc>()
                                      .prelim
                                      .startingPosition = e;
                                  context
                                      .read<ScoutingSessionBloc>()
                                      .add(PrelimUpdateEvent());
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
                                onChanged: (bool e) {
                                  Debug().info(
                                      "[AUTO] Note preloaded: $e");
                                  context
                                      .read<ScoutingSessionBloc>()
                                      .auto
                                      .notePreloaded = e;
                                  context
                                      .read<ScoutingSessionBloc>()
                                      .add(AutoUpdateEvent());
                                })),
                        form_label("Picked up Note?",
                            icon: const Icon(Icons.trip_origin),
                            child: form_seg_btn_2(
                                segments: AutoPickup.values
                                    .map<
                                            ({
                                              Icon? icon,
                                              String label,
                                              AutoPickup value
                                            })>(
                                        (AutoPickup e) => (
                                              label: formalizeWord(
                                                  e.name),
                                              icon: null,
                                              value: e
                                            ))
                                    .toList(),
                                initialSelection: <AutoPickup>{
                                  AutoPickup.no
                                },
                                onSelect: (List<AutoPickup> e) {
                                  Debug().info(
                                      "[AUTO] Picked up note: ${e.toString()}");
                                  context
                                      .read<ScoutingSessionBloc>()
                                      .auto
                                      .notesPickedUp = e;
                                  context
                                      .read<ScoutingSessionBloc>()
                                      .add(AutoUpdateEvent());
                                })),
                        form_label("Taxis?",
                            icon:
                                const Icon(Icons.local_taxi_rounded),
                            child: BasicToggleSwitch(
                                initialValue: false,
                                onChanged: (bool e) {
                                  Debug().info("[AUTO] Taxis: $e");
                                  context
                                      .read<ScoutingSessionBloc>()
                                      .auto
                                      .taxi = e;
                                  context
                                      .read<ScoutingSessionBloc>()
                                      .add(AutoUpdateEvent());
                                })),
                        form_label("Scored in Speaker",
                            icon: const Icon(Icons.volume_up),
                            child: PlusMinus(
                              initialValue: 0,
                              onValueChanged: (int value) {
                                Debug().info(
                                    "[AUTO] Scored in Speaker: $value");
                                context
                                    .read<ScoutingSessionBloc>()
                                    .auto
                                    .scoredSpeaker = value;
                                context
                                    .read<ScoutingSessionBloc>()
                                    .add(AutoUpdateEvent());
                              },
                            )),
                        form_label("Missed Speaker Shots",
                            icon: const Icon(Icons.call_missed),
                            child: PlusMinus(
                              initialValue: 0,
                              onValueChanged: (int value) {
                                Debug().info(
                                    "[AUTO] Missed Speaker Shots: $value");
                                context
                                    .read<ScoutingSessionBloc>()
                                    .auto
                                    .missedSpeaker = value;
                                context
                                    .read<ScoutingSessionBloc>()
                                    .add(AutoUpdateEvent());
                              },
                            )),
                        form_label("Scored in AMP",
                            icon: const Icon(Icons.music_note),
                            child: PlusMinus(
                              initialValue: 0,
                              onValueChanged: (int value) {
                                Debug().info(
                                    "[AUTO] Scored in AMP: $value");
                                context
                                    .read<ScoutingSessionBloc>()
                                    .auto
                                    .scoredAmp = value;
                                context
                                    .read<ScoutingSessionBloc>()
                                    .add(AutoUpdateEvent());
                              },
                            )),
                        form_label("Missed AMP Shots",
                            icon: const Icon(Icons.call_missed),
                            child: PlusMinus(
                              initialValue: 0,
                              onValueChanged: (int value) {
                                Debug().info(
                                    "[AUTO] Missed AMP Shots: $value");
                                context
                                    .read<ScoutingSessionBloc>()
                                    .auto
                                    .missedAmp = value;
                                context
                                    .read<ScoutingSessionBloc>()
                                    .add(AutoUpdateEvent());
                              },
                            )),
                        form_label("Comments",
                            icon: const Icon(Icons.comment),
                            child: form_txtin(
                              hint: "Enter your comments here",
                              label: "Comments",
                              dim: 300,
                              onChanged: (String value) {
                                Debug()
                                    .info("[AUTO] Comments: $value");
                                context
                                    .read<ScoutingSessionBloc>()
                                    .auto
                                    .comments = value;
                                context
                                    .read<ScoutingSessionBloc>()
                                    .add(AutoUpdateEvent());
                              },
                              inputType: TextInputType.multiline,
                            )),
                      ])),
                  form_sec(context,
                      backgroundColor: Colors.transparent,
                      header: (
                        icon: Icons.accessibility,
                        title: "Tele-op"
                      ),
                      child: form_col(<Widget>[
                        form_label("Plays Defense",
                            icon: const Icon(Icons.shield),
                            child: BasicToggleSwitch(
                                initialValue: false,
                                onChanged: (bool e) {
                                  Debug().info(
                                      "[TELE-OP] Plays defense: $e");
                                  context
                                      .read<ScoutingSessionBloc>()
                                      .teleop
                                      .playsDefense = e;
                                  context
                                      .read<ScoutingSessionBloc>()
                                      .add(TeleOpUpdateEvent());
                                })),
                        form_label("Was Defended?",
                            icon: const Icon(Icons.verified_user),
                            child: BasicToggleSwitch(
                                initialValue: false,
                                onChanged: (bool e) {
                                  Debug().info(
                                      "[TELE-OP] Was Defended: $e");
                                  context
                                      .read<ScoutingSessionBloc>()
                                      .teleop
                                      .wasDefended = e;
                                  context
                                      .read<ScoutingSessionBloc>()
                                      .add(TeleOpUpdateEvent());
                                })),
                        form_label("Scored in Speaker",
                            icon: const Icon(Icons.volume_up),
                            child: PlusMinus(
                              initialValue: 0,
                              onValueChanged: (int value) {
                                Debug().info(
                                    "[TELE-OP] Scored in Speaker: $value");
                                context
                                    .read<ScoutingSessionBloc>()
                                    .teleop
                                    .scoredSpeaker = value;
                                context
                                    .read<ScoutingSessionBloc>()
                                    .add(TeleOpUpdateEvent());
                              },
                            )),
                        form_label("Scored during AMP",
                            icon: const Icon(Icons.volume_up),
                            child: PlusMinus(
                              initialValue: 0,
                              onValueChanged: (int value) {
                                Debug().info(
                                    "[TELE-OP] Scored during AMP: $value");
                                context
                                    .read<ScoutingSessionBloc>()
                                    .teleop
                                    .scoredWhileAmped = value;
                                context
                                    .read<ScoutingSessionBloc>()
                                    .add(TeleOpUpdateEvent());
                              },
                            )),
                        form_label("Missed Speaker Shots",
                            icon: const Icon(Icons.call_missed),
                            child: PlusMinus(
                              initialValue: 0,
                              onValueChanged: (int value) {
                                Debug().info(
                                    "[TELE-OP] Missed Speaker Shots: $value");
                                context
                                    .read<ScoutingSessionBloc>()
                                    .teleop
                                    .missedSpeaker = value;
                                context
                                    .read<ScoutingSessionBloc>()
                                    .add(TeleOpUpdateEvent());
                              },
                            )),
                        form_label("Scored in AMP",
                            icon: const Icon(Icons.music_note),
                            child: PlusMinus(
                              initialValue: 0,
                              onValueChanged: (int value) {
                                Debug().info(
                                    "[TELE-OP] Scored in AMP: $value");
                                context
                                    .read<ScoutingSessionBloc>()
                                    .teleop
                                    .scoredAmp = value;
                                context
                                    .read<ScoutingSessionBloc>()
                                    .add(TeleOpUpdateEvent());
                              },
                            )),
                        form_label("Missed AMP Shots",
                            icon: const Icon(Icons.call_missed),
                            child: PlusMinus(
                              initialValue: 0,
                              onValueChanged: (int value) {
                                Debug().info(
                                    "[TELE-OP] Missed AMP Shots: $value");
                                context
                                    .read<ScoutingSessionBloc>()
                                    .teleop
                                    .missedAmp = value;
                                context
                                    .read<ScoutingSessionBloc>()
                                    .add(TeleOpUpdateEvent());
                              },
                            )),
                        form_label("Driver rating",
                            icon: const Icon(Icons.call_missed),
                            child: PlusMinusRating(
                              initialValue: 0,
                              onValueChanged: (int value) {
                                Debug().info(
                                    "[TELE-OP] Driver Rating: ${value > 0 ? "$value" : "Reset to 0"}");
                                context
                                    .read<ScoutingSessionBloc>()
                                    .teleop
                                    .driverRating = value;
                                context
                                    .read<ScoutingSessionBloc>()
                                    .add(TeleOpUpdateEvent());
                              },
                            )),
                        form_label("Comments",
                            icon: const Icon(Icons.comment),
                            child: form_txtin(
                              hint: "Enter your comments here",
                              label: "Comments",
                              dim: 300,
                              onChanged: (String value) {
                                Debug().info(
                                    "[TELE-OP] Comments: $value");
                                context
                                    .read<ScoutingSessionBloc>()
                                    .teleop
                                    .comments = value;
                                context
                                    .read<ScoutingSessionBloc>()
                                    .add(TeleOpUpdateEvent());
                              },
                              inputType: TextInputType.multiline,
                            )),
                      ])),
                  form_sec(context,
                      backgroundColor: Colors.transparent,
                      header: (
                        icon: Icons.accessibility,
                        title: "Endgame"
                      ),
                      child: form_col(<Widget>[
                        form_label("On chain",
                            icon: const Icon(Icons.link),
                            child: BasicToggleSwitch(
                                initialValue: false,
                                onChanged: (bool e) {
                                  Debug()
                                      .info("[ENDGAME] On chain: $e");
                                  context
                                      .read<ScoutingSessionBloc>()
                                      .endgame
                                      .onChain = e;
                                  context
                                      .read<ScoutingSessionBloc>()
                                      .add(EndgameUpdateEvent());
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
                                              label: formalizeWord(
                                                  e.name),
                                              icon: null,
                                              value: e
                                            ))
                                    .toList(),
                                initialSelection: Harmony.no,
                                onSelect: (Harmony e) {
                                  Debug().info(
                                      "[ENDGAME] Harmony: ${e.name}");
                                  context
                                      .read<ScoutingSessionBloc>()
                                      .endgame
                                      .harmony = e;
                                  context
                                      .read<ScoutingSessionBloc>()
                                      .add(EndgameUpdateEvent());
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
                                              label: formalizeWord(
                                                  e.name),
                                              icon: null,
                                              value: e
                                            ))
                                    .toList(),
                                initialSelection: TrapScored.no,
                                onSelect: (TrapScored e) {
                                  Debug().info(
                                      "[ENDGAME] Scored in trap: ${e.name}");
                                  context
                                      .read<ScoutingSessionBloc>()
                                      .endgame
                                      .trapScored = e;
                                  context
                                      .read<ScoutingSessionBloc>()
                                      .add(EndgameUpdateEvent());
                                })),
                        form_label("Human Scored on Mic",
                            icon: const Icon(Icons.trip_origin),
                            child: form_seg_btn_1(
                                segments: MicScored.values
                                    .map<
                                            ({
                                              Icon? icon,
                                              String label,
                                              MicScored value
                                            })>(
                                        (MicScored e) => (
                                              label: formalizeWord(
                                                  e.name),
                                              icon: null,
                                              value: e
                                            ))
                                    .toList(),
                                initialSelection: MicScored.no,
                                onSelect: (MicScored e) {
                                  Debug().info(
                                      "[ENDGAME] Scored on mic: ${e.name}");
                                  context
                                      .read<ScoutingSessionBloc>()
                                      .endgame
                                      .micScored = e;
                                  context
                                      .read<ScoutingSessionBloc>()
                                      .add(EndgameUpdateEvent());
                                })),
                        form_label("Comments",
                            icon: const Icon(Icons.comment),
                            child: form_txtin(
                              hint: "Enter your comments here",
                              label: "Comments",
                              dim: 300,
                              onChanged: (String value) {
                                Debug().info(
                                    "[ENDGAME] Comments: $value");
                                context
                                    .read<ScoutingSessionBloc>()
                                    .endgame
                                    .comments = value;
                                context
                                    .read<ScoutingSessionBloc>()
                                    .add(EndgameUpdateEvent());
                              },
                              inputType: TextInputType.multiline,
                            )),
                      ])),
                  form_sec(context,
                      backgroundColor: Colors.transparent,
                      header: (
                        icon: Icons.accessibility,
                        title: "Other"
                      ),
                      child: form_col(<Widget>[
                        form_label("Coopertition",
                            icon: const Icon(Icons.groups),
                            child: BasicToggleSwitch(
                                initialValue: false,
                                onChanged: (bool e) {
                                  Debug().info(
                                      "[OTHER] Coopertition: $e");
                                  context
                                      .read<ScoutingSessionBloc>()
                                      .misc
                                      .coopertition = e;
                                  context
                                      .read<ScoutingSessionBloc>()
                                      .add(MiscUpdateEvent());
                                })),
                        form_label("Breakdown",
                            icon: const Icon(Icons.handyman),
                            child: BasicToggleSwitch(
                                initialValue: false,
                                onChanged: (bool e) {
                                  Debug()
                                      .info("[OTHER] Breakdown: $e");
                                  context
                                      .read<ScoutingSessionBloc>()
                                      .misc
                                      .breakdown = e;
                                  context
                                      .read<ScoutingSessionBloc>()
                                      .add(MiscUpdateEvent());
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
