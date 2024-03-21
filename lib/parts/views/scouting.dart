import "dart:convert";

import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:intl/intl.dart";
import "package:provider/provider.dart";
import 'package:community_material_icon/community_material_icon.dart';

import "package:scouting_app_2024/blobs/basic_toggle_switch.dart";
import "package:scouting_app_2024/blobs/blobs.dart";
import "package:scouting_app_2024/blobs/expandable_txtfield.dart";
import "package:scouting_app_2024/blobs/form_blob.dart";
import "package:scouting_app_2024/blobs/hints_blob.dart";
import "package:scouting_app_2024/blobs/inc_dec_blob.dart";
import "package:scouting_app_2024/blobs/multi_select_blob.dart";
import "package:scouting_app_2024/extern/scroll_controller.dart";
import "package:scouting_app_2024/extern/string.dart";
import "package:scouting_app_2024/parts/bits/appbar_celebrate.dart";
import "package:scouting_app_2024/parts/bits/prefer_compact.dart";
import "package:scouting_app_2024/parts/bits/show_console.dart";
import "package:scouting_app_2024/parts/bits/show_hints.dart";
import "package:scouting_app_2024/parts/bits/use_alt_layout.dart";
import "package:scouting_app_2024/parts/team.dart";
import "package:scouting_app_2024/parts/views_delegate.dart";
import "package:scouting_app_2024/shared.dart";
import "package:scouting_app_2024/user/models/ephemeral_data.dart";
import "package:scouting_app_2024/user/models/shared.dart";
import "package:scouting_app_2024/user/scouting_telemetry.dart";
import 'package:scouting_app_2024/debug.dart';
import 'package:scouting_app_2024/user/models/team_bloc.dart';
import 'package:scouting_app_2024/user/models/team_model.dart';
import "package:scouting_app_2024/utils.dart";

