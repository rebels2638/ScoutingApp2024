import "dart:convert";

import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:scouting_app_2024/blobs/basic_toggle_switch.dart";
import "package:scouting_app_2024/blobs/blobs.dart";
import "package:scouting_app_2024/blobs/form_blob.dart";
import "package:scouting_app_2024/blobs/inc_dec_blob.dart";
import "package:scouting_app_2024/blobs/locale_blob.dart";
import "package:scouting_app_2024/parts/bits/prefer_compact.dart";
import "package:scouting_app_2024/parts/bits/show_console.dart";
import "package:scouting_app_2024/parts/bits/use_alt_layout.dart";
import "package:scouting_app_2024/user/models/ephemeral_data.dart";
import 'package:scouting_app_2024/user/models/team_bloc.dart';
import "package:scouting_app_2024/parts/team.dart";
import "package:scouting_app_2024/parts/views_delegate.dart";
import 'package:scouting_app_2024/user/models/team_model.dart';
import 'package:scouting_app_2024/debug.dart';
import 'package:community_material_icon/community_material_icon.dart';
import "package:scouting_app_2024/user/scouting_telemetry.dart";
import "package:scouting_app_2024/user/user_telemetry.dart";

typedef SectionId = ({String title, IconData icon});

ScoutingSessionBloc? _currBloc;