import "usage_time_display.dart";

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
                        const UsageTimeDisplay(),
                        const SizedBox(height: 34),
                        const Text(
                            "Scouting Revision: v$EPHEMERAL_MODELS_VERSION"),
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
                    create: (BuildContext _) {
                      Debug().info(
                          "Dispatched SCOUING_SESSION_BLOC ${_currBloc.hashCode}");
                      return _currBloc!;
                    },
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
    with AutomaticKeepAliveClientMixin {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    List<Widget> bruh = <Widget>[
      if (ShowHintsGuideModal.isShowingHints(context))
        const ApexHintsBlob("Scouting Sessions are volatile!",
            "Scouting data is not saved until you press the save button. If you exit the app or the app crashes, the data will be lost."),
      form_sec(
          backgroundColor: Colors.transparent,
          header: (
            icon: Icons.account_tree_rounded,
            title: "Match Information"
          ),
          child: form_col(<Widget>[
            form_label("Time",
                child: Text(
                    DateFormat(Shared.GENERAL_TIME_FORMAT).format(
                        DateTime.fromMillisecondsSinceEpoch(context
                            .read<ScoutingSessionBloc>()
                            .prelim
                            .timeStamp)),
                    style: const TextStyle(
                        fontWeight: FontWeight.bold))),
            form_label(
              "Number ",
              child: form_numpick(
                  initialData: context
                      .read<ScoutingSessionBloc>()
                      .prelim
                      .matchNumber,
                  label: "Picker",
                  icon: const Icon(CommunityMaterialIcons.counter),
                  minValue: 1,
                  maxValue: 999,
                  headerMessage: "Match Number",
                  onChange: (int number) {
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
                child: Flexible(
                  child: SingleSelectBlob<MatchType>(
                      initialSelected: context
                          .read<ScoutingSessionBloc>()
                          .prelim
                          .matchType
                          .name
                          .formalize,
                      items:
                          GenericUtils.mapEnumExcludeUnset<MatchType>(
                              MatchType.values),
                      onSelected: (MatchType e) {
                        context
                            .read<ScoutingSessionBloc>()
                            .prelim
                            .matchType = e;
                        context
                            .read<ScoutingSessionBloc>()
                            .add(PrelimUpdateEvent());
                      }),
                ))
          ])),
      form_sec(
          backgroundColor: Colors.transparent,
          header: (
            icon: Icons.people_outline_rounded,
            title: "Team Information"
          ),
          // for each of these information sections, no need to mention the individual word again like "[team] number"
          child: form_col(<Widget>[
            form_label(
              "Number",
              child: form_numpick(
                  label: "Picker",
                  initialData: context
                      .read<ScoutingSessionBloc>()
                      .prelim
                      .teamNumber,
                  icon: const Icon(CommunityMaterialIcons.counter),
                  minValue: 1,
                  maxValue: 9999,
                  headerMessage: "Team Number",
                  onChange: (int number) {
                    context
                        .read<ScoutingSessionBloc>()
                        .prelim
                        .teamNumber = number;
                    context
                        .read<ScoutingSessionBloc>()
                        .add(PrelimUpdateEvent());
                  }),
            ),
            form_label("Alliance",
                child: TeamAllianceSwitch(
                    initialValue: context
                            .read<ScoutingSessionBloc>()
                            .prelim
                            .alliance ==
                        TeamAlliance.blue,
                    onChanged: (TeamAlliance alliance) {
                      context
                          .read<ScoutingSessionBloc>()
                          .prelim
                          .alliance = alliance;
                      context
                          .read<ScoutingSessionBloc>()
                          .add(PrelimUpdateEvent());
                    })),
            form_label("Starting Position",
                child: Flexible(
                  child: SingleSelectBlob<MatchStartingPosition>(
                      initialSelected: context
                          .read<ScoutingSessionBloc>()
                          .prelim
                          .startingPosition
                          .name
                          .formalize,
                      items: GenericUtils.mapEnumExcludeUnset<
                              MatchStartingPosition>(
                          MatchStartingPosition.values),
                      onSelected: (MatchStartingPosition e) {
                        context
                            .read<ScoutingSessionBloc>()
                            .prelim
                            .startingPosition = e;
                        context
                            .read<ScoutingSessionBloc>()
                            .add(PrelimUpdateEvent());
                      }),
                ))
          ])),
      form_sec(
          backgroundColor: Colors.transparent,
          header: (
            icon: Icons.smart_toy_rounded,
            title: "Autonomous"
          ),
          child: form_col(<Widget>[
            form_label("Note preloaded?",
                child: BasicToggleSwitch(
                    initialValue: context
                        .read<ScoutingSessionBloc>()
                        .auto
                        .notePreloaded,
                    onChanged: (bool e) {
                      context
                          .read<ScoutingSessionBloc>()
                          .auto
                          .notePreloaded = e;
                      context
                          .read<ScoutingSessionBloc>()
                          .add(AutoUpdateEvent());
                    })),
            form_label("Note(s) picked up\n",
                child: Flexible(
                  child: MultiSelectBlob<AutoPickup>(
                      items: <String, AutoPickup>{
                        for (AutoPickup e in AutoPickup.values)
                          e.name.formalize: e
                      },
                      onSelected: (List<AutoPickup> e) {
                        context
                            .read<ScoutingSessionBloc>()
                            .add(AutoUpdateEvent());
                      }),
                )
                /*form_seg_btn_2(
                    segments: AutoPickup.values
                        .map<
                                ({
                                  Icon? icon,
                                  String label,
                                  AutoPickup value
                                })>(
                            (AutoPickup e) => (
                                  label: e.name.formalize,
                                  icon: null,
                                  value: e
                                ))
                        .toList(),
                    initialSelection:
                        context.read<ScoutingSessionBloc>()
                            .auto
                            .notesPickedUp
                            .toSet(),
                    onSelect: (List<AutoPickup> e) {
                      context
                          .read<ScoutingSessionBloc>()
                          .auto
                          .notesPickedUp = e;
                      context
                          .read<ScoutingSessionBloc>()
                          .add(AutoUpdateEvent());
                    })*/
                ),
            form_label("Taxis?",
                child: BasicToggleSwitch(
                    initialValue:
                        context.read<ScoutingSessionBloc>().auto.taxi,
                    onChanged: (bool e) {
                      context.read<ScoutingSessionBloc>().auto.taxi =
                          e;
                      context
                          .read<ScoutingSessionBloc>()
                          .add(AutoUpdateEvent());
                    })),
            form_label("Scored in Speaker",
                child: PlusMinus(
                  initialValue: context
                      .read<ScoutingSessionBloc>()
                      .auto
                      .scoredSpeaker,
                  onValueChanged: (int value) {
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
                child: PlusMinus(
                  initialValue: context
                      .read<ScoutingSessionBloc>()
                      .auto
                      .missedSpeaker,
                  onValueChanged: (int value) {
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
                child: PlusMinus(
                  initialValue: context
                      .read<ScoutingSessionBloc>()
                      .auto
                      .scoredAmp,
                  onValueChanged: (int value) {
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
                child: PlusMinus(
                  initialValue: context
                      .read<ScoutingSessionBloc>()
                      .auto
                      .missedAmp,
                  onValueChanged: (int value) {
                    context
                        .read<ScoutingSessionBloc>()
                        .auto
                        .missedAmp = value;
                    context
                        .read<ScoutingSessionBloc>()
                        .add(AutoUpdateEvent());
                  },
                )),
          ])),
      form_sec(
          backgroundColor: Colors.transparent,
          header: (
            icon: Icons.accessibility_rounded,
            title: "Tele-op"
          ),
          child: form_col(<Widget>[
            form_label("Goes under stage?",
                child: BasicToggleSwitch(
                    initialValue: context
                        .read<ScoutingSessionBloc>()
                        .teleop
                        .underStage,
                    onChanged: (bool e) {
                      context
                          .read<ScoutingSessionBloc>()
                          .teleop
                          .underStage = e;
                      context
                          .read<ScoutingSessionBloc>()
                          .add(TeleOpUpdateEvent());
                    })),
            form_label("Lobs?",
                child: BasicToggleSwitch(
                    initialValue: context
                        .read<ScoutingSessionBloc>()
                        .teleop
                        .lobs,
                    onChanged: (bool e) {
                      context
                          .read<ScoutingSessionBloc>()
                          .teleop
                          .lobs = e;
                      context
                          .read<ScoutingSessionBloc>()
                          .add(TeleOpUpdateEvent());
                    })),
            form_label("Scored in Speaker",
                child: PlusMinus(
                  initialValue: context
                      .read<ScoutingSessionBloc>()
                      .teleop
                      .scoredSpeaker,
                  onValueChanged: (int value) {
                    context
                        .read<ScoutingSessionBloc>()
                        .teleop
                        .scoredSpeaker = value;
                    context
                        .read<ScoutingSessionBloc>()
                        .add(TeleOpUpdateEvent());
                  },
                )),
            form_label("Missed Speaker Shots",
                child: PlusMinus(
                  initialValue: context
                      .read<ScoutingSessionBloc>()
                      .teleop
                      .missedSpeaker,
                  onValueChanged: (int value) {
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
                child: PlusMinus(
                  initialValue: context
                      .read<ScoutingSessionBloc>()
                      .auto
                      .scoredAmp,
                  onValueChanged: (int value) {
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
                child: PlusMinus(
                  initialValue: context
                      .read<ScoutingSessionBloc>()
                      .teleop
                      .missedAmp,
                  onValueChanged: (int value) {
                    context
                        .read<ScoutingSessionBloc>()
                        .teleop
                        .missedAmp = value;
                    context
                        .read<ScoutingSessionBloc>()
                        .add(TeleOpUpdateEvent());
                  },
                )),
          ])),
      form_sec(
          backgroundColor: Colors.transparent,
          header: (icon: Icons.flag_rounded, title: "Endgame"),
          child: form_col(<Widget>[
            form_label("On chain",
                child: Flexible(
                  child: SingleSelectBlob<EndStatus>(
                      initialSelected: context
                          .read<ScoutingSessionBloc>()
                          .endgame
                          .endState
                          .name
                          .formalize,
                      items:
                          GenericUtils.mapEnumExcludeUnset<EndStatus>(
                              EndStatus.values),
                      onSelected: (EndStatus e) {
                        context
                            .read<ScoutingSessionBloc>()
                            .endgame
                            .endState = e;
                        context
                            .read<ScoutingSessionBloc>()
                            .add(EndgameUpdateEvent());
                      }),
                )),
            form_label(
              "Attempted harmony?",
              child: BasicToggleSwitch(
                  initialValue: context
                      .read<ScoutingSessionBloc>()
                      .endgame
                      .harmonyAttempted,
                  onChanged: (bool e) {
                    context
                        .read<ScoutingSessionBloc>()
                        .endgame
                        .harmonyAttempted = e;
                    context
                        .read<ScoutingSessionBloc>()
                        .add(EndgameUpdateEvent());
                    setState(() {});
                  }),
            ),
            if (context
                .read<ScoutingSessionBloc>()
                .endgame
                .harmonyAttempted)
              form_label("Harmony",
                  child: Flexible(
                    child: SingleSelectBlob<Harmony>(
                        initialSelected: context
                            .read<ScoutingSessionBloc>()
                            .endgame
                            .harmony
                            .name
                            .formalize,
                        items:
                            GenericUtils.mapEnumExcludeUnset<Harmony>(
                                Harmony.values),
                        onSelected: (Harmony e) {
                          context
                              .read<ScoutingSessionBloc>()
                              .endgame
                              .harmony = e;
                          context
                              .read<ScoutingSessionBloc>()
                              .add(EndgameUpdateEvent());
                        }),
                  )),
            form_label("Scored in Trap",
                child: Flexible(
                  child: SingleSelectBlob<TrapScored>(
                      initialSelected: context
                          .read<ScoutingSessionBloc>()
                          .endgame
                          .trapScored
                          .name
                          .formalize,
                      items: GenericUtils.mapEnumExcludeUnset<
                          TrapScored>(TrapScored.values),
                      onSelected: (TrapScored e) {
                        context
                            .read<ScoutingSessionBloc>()
                            .endgame
                            .trapScored = e;
                        context
                            .read<ScoutingSessionBloc>()
                            .add(EndgameUpdateEvent());
                      }),
                )),
            form_label("Human Scored on Mic",
                child: Flexible(
                  child: SingleSelectBlob<MicScored>(
                      initialSelected: context
                          .read<ScoutingSessionBloc>()
                          .endgame
                          .micScored
                          .name
                          .formalize,
                      items:
                          GenericUtils.mapEnumExcludeUnset<MicScored>(
                              MicScored.values),
                      onSelected: (MicScored e) {
                        context
                            .read<ScoutingSessionBloc>()
                            .endgame
                            .micScored = e;
                        context
                            .read<ScoutingSessionBloc>()
                            .add(EndgameUpdateEvent());
                      }),
                )),
            form_label("Match Result",
                child: Flexible(
                  child: SingleSelectBlob<MatchResult>(
                      initialSelected: context
                          .read<ScoutingSessionBloc>()
                          .endgame
                          .matchResult
                          .name
                          .formalize,
                      items: GenericUtils.mapEnumExcludeUnset<
                          MatchResult>(MatchResult.values),
                      onSelected: (MatchResult e) {
                        context
                            .read<ScoutingSessionBloc>()
                            .endgame
                            .matchResult = e;
                        context
                            .read<ScoutingSessionBloc>()
                            .add(EndgameUpdateEvent());
                      }),
                )),
          ])),
      form_sec(
          backgroundColor: Colors.transparent,
          header: (icon: Icons.more_horiz_rounded, title: "Other"),
          child: form_col(<Widget>[
            form_label("Coopertition",
                child: BasicToggleSwitch(
                    initialValue: context
                        .read<ScoutingSessionBloc>()
                        .misc
                        .coopertition,
                    onChanged: (bool e) {
                      context
                          .read<ScoutingSessionBloc>()
                          .misc
                          .coopertition = e;
                      context
                          .read<ScoutingSessionBloc>()
                          .add(MiscUpdateEvent());
                    })),
            form_label("Breakdown",
                child: BasicToggleSwitch(
                    initialValue: context
                        .read<ScoutingSessionBloc>()
                        .misc
                        .breakdown,
                    onChanged: (bool e) {
                      context
                          .read<ScoutingSessionBloc>()
                          .misc
                          .breakdown = e;
                      context
                          .read<ScoutingSessionBloc>()
                          .add(MiscUpdateEvent());
                    })),
            form_label("Comments",
                child: ExpandedTextFieldBlob(context,
                    prefixIcon: const Icon(Icons.comment_rounded),
                    initialData: context
                            .read<ScoutingSessionBloc>()
                            .comments
                            .comment ??
                        "", onChanged: (String r) {
                  context
                      .read<ScoutingSessionBloc>()
                      .comments
                      .comment = r;
                  context
                      .read<ScoutingSessionBloc>()
                      .add(CommentsUpdateEvent());
                },
                    labelText: "Comments",
                    hintText: "Type comments here",
                    maxChars: COMMENTS_MAX_CHARS,
                    maxLines: 10)),
          ])),
    ];
    return Column(
      children: <Widget>[
        Flexible(
            flex: 0,
            child: Wrap(runSpacing: 8, spacing: 8, children: <Widget>[
              if (PreferCompactModal.isCompactPreferred(context))
                IconButton.filledTonal(
                    onPressed: () async => await launchConfirmDialog(
                            context,
                            title: "Are you sure you want to exit?",
                            message: const Text(
                                "The current session data will be lost."),
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
                              "The current session data will be lost."),
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
                    onPressed: () async {
                      await launchConfirmDialog(context,
                          callAfter: true,
                          message: const Text.rich(TextSpan(
                              text: "Are you sure you want to save?",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18),
                              children: <InlineSpan>[
                                TextSpan(
                                    text:
                                        "\nYou CANNOT make changes after!")
                              ])), onConfirm: () {
                        EphemeralScoutingData data =
                            EphemeralScoutingData.fromHollistic(
                                context
                                    .read<ScoutingSessionBloc>()
                                    .exportHollistic());
                        ScoutingTelemetry().put(data);
                        Debug().info(
                            "Saved an entry of ${data.id}=${data.toString()}");
                        launchInformDialog(context,
                            message: Text.rich(TextSpan(
                                text:
                                    "Saved match ${context.read<ScoutingSessionBloc>().prelim.matchNumber}!\n",
                                children: <InlineSpan>[
                                  const TextSpan(
                                    text:
                                        "Head over to [Past Matches] to view all saved entries\n",
                                  ),
                                  TextSpan(
                                      text:
                                          "${data.id} - ${context.read<ScoutingSessionBloc>().hashCode}",
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w300,
                                          fontSize: 10))
                                ])),
                            title: "Saved!", onExit: () {
                          Provider.of<AppBarCelebrationModal>(context,
                                  listen: false)
                              .toggle();
                          context
                              .findAncestorStateOfType<
                                  _ScoutingSessionViewDelegateState>()!
                              .setState(() => _currBloc = null);
                          Debug().warn(
                              "Exited & SAVED the current scouting session");
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
                          EphemeralScoutingData.fromHollistic(context
                              .read<ScoutingSessionBloc>()
                              .exportHollistic());
                      ScoutingTelemetry().put(data);

                      Debug().info(
                          "Saved an entry of ${data.id}=${data.toString()}");
                      launchInformDialog(context,
                          message: Text.rich(TextSpan(
                              text:
                                  "Saved match ${context.read<ScoutingSessionBloc>().prelim.matchNumber}!\n",
                              children: <InlineSpan>[
                                const TextSpan(
                                    text:
                                        "Head over to [Past Matches] to view all saved entries\n"),
                                TextSpan(
                                    text: data.id,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w300,
                                        fontSize: 10))
                              ])),
                          title: "Saved!", onExit: () {
                        Provider.of<AppBarCelebrationModal>(context,
                                listen: false)
                            .toggle();
                        context
                            .findAncestorStateOfType<
                                _ScoutingSessionViewDelegateState>()!
                            .setState(() => _currBloc = null);
                        Debug().warn(
                            "Exited & SAVED the current scouting session");
                      });
                    }),
              if (PreferCompactModal.isCompactPreferred(context))
                IconButton.filledTonal(
                    onPressed: () =>
                        _scrollController.animateToBottom(),
                    icon: const Icon(Icons.arrow_downward_rounded))
              else
                FilledButton.tonalIcon(
                    onPressed: () =>
                        _scrollController.animateToBottom(),
                    icon: const Icon(Icons.arrow_downward_rounded),
                    label: const Text("Scroll Down")),
              if (PreferCompactModal.isCompactPreferred(context))
                IconButton.filledTonal(
                    onPressed: () => _scrollController.animateToTop(),
                    icon: const Icon(Icons.arrow_upward_rounded))
              else
                FilledButton.tonalIcon(
                    onPressed: () => _scrollController.animateToTop(),
                    icon: const Icon(Icons.arrow_upward_rounded),
                    label: const Text("Scroll Up")),
              if (ShowConsoleModal.isShowingConsole(context))
                FilledButton.icon(
                    style: ButtonStyle(
                        shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(8)))),
                    icon: const Icon(Icons.spatial_tracking_rounded),
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
                                child: Text.rich(
                                  TextSpan(
                                    text:
                                        "RAW\n${jsonEncode(context.read<ScoutingSessionBloc>().exportMapDeep().toString())}\n\nHollistic\n${jsonEncode(context.read<ScoutingSessionBloc>().exportHollistic().toString())}\n\nEphemeral\n${EphemeralScoutingData.fromHollistic(context.read<ScoutingSessionBloc>().exportHollistic())}\n\nComments\n${context.read<ScoutingSessionBloc>().comments.comment}",
                                  ),
                                ),
                              ),
                            ),
                            onConfirm: () {})),
            ])),
        const SizedBox(height: 20),
        Flexible(
            child: UseAlternativeLayoutModal
                    .isAlternativeLayoutPreferred(context)
                ? ListView.builder(
                    primary: false,
                    itemBuilder: (BuildContext context, int index) {
                      return bruh[index];
                    },
                    controller: _scrollController,
                    itemCount: bruh.length,
                    physics: const BouncingScrollPhysics(
                        parent: AlwaysScrollableScrollPhysics()))
                : form_grid_2(
                    scrollController: _scrollController,
                    crossAxisCount: 2,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    children: bruh))
      ],
    );
  }
}