// so much boilerplate bruh lmao
class ScoutingSessionViewDelegate extends StatelessWidget
    implements AppPageViewExporter {
  const ScoutingSessionViewDelegate({super.key});

  @override
  Widget build(BuildContext context) {
    return _ScoutingSessionViewDelegate();
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
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      // i feel liek this useless
      child: Builder(builder: (BuildContext context) {
        return AnimatedSwitcher(
            duration: const Duration(milliseconds: 500),
            switchInCurve: Curves.easeIn,
            switchOutCurve: Curves.easeOut,
            transitionBuilder:
                (Widget child, Animation<double> animation) {
              return SlideTransition(
                position: Tween<Offset>(
                        begin: const Offset(0, 1),
                        end: const Offset(0, 0))
                    .animate(animation),
                child: child,
              );
            },
            child: _currBloc == null
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                        const Text("Scouting Session",
                            style: TextStyle(
                                fontWeight: FontWeight.w800,
                                fontSize: 32)),
                        const SizedBox(height: 34),
                        Tooltip(
                          message:
                              "${UserTelemetry().currentModel.usedTimeHours} hours",
                          child: Text.rich(
                              TextSpan(children: <InlineSpan>[
                            const WidgetSpan(
                                child: Padding(
                              padding: EdgeInsets.only(right: 8),
                              child: Icon(Icons.timeline_rounded,
                                  size: 18),
                            )),
                            const TextSpan(
                                text: "Usage Time:",
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold)),
                            TextSpan(
                                text:
                                    " ${UserTelemetry().currentModel.usedTimeHours.toStringAsFixed(2)} hours",
                                style: const TextStyle(fontSize: 18)),
                          ])),
                        ),
                        const SizedBox(height: 34),
                        ElevatedButton(
                            style: ButtonStyle(
                                shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(
                                                16)))),
                            onPressed: () {
                              setState(() {
                                _currBloc ??= ScoutingSessionBloc();
                                Debug().warn(
                                    "Pushed a new scouting session");
                              });
                            },
                            child: const Padding(
                              // a lot of the constraints here come from here: https://m3.material.io/components/floating-action-button/specs
                              // altho kind shitty lmao, fuck it
                              padding: EdgeInsets.all(16.0),
                              child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.center,
                                  children: <Widget>[
                                    Icon(Icons
                                        .pending_actions_rounded),
                                    SizedBox(height: 14),
                                    Text.rich(
                                        TextSpan(
                                            children: <InlineSpan>[
                                              TextSpan(
                                                  text:
                                                      "New Session\n",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight
                                                              .w600,
                                                      fontSize: 18)),
                                              TextSpan(
                                                  text:
                                                      "Launch a new scouting form",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight
                                                              .w400,
                                                      fontSize: 12))
                                            ]),
                                        textAlign: TextAlign.center)
                                  ]),
                            )),
                      ])
                : BlocProvider<ScoutingSessionBloc>(
                    create: (BuildContext _) => _currBloc!,
                    child: const ScoutingView()));
      }),
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
    List<Widget> bruh = <Widget>[
      form_sec(context,
          backgroundColor: Colors.transparent,
          header: (
            icon: Icons.account_tree_rounded,
            title: "Match Information"
          ),
          child: form_col(<Widget>[
            form_label("Scouters",
                icon: const Icon(Icons.people_rounded),
                child: form_txtin()),
            form_label(
              "Number ",
              icon: const Icon(Icons.numbers_rounded),
              child: form_numpick(context,
                  label: "Picker",
                  icon: const Icon(CommunityMaterialIcons.counter),
                  minValue: 1,
                  maxValue: 999,
                  headerMessage: "Match Number",
                  onChange: (int number) {
                Debug().info("UPDATE match number to $number");
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
                icon: const Icon(Icons.account_tree_rounded),
                child: form_seg_btn_1(
                    segments: MatchType.values
                        .map<
                                ({
                                  Icon? icon,
                                  String label,
                                  MatchType value
                                })>(
                            (MatchType e) => (
                                  label: formalizeWord(e.name),
                                  icon: null,
                                  value: e
                                ))
                        .toList(),
                    initialSelection: MatchType.qualification,
                    onSelect: (MatchType e) {
                      Debug()
                          .info("Switched match type to ${e.name}");
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
                    icon: const Icon(CommunityMaterialIcons.counter),
                    minValue: 1,
                    maxValue: 9999,
                    headerMessage: "Team Number",
                    onChange: (int number) {
                  Debug().info("UPDATE team number to $number");
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
                icon: const Icon(Icons.flag_rounded), child:
                    TeamAllianceSwitch(
                        onChanged: (TeamAlliance alliance) {
              Debug().info("[TEAM] Alliance: ${alliance.name}");
              context.read<ScoutingSessionBloc>().prelim.alliance =
                  alliance;
              context
                  .read<ScoutingSessionBloc>()
                  .add(PrelimUpdateEvent());
            })),
            form_label("Starting Position",
                icon: const Icon(Icons.location_on_rounded),
                child: form_seg_btn_1(
                    segments: MatchStartingPosition.values
                        .map<
                                ({
                                  Icon? icon,
                                  String label,
                                  MatchStartingPosition value
                                })>(
                            (MatchStartingPosition e) => (
                                  label: formalizeWord(e.name),
                                  icon: null,
                                  value: e
                                ))
                        .toList(),
                    initialSelection: MatchStartingPosition.middle,
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
                      Debug().info("[AUTO] Note preloaded: $e");
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
                                  label: formalizeWord(e.name),
                                  icon: null,
                                  value: e
                                ))
                        .toList(),
                    initialSelection: <AutoPickup>{AutoPickup.no},
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
                icon: const Icon(Icons.local_taxi_rounded),
                child: BasicToggleSwitch(
                    initialValue: false,
                    onChanged: (bool e) {
                      Debug().info("[AUTO] Taxis: $e");
                      context.read<ScoutingSessionBloc>().auto.taxi =
                          e;
                      context
                          .read<ScoutingSessionBloc>()
                          .add(AutoUpdateEvent());
                    })),
            form_label("Scored in Speaker",
                icon: const Icon(Icons.volume_up),
                child: PlusMinus(
                  initialValue: 0,
                  onValueChanged: (int value) {
                    Debug().info("[AUTO] Scored in Speaker: $value");
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
                    Debug()
                        .info("[AUTO] Missed Speaker Shots: $value");
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
                    Debug().info("[AUTO] Scored in AMP: $value");
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
                    Debug().info("[AUTO] Missed AMP Shots: $value");
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
                  onChanged: (String value) {
                    Debug().info("[AUTO] Comments: $value");
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
            icon: Icons.accessibility_rounded,
            title: "Tele-op"
          ),
          child: form_col(<Widget>[
            form_label("Plays Defense",
                icon: const Icon(Icons.shield),
                child: BasicToggleSwitch(
                    initialValue: false,
                    onChanged: (bool e) {
                      Debug().info("[TELE-OP] Plays defense: $e");
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
                      Debug().info("[TELE-OP] Was Defended: $e");
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
                    Debug()
                        .info("[TELE-OP] Scored in Speaker: $value");
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
                    Debug()
                        .info("[TELE-OP] Scored during AMP: $value");
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
                    Debug().info("[TELE-OP] Scored in AMP: $value");
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
                    Debug()
                        .info("[TELE-OP] Missed AMP Shots: $value");
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
                  onChanged: (String value) {
                    Debug().info("[TELE-OP] Comments: $value");
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
          header: (icon: Icons.flag_rounded, title: "Endgame"),
          child: form_col(<Widget>[
            form_label("On chain",
                icon: const Icon(Icons.link),
                child: BasicToggleSwitch(
                    initialValue: false,
                    onChanged: (bool e) {
                      Debug().info("[ENDGAME] On chain: $e");
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
                                  label: formalizeWord(e.name),
                                  icon: null,
                                  value: e
                                ))
                        .toList(),
                    initialSelection: Harmony.no,
                    onSelect: (Harmony e) {
                      Debug().info("[ENDGAME] Harmony: ${e.name}");
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
                                  label: formalizeWord(e.name),
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
                                  label: formalizeWord(e.name),
                                  icon: null,
                                  value: e
                                ))
                        .toList(),
                    initialSelection: MicScored.no,
                    onSelect: (MicScored e) {
                      Debug()
                          .info("[ENDGAME] Scored on mic: ${e.name}");
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
                  onChanged: (String value) {
                    Debug().info("[ENDGAME] Comments: $value");
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
          header: (icon: Icons.more_horiz_rounded, title: "Other"),
          child: form_col(<Widget>[
            form_label("Coopertition",
                icon: const Icon(Icons.groups),
                child: BasicToggleSwitch(
                    initialValue: false,
                    onChanged: (bool e) {
                      Debug().info("[OTHER] Coopertition: $e");
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
                      Debug().info("[OTHER] Breakdown: $e");
                      context
                          .read<ScoutingSessionBloc>()
                          .misc
                          .breakdown = e;
                      context
                          .read<ScoutingSessionBloc>()
                          .add(MiscUpdateEvent());
                    })),
          ])),
    ];
    return Column(
      children: <Widget>[
        Flexible(
            flex: 0,
            child: Wrap(
                children: strutAll(<Widget>[
              if (PreferCompactModal.isCompactPreferred(context))
                IconButton.filledTonal(
                    onPressed: () async =>
                        await launchConfirmDialog(context,
                            title: "Are you sure you want to exit?",
                            message: const Text(
                                "The current session datawill be lost."),
                            onConfirm: () {
                          context
                              .findAncestorStateOfType<
                                  _ScoutingSessionViewDelegateState>()!
                              .setState(() {
                            _currBloc = null;
                            Debug().warn(
                                "Exited the current scouting session");
                          });
                        }),
                    icon: const Icon(Icons.exit_to_app_rounded))
              else
                FilledButton.icon(
                    style: ButtonStyle(
                        shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(8)))),
                    icon: const Icon(Icons.exit_to_app_rounded),
                    label: const Text("Exit Session"),
                    onPressed: () async {
                      // make ScoutingSessionViewDelegateState show the launcher again by using BuildContext
                      await launchConfirmDialog(context,
                          title: "Are you sure you want to exit?",
                          message: const Text(
                              "The current session datawill be lost."),
                          onConfirm: () {
                        context
                            .findAncestorStateOfType<
                                _ScoutingSessionViewDelegateState>()!
                            .setState(() {
                          _currBloc = null;
                          Debug().warn(
                              "Exited the current scouting session");
                        });
                      });
                    }),
              if (PreferCompactModal.isCompactPreferred(context))
                IconButton.filledTonal(
                    onPressed: () async =>
                        await launchConfirmDialog(
                            showOkLabel: false,
                            denyLabel: "Close",
                            icon: const Icon(
                                Icons.warning_amber_rounded),
                            title: "Warning",
                            context,
                            message: const Text("Unavaliable..."),
                            onConfirm: () {}),
                    icon: const Icon(
                        Icons.bluetooth_connected_rounded))
              else
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
                  onPressed: () async => await launchConfirmDialog(
                      showOkLabel: false,
                      denyLabel: "Close",
                      icon: const Icon(Icons.warning_amber_rounded),
                      title: "Warning",
                      context,
                      message: const Text("Unavaliable..."),
                      onConfirm: () {}),
                ),
              if (PreferCompactModal.isCompactPreferred(context))
                IconButton.filledTonal(
                    onPressed: () {},
                    icon: const Icon(CommunityMaterialIcons.qrcode))
              else
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
              if (PreferCompactModal.isCompactPreferred(context))
                IconButton.filledTonal(
                    onPressed: () {
                      EphemeralScoutingData data =
                          EphemeralScoutingData.fromHollistic(
                              context
                                  .read<ScoutingSessionBloc>()
                                  .exportHollistic());
                      ScoutingTelemetry().put(data);
                      Debug().info(
                          "Saved an entry of ${data.id}=${data.toString()}");
                      launchConfirmDialog(context,
                          message: const Text(
                              "Saved this scouting entry to persistent storage!"),
                          onConfirm: () {
                        context
                            .findAncestorStateOfType<
                                _ScoutingSessionViewDelegateState>()!
                            .setState(() {
                          _currBloc = null;
                          Debug().warn(
                              "Exited the current scouting session");
                        });
                      });
                    },
                    icon: const Icon(Icons.save_rounded))
              else
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
                          EphemeralScoutingData.fromHollistic(
                              context
                                  .read<ScoutingSessionBloc>()
                                  .exportHollistic());
                      ScoutingTelemetry().put(data);
                      Debug().info(
                          "Saved an entry of ${data.id}=${data.toString()}");
                      launchConfirmDialog(context,
                          message: const Text(
                              "Saved this scouting entry to persistent storage!"),
                          onConfirm: () {
                        context
                            .findAncestorStateOfType<
                                _ScoutingSessionViewDelegateState>()!
                            .setState(() {
                          _currBloc = null;
                          Debug().warn(
                              "Exited the current scouting session");
                        });
                      });
                    }),
              if (ShowConsoleModal.isShowingConsole(context))
                FilledButton.icon(
                    style: ButtonStyle(
                        shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(8)))),
                    icon:
                        const Icon(Icons.spatial_tracking_rounded),
                    label: const Text("View Raw"),
                    onPressed: () async =>
                        await launchConfirmDialog(context,
                            message: SingleChildScrollView(
                              physics: const BouncingScrollPhysics(
                                  parent:
                                      AlwaysScrollableScrollPhysics()),
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    top: 10, bottom: 10),
                                child: Text.rich(TextSpan(
                                    text:
                                        "RAW\n${jsonEncode(context.read<ScoutingSessionBloc>().exportMapDeep().toString())}\n\nHollistic\n${jsonEncode(context.read<ScoutingSessionBloc>().exportHollistic().toString())}\n\nEphemeral\n${EphemeralScoutingData.fromHollistic(context.read<ScoutingSessionBloc>().exportHollistic())}")),
                              ),
                            ),
                            onConfirm: () {})),
            ], width: 12))),
        const SizedBox(height: 20),
        Flexible(
            child: UseAlternativeLayoutModal
                    .isAlternativeLayoutPreferred(context)
                ? SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(
                        parent: BouncingScrollPhysics()),
                    child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: bruh))
                : form_grid_2(
                    crossAxisCount: 2,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    children: bruh))
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}
