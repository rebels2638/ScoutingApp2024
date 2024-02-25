import 'package:community_material_icon/community_material_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'package:provider/provider.dart';
import 'package:scouting_app_2024/blobs/blobs.dart';
import 'package:scouting_app_2024/blobs/form_blob.dart';
import 'package:scouting_app_2024/blobs/hints_blob.dart';
import 'package:scouting_app_2024/debug.dart';
import 'package:scouting_app_2024/extern/dynamic_user_capture.dart';
import 'package:scouting_app_2024/extern/string.dart';
import 'package:scouting_app_2024/parts/bits/duc_bit.dart';
import 'package:scouting_app_2024/parts/bits/prefer_canonical.dart';
import 'package:scouting_app_2024/parts/bits/prefer_compact.dart';
import 'package:scouting_app_2024/parts/bits/show_console.dart';
import 'package:scouting_app_2024/parts/bits/show_hints.dart';
import 'dart:io';
import 'package:scouting_app_2024/parts/views_delegate.dart';
import 'package:scouting_app_2024/shared.dart';
import 'package:scouting_app_2024/user/duc_telemetry.dart';
import 'package:scouting_app_2024/user/match_utils.dart';
import 'package:scouting_app_2024/user/models/team_model.dart';
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

@pragma("vm:prefer-inline")
Widget _expander(
        {required Widget icon,
        required String title,
        String? subtitle,
        required Widget body}) =>
    ExpansionTile(
        title: Row(children: <Widget>[
          icon,
          const SizedBox(width: 6),
          Text(
            title,
            style: const TextStyle(
                fontSize: 16, fontWeight: FontWeight.w600),
          )
        ]),
        subtitle: subtitle != null
            ? Text(subtitle,
                style: const TextStyle(
                    fontSize: 12, fontWeight: FontWeight.w400))
            : null,
        controlAffinity: ListTileControlAffinity.leading,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 12, bottom: 12),
            child: body,
          )
        ]);

class DataHostingView extends StatefulWidget
    implements AppPageViewExporter {
  const DataHostingView({super.key});

  @override
  State<DataHostingView> createState() => _DataHostingViewState();

  @override
  ({
    Widget child,
    ({Icon activeIcon, Icon icon, String label, String tooltip}) item
  }) exportAppPageView() {
    return (
      child: this,
      item: (
        activeIcon:
            const Icon(CommunityMaterialIcons.account_tie_outline),
        icon: const Icon(CommunityMaterialIcons.duck),
        label: "Duc",
        tooltip: "Integrated Data Collection"
      )
    );
  }
}

class _DataHostingViewState extends State<DataHostingView> {
  late Map<int, List<HollisticMatchScoutingData>> teamsData;
  late bool _searched;

  @override
  void initState() {
    super.initState();
    teamsData =
        MatchUtils.filterByTeam(DucTelemetry().allHollisticEntries);
    _searched = false;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(
          parent: BouncingScrollPhysics()),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            if (ShowHintsGuideModal.isShowingHints(context))
              const WarningHintsBlob("Scouting Leaders only",
                  "This part of the app is to be operated by scouting leaders, it is not recommended for regular users."),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                GestureDetector(
                    onTap: () async => await launchConfirmDialog(
                        // :)
                        context,
                        title: "exoad's memo",
                        message: const Text(
                            "idk, i wanted a duck, so i cut the word down to get 'duc', and then i asked chatgpt an acronym and it came up with 'Dynamic User Capture' so i was like 'ok, lets go with that' LOL ~ exoad"),
                        showOkLabel: false,
                        onConfirm: () {}),
                    child: const Icon(CommunityMaterialIcons.duck,
                        size: 38)),
                const SizedBox(width: 12),
                const Text("DUC",
                    style: TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 14),
            if (!_searched)
              Builder(builder: (BuildContext context) {
                int totalMatches = 0;
                teamsData.forEach((int key,
                    List<HollisticMatchScoutingData> value) {
                  totalMatches += value.length;
                });
                return Text.rich(
                  TextSpan(children: <InlineSpan>[
                    const TextSpan(
                        text: "Total Teams Loaded: ",
                        style:
                            TextStyle(fontWeight: FontWeight.bold)),
                    TextSpan(
                      text: teamsData.keys.length.toString(),
                    ),
                    const TextSpan(
                        text: "\nTotal Matches Loaded: ",
                        style:
                            TextStyle(fontWeight: FontWeight.bold)),
                    TextSpan(
                      text: "$totalMatches ",
                    ),
                  ]),
                  style: const TextStyle(fontSize: 18),
                );
              }),
            const SizedBox(height: 14),
            Wrap(spacing: 14, runSpacing: 14, children: <Widget>[
              if (!_searched)
                if (Platform.isAndroid || Platform.isIOS)
                  FilledButton.tonalIcon(
                      onPressed: () => Navigator.of(context).push(
                          MaterialPageRoute<Widget>(
                              builder: (BuildContext context) =>
                                  Scaffold(
                                      appBar: AppBar(
                                          title: const Text(
                                              "DUC Scanner")),
                                      body: const _QrScanner()))),
                      icon: const Icon(Icons.qr_code_scanner_rounded),
                      label: const Text("Scan DUC"))
                else
                  Text.rich(TextSpan(children: <InlineSpan>[
                    const WidgetSpan(
                        child: Icon(Icons.error_rounded)),
                    TextSpan(
                        text:
                            "DUC Scanning is not supported on ${Platform.operatingSystem}")
                  ])),
              if (!_searched)
                FilledButton.tonalIcon(
                    onPressed: () async => await Provider.of<
                            DucBaseBit>(context, listen: false)
                        .save()
                        .then((_) => Debug().info("[DUC] Saved!")),
                    icon: const Icon(Icons.save_rounded),
                    label: const Text("Save")),
              if (!_searched)
                FilledButton.tonalIcon(
                    onPressed: () async => await showDialog(
                        context: context,
                        builder: (BuildContext _) =>
                            _PasteDucData(context)),
                    icon: const Icon(Icons.paste_rounded),
                    label: const Text("Paste DUC")),
              if (!_searched)
                FilledButton.tonalIcon(
                    onPressed: () async =>
                        await launchAssuredConfirmDialog(context,
                            message:
                                "Are you sure you want to delete all DUC data? This is irreversible!",
                            title: "Delete DUC", onConfirm: () {
                          Provider.of<DucBaseBit>(context,
                                  listen: false)
                              .removeAll()
                              .then((_) => Debug().warn(
                                  "[DUC] Removed all DUC data..."));
                        }),
                    icon: const Icon(Icons.delete_forever_rounded),
                    label: const Text("Delete All")),
              if (!_searched)
                FilledButton.tonalIcon(
                    onPressed: () {
                      teamsData = MatchUtils.filterByTeam(
                          DucTelemetry().allHollisticEntries);
                      setState(() {});
                    },
                    icon: const Icon(Icons.refresh_rounded),
                    label: const Text("Refresh")),
              if (_searched)
                FilledButton.tonalIcon(
                    onPressed: () {
                      teamsData = MatchUtils.filterByTeam(
                          DucTelemetry().allHollisticEntries);
                      setState(() => _searched = false);
                    },
                    icon: const Icon(Icons.arrow_back_rounded),
                    label: const Text("Cancel Search")),
              FilledButton.tonalIcon(
                  onPressed: () async => await showDialog(
                      context: context,
                      builder: (BuildContext context) =>
                          _SearchTeamsDialog(onSubmit: (String id) {
                            teamsData.removeWhere(
                                (int key, _) => key != int.parse(id));
                            setState(() => _searched = true);
                          }, onValidate: (String id) {
                            try {
                              return teamsData
                                  .containsKey(int.parse(id));
                            } catch (e) {
                              return false;
                            }
                          })),
                  icon: const Icon(Icons.search_rounded),
                  label: const Text("Search Teams"))
            ]),
            const SizedBox(height: 32),
            Column(
              children: _readProviderOfDucs(context, teamsData),
            )
          ]),
    );
  }

  List<Widget> _readProviderOfDucs(BuildContext context,
      Map<int, List<HollisticMatchScoutingData>> teamsData) {
    if (teamsData.isNotEmpty) {
      List<Widget> widgets = <Widget>[];
      Map<int, List<HollisticMatchScoutingData>> teams = teamsData;
      teams.forEach(
          (int teamNumber, List<HollisticMatchScoutingData> data) {
        // AUTO CALCULATIONS
        double autoPercentGetMovementPoints = 0.0;
        double autoAvgScoredSpeaker = 0.0;
        double autoAvgScoredInAmp = 0.0;
        double autoPercentOfPickupAmpSideNote = 0.0;
        double autoPercentOfPickupStageSideNote = 0.0;
        double autoPercentOfPickupMiddleSideNote = 0.0;
        double autoPercentStartLeft = 0.0;
        double autoPercentStartRight = 0.0;
        double autoPercentStartMiddle = 0.0;
        // TELEOP CALCULATIONS
        double teleopAvgScoredInSpeaker = 0.0;
        double teleopAvgScoredInAmp = 0.0;
        double teleopAvgNotesScored = 0.0;
        bool teleopGoesUnderStage = false;
        double teleopDriverRating = 0.0;
        double teleopAvgScoredWhileAmped = 0.0;
        // ENDGAME CALCULATIONS
        bool endgameCanClimb = false;
        double endgameHarmonyAttemptSuccessRate = 0.0;
        double endgamePercentOfGamesScoredTrap = 0.0;
        // GENERAL CALCULATIONS
        double miscWinLikelihoods = 0.0;
        for (HollisticMatchScoutingData d in data) {
          if (d.auto.taxi) {
            autoPercentGetMovementPoints++;
          }
          autoAvgScoredSpeaker += d.auto.scoredSpeaker;
          autoAvgScoredInAmp += d.auto.scoredAmp;
          if (d.auto.notesPickedUp.isNotEmpty) {
            autoPercentOfPickupAmpSideNote += d.auto.notesPickedUp
                .where((AutoPickup e) => e == AutoPickup.amp)
                .length;
            autoPercentOfPickupStageSideNote += d.auto.notesPickedUp
                .where((AutoPickup e) => e == AutoPickup.stage)
                .length;
            autoPercentOfPickupMiddleSideNote += d.auto.notesPickedUp
                .where((AutoPickup e) => e == AutoPickup.middle)
                .length;
          }
          if (d.preliminary.startingPosition ==
              MatchStartingPosition.amp) {
            autoPercentStartLeft++;
          } else if (d.preliminary.startingPosition ==
              MatchStartingPosition.stage) {
            autoPercentStartRight++;
          } else {
            autoPercentStartMiddle++;
          }
          teleopAvgScoredInSpeaker += d.teleop.scoredSpeaker;
          teleopAvgScoredInAmp += d.teleop.scoredAmp;
          teleopAvgNotesScored += d.teleop.piecesScored;
          teleopGoesUnderStage = d.teleop.underStage;
          teleopDriverRating += d.teleop.driverRating;
          teleopAvgScoredWhileAmped += d.teleop.scoredWhileAmped;
          endgameCanClimb = d.endgame.endState == EndStatus.on_chain;
          endgameHarmonyAttemptSuccessRate +=
              d.endgame.harmonyAttempted &&
                      d.endgame.harmony == Harmony.yes
                  ? 1
                  : 0;
          endgamePercentOfGamesScoredTrap +=
              d.endgame.trapScored == TrapScored.yes ? 1 : 0;
          miscWinLikelihoods +=
              d.endgame.matchResult == MatchResult.win ? 1 : 0;
        }
        autoPercentGetMovementPoints /= data.length;
        autoAvgScoredSpeaker /= data.length;
        autoAvgScoredInAmp /= data.length;
        autoPercentOfPickupAmpSideNote /= data.length;
        autoPercentOfPickupStageSideNote /= data.length;
        autoPercentOfPickupMiddleSideNote /= data.length;
        autoPercentStartLeft /= data.length;
        autoPercentStartRight /= data.length;
        autoPercentStartMiddle /= data.length;
        teleopAvgScoredInSpeaker /= data.length;
        teleopAvgScoredInAmp /= data.length;
        teleopAvgNotesScored /= data.length;
        teleopDriverRating /= data.length;
        teleopAvgScoredWhileAmped /= data.length;
        endgameHarmonyAttemptSuccessRate /= data.length;
        endgamePercentOfGamesScoredTrap /= data.length;
        miscWinLikelihoods /= data.length;
        Color heat(double percent) {
          assert(percent >= 0 && percent <= 1);
          if (percent < 0.5) {
            return Colors.red;
          } else if (percent < 0.75) {
            return Colors.orange;
          } else {
            return Colors.green;
          }
        }

        widgets.add(Padding(
          padding: const EdgeInsets.only(left: 12, right: 12),
          child: Card(
              child: form_sec_rigid(context,
                  headerIcon: const Icon(Icons.group_rounded),
                  title: Text("Team $teamNumber",
                      style: const TextStyle(
                          fontSize: 24, fontWeight: FontWeight.bold)),
                  child: Builder(builder: (BuildContext context) {
            return Column(children: <Widget>[
              Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Text.rich(
                          TextSpan(children: <InlineSpan>[
                            const TextSpan(
                                text: "Matches Recorded: ",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold)),
                            TextSpan(text: data.length.toString()),
                            const TextSpan(
                                text: "\nWinrate: ",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold)),
                            TextSpan(
                                text:
                                    "${(miscWinLikelihoods * 100).toStringAsFixed(2)}%",
                                style: TextStyle(
                                    color: heat(miscWinLikelihoods),
                                    backgroundColor: Colors.black)),
                          ]),
                          style: const TextStyle(fontSize: 16)),
                    ],
                  ),
                  const SizedBox(height: 12),
                ],
              ),
              const SizedBox(height: 12),
              Wrap(runSpacing: 8, spacing: 8, children: <Widget>[
                FilledButton.tonalIcon(
                    onPressed:
                        () => Navigator.of(context)
                                .push(MaterialPageRoute<Widget>(
                              builder: (BuildContext context) =>
                                  Scaffold(
                                resizeToAvoidBottomInset: false,
                                appBar: AppBar(
                                    title: Row(
                                  children: <Widget>[
                                    const Icon(
                                        Icons.auto_graph_rounded),
                                    const SizedBox(width: 8),
                                    Text(
                                        "Stats for team $teamNumber"),
                                  ],
                                )),
                                body: SingleChildScrollView(
                                    physics:
                                        const AlwaysScrollableScrollPhysics(
                                            parent:
                                                BouncingScrollPhysics()),
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.all(16),
                                      child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: <Widget>[
                                            Card(
                                              child: form_sec_rigid(
                                                context,
                                                title: const Text(
                                                    "Auto",
                                                    style: TextStyle(
                                                        fontSize: 32,
                                                        fontWeight:
                                                            FontWeight
                                                                .bold)),
                                                headerIcon:
                                                    const Icon(Icons
                                                        .auto_awesome_rounded),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets
                                                          .all(8.0),
                                                  child: Row(
                                                    children: <Widget>[
                                                      Text.rich(
                                                        TextSpan(
                                                          children: <InlineSpan>[
                                                            const TextSpan(
                                                              text:
                                                                  "% Movement Points: ",
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight.bold),
                                                            ),
                                                            TextSpan(
                                                                text:
                                                                    "${(autoPercentGetMovementPoints * 100).toStringAsFixed(2)}%",
                                                                style: TextStyle(
                                                                    color: heat(autoPercentGetMovementPoints),
                                                                    backgroundColor: Colors.black)),
                                                            const TextSpan(
                                                                text:
                                                                    "\nAvg Scored in Speaker: ",
                                                                style:
                                                                    TextStyle(fontWeight: FontWeight.bold)),
                                                            TextSpan(
                                                              text: autoAvgScoredSpeaker
                                                                  .toStringAsFixed(2),
                                                            ),
                                                            const TextSpan(
                                                              text:
                                                                  "\nAvg Scored in Amp: ",
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight.bold),
                                                            ),
                                                            TextSpan(
                                                              text: autoAvgScoredInAmp
                                                                  .toStringAsFixed(2),
                                                            ),
                                                            const TextSpan(
                                                              text:
                                                                  "\n% of Pickups AMP Side: ",
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight.bold),
                                                            ),
                                                            TextSpan(
                                                              text:
                                                                  "${(autoPercentOfPickupAmpSideNote * 100).toStringAsFixed(2)}%",
                                                              style: TextStyle(
                                                                  color:
                                                                      heat(autoPercentOfPickupAmpSideNote),
                                                                  backgroundColor: Colors.black),
                                                            ),
                                                            const TextSpan(
                                                              text:
                                                                  "\n% of Pickups Stage Side: ",
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight.bold),
                                                            ),
                                                            TextSpan(
                                                              text:
                                                                  "${(autoPercentOfPickupStageSideNote * 100).toStringAsFixed(2)}%",
                                                              style: TextStyle(
                                                                  color:
                                                                      heat(autoPercentOfPickupStageSideNote),
                                                                  backgroundColor: Colors.black),
                                                            ),
                                                            const TextSpan(
                                                              text:
                                                                  "\n% of Pickups Middle: ",
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight.bold),
                                                            ),
                                                            TextSpan(
                                                              text:
                                                                  "${(autoPercentOfPickupMiddleSideNote * 100).toStringAsFixed(2)}%",
                                                              style: TextStyle(
                                                                  color:
                                                                      heat(autoPercentOfPickupMiddleSideNote),
                                                                  backgroundColor: Colors.black),
                                                            ),
                                                            const TextSpan(
                                                              text:
                                                                  "\n% of Start AMP Side: ",
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight.bold),
                                                            ),
                                                            TextSpan(
                                                              text:
                                                                  "${(autoPercentStartLeft * 100).toStringAsFixed(2)}%",
                                                              style: TextStyle(
                                                                  color:
                                                                      heat(autoPercentStartLeft),
                                                                  backgroundColor: Colors.black),
                                                            ),
                                                            const TextSpan(
                                                              text:
                                                                  "\n% of Start Stage Side: ",
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight.bold),
                                                            ),
                                                            TextSpan(
                                                              text:
                                                                  "${(autoPercentStartRight * 100).toStringAsFixed(2)}%",
                                                              style: TextStyle(
                                                                  color:
                                                                      heat(autoPercentStartRight),
                                                                  backgroundColor: Colors.black),
                                                            ),
                                                            const TextSpan(
                                                              text:
                                                                  "\n% of Start Middle: ",
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight.bold),
                                                            ),
                                                            TextSpan(
                                                              text:
                                                                  "${(autoPercentStartMiddle * 100).toStringAsFixed(2)}%",
                                                              style: TextStyle(
                                                                  color:
                                                                      heat(autoPercentStartMiddle),
                                                                  backgroundColor: Colors.black),
                                                            ),
                                                          ],
                                                          style: const TextStyle(
                                                              fontSize:
                                                                  18),
                                                        ),
                                                      ),
                                                      const Spacer(), // this is a scuffed solution
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                                height: 16),
                                            Card(
                                              child: form_sec_rigid(
                                                context,
                                                title: const Text(
                                                    "Tele-Op",
                                                    style: TextStyle(
                                                        fontSize: 32,
                                                        fontWeight:
                                                            FontWeight
                                                                .bold)),
                                                headerIcon:
                                                    const Icon(Icons
                                                        .group_rounded),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets
                                                          .all(8.0),
                                                  child: Row(
                                                    children: <Widget>[
                                                      Text.rich(
                                                        TextSpan(
                                                            children: <InlineSpan>[
                                                              const TextSpan(
                                                                text:
                                                                    "Avg Scored in Speaker: ",
                                                                style:
                                                                    TextStyle(fontWeight: FontWeight.bold),
                                                              ),
                                                              TextSpan(
                                                                text:
                                                                    teleopAvgScoredInSpeaker.toStringAsFixed(2),
                                                              ),
                                                              const TextSpan(
                                                                text:
                                                                    "\nAvg Scored in Amp: ",
                                                                style:
                                                                    TextStyle(fontWeight: FontWeight.bold),
                                                              ),
                                                              TextSpan(
                                                                text:
                                                                    teleopAvgScoredInAmp.toStringAsFixed(2),
                                                              ),
                                                              const TextSpan(
                                                                text:
                                                                    "\nAvg Notes Scored: ",
                                                                style:
                                                                    TextStyle(fontWeight: FontWeight.bold),
                                                              ),
                                                              TextSpan(
                                                                text:
                                                                    teleopAvgNotesScored.toStringAsFixed(2),
                                                              ),
                                                              const TextSpan(
                                                                text:
                                                                    "\nGoes Under Stage: ",
                                                                style:
                                                                    TextStyle(fontWeight: FontWeight.bold),
                                                              ),
                                                              TextSpan(
                                                                text: teleopGoesUnderStage
                                                                    ? "Yes"
                                                                    : "No",
                                                              ),
                                                              const TextSpan(
                                                                text:
                                                                    "\nDriver Rating: ",
                                                                style:
                                                                    TextStyle(fontWeight: FontWeight.bold),
                                                              ),
                                                              TextSpan(
                                                                text:
                                                                    "${teleopDriverRating.toStringAsFixed(2)}/10",
                                                                style: TextStyle(
                                                                    color: heat(teleopDriverRating / 10),
                                                                    backgroundColor: Colors.black),
                                                              ),
                                                              const TextSpan(
                                                                text:
                                                                    "\nAvg Scored While Amped: ",
                                                                style:
                                                                    TextStyle(fontWeight: FontWeight.bold),
                                                              ),
                                                              TextSpan(
                                                                text:
                                                                    teleopAvgScoredWhileAmped.toStringAsFixed(2),
                                                              ),
                                                            ],
                                                            style: const TextStyle(
                                                                fontSize:
                                                                    18)),
                                                      ),
                                                      const Spacer(),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                                height: 16),
                                            Card(
                                              child: form_sec_rigid(
                                                context,
                                                title: const Text(
                                                    "End Game",
                                                    style: TextStyle(
                                                        fontSize: 32,
                                                        fontWeight:
                                                            FontWeight
                                                                .bold)),
                                                headerIcon:
                                                    const Icon(Icons
                                                        .commit_rounded),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets
                                                          .all(8.0),
                                                  child: Row(
                                                    children: <Widget>[
                                                      Text.rich(
                                                        TextSpan(
                                                            children: <InlineSpan>[
                                                              const TextSpan(
                                                                text:
                                                                    "Can Climb: ",
                                                                style:
                                                                    TextStyle(fontWeight: FontWeight.bold),
                                                              ),
                                                              TextSpan(
                                                                text: endgameCanClimb
                                                                    ? "Yes"
                                                                    : "No",
                                                              ),
                                                              const TextSpan(
                                                                text:
                                                                    "\nHarmony Attempt Success Rate: ",
                                                                style:
                                                                    TextStyle(fontWeight: FontWeight.bold),
                                                              ),
                                                              TextSpan(
                                                                text:
                                                                    "${(endgameHarmonyAttemptSuccessRate * 100).toStringAsFixed(2)}% ",
                                                                style: TextStyle(
                                                                    color: heat(endgameHarmonyAttemptSuccessRate),
                                                                    backgroundColor: Colors.black),
                                                              ),
                                                              const TextSpan(
                                                                text:
                                                                    "\n% of Games Scored Trap: ",
                                                                style:
                                                                    TextStyle(fontWeight: FontWeight.bold),
                                                              ),
                                                              TextSpan(
                                                                text:
                                                                    "${(endgamePercentOfGamesScoredTrap * 100).toStringAsFixed(2)}% ",
                                                                style: TextStyle(
                                                                    color: heat(endgamePercentOfGamesScoredTrap),
                                                                    backgroundColor: Colors.black),
                                                              ),
                                                            ],
                                                            style: const TextStyle(
                                                                fontSize:
                                                                    18)),
                                                      ),
                                                      const Spacer(),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                                height: 16),
                                            Card(
                                              child: form_sec_rigid(
                                                context,
                                                title: const Text(
                                                    "Misc",
                                                    style: TextStyle(
                                                        fontSize: 32,
                                                        fontWeight:
                                                            FontWeight
                                                                .bold)),
                                                headerIcon:
                                                    const Icon(Icons
                                                        .miscellaneous_services_rounded),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets
                                                          .all(8.0),
                                                  child: Row(
                                                    children: <Widget>[
                                                      Text.rich(
                                                        TextSpan(
                                                            children: <InlineSpan>[
                                                              const TextSpan(
                                                                text:
                                                                    "Win Likelihood: ",
                                                                style:
                                                                    TextStyle(fontWeight: FontWeight.bold),
                                                              ),
                                                              TextSpan(
                                                                text:
                                                                    "${(miscWinLikelihoods * 100).toStringAsFixed(2)}%",
                                                                style: TextStyle(
                                                                    color: heat(miscWinLikelihoods),
                                                                    backgroundColor: Colors.black),
                                                              ),
                                                            ],
                                                            style: const TextStyle(
                                                                fontSize:
                                                                    18)),
                                                      ),
                                                      const Spacer(),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                                height: 40),
                                          ]),
                                    )),
                              ),
                            )),
                    icon: const Icon(Icons.auto_graph_rounded),
                    label: const Text("View Stats")),
                const SizedBox(height: 8),
                FilledButton.tonalIcon(
                    onPressed: () => Navigator.of(context).push(
                        MaterialPageRoute<Widget>(
                            builder: (BuildContext context) =>
                                Scaffold(
                                    body: PreferCompactModal
                                            .isCompactPreferred(
                                                context)
                                        ? Builder(
                                            // this could be optimized further with a futurebuilder
                                            builder: (BuildContext
                                                context) {
                                              List<Widget> widgets =
                                                  <Widget>[];
                                              for (HollisticMatchScoutingData match
                                                  in data) {
                                                Debug().info(
                                                    "DUC_TEAM_MATCH_HISTORY: Adding match ${match.id}");
                                                widgets
                                                    .add(DucMatchTile(
                                                  match: match,
                                                  onDelete:
                                                      (String id) {
                                                    Provider.of<DucBaseBit>(
                                                            context,
                                                            listen:
                                                                false)
                                                        .removeID(id);
                                                    Provider.of<DucBaseBit>(
                                                            context,
                                                            listen:
                                                                false)
                                                        .save();
                                                  },
                                                ));
                                              }
                                              return form_grid_2(
                                                crossAxisCount: 2,
                                                mainAxisSpacing: 14,
                                                crossAxisSpacing: 14,
                                                children: widgets,
                                              );
                                            },
                                          )
                                        : ListView.builder(
                                            physics: const AlwaysScrollableScrollPhysics(
                                                parent: BouncingScrollPhysics(
                                                    decelerationRate:
                                                        ScrollDecelerationRate
                                                            .normal)),
                                            padding:
                                                const EdgeInsets.only(
                                                    bottom: 40),
                                            itemCount: data.length,
                                            itemBuilder:
                                                (BuildContext context,
                                                    int index) {
                                              return DucMatchTile(
                                                match: data[index],
                                                onDelete:
                                                    (String id) {
                                                  Provider.of<DucBaseBit>(
                                                          context,
                                                          listen:
                                                              false)
                                                      .removeID(id);
                                                  Provider.of<DucBaseBit>(
                                                          context,
                                                          listen:
                                                              false)
                                                      .save();
                                                },
                                              );
                                            },
                                          ),
                                    appBar: AppBar(
                                        title: Row(children: <Widget>[
                                      const Icon(
                                          Icons.history_rounded),
                                      const SizedBox(width: 8),
                                      Text(
                                          "Match History for Team $teamNumber"),
                                    ]))))),
                    icon: const Icon(Icons.search_rounded),
                    label: const Text("View Matches")),
                const SizedBox(height: 8),
                FilledButton.tonalIcon(
                    onPressed: () async => await Clipboard.setData(
                            ClipboardData(text: """
                                    # Team $teamNumber
                                    ## Auto
                                    > **% Movement Points** ${(autoPercentGetMovementPoints * 100).toStringAsFixed(2)}%
                                    > **Avg Scored in Speaker** ${autoAvgScoredSpeaker.toStringAsFixed(2)}
                                    > **Avg Scored in Amp** ${autoAvgScoredInAmp.toStringAsFixed(2)}
                                    > **% of Pickups AMP Side** ${(autoPercentOfPickupAmpSideNote * 100).toStringAsFixed(2)}%
                                    > **% of Pickups Stage Side** ${(autoPercentOfPickupStageSideNote * 100).toStringAsFixed(2)}%
                                    > **% of Pickups Speaker Side** ${(autoPercentOfPickupMiddleSideNote * 100).toStringAsFixed(2)}%
                                    > **% of Start Left** ${(autoPercentStartLeft * 100).toStringAsFixed(2)}%
                                    > **% of Start Right** ${(autoPercentStartRight * 100).toStringAsFixed(2)}%
                                    > **% of Start Middle** ${(autoPercentStartMiddle * 100).toStringAsFixed(2)}%
                                    ## Tele-Op
                                    > **Avg Scored in Speaker** ${teleopAvgScoredInSpeaker.toStringAsFixed(2)}
                                    > **Avg Scored in AMP** ${teleopAvgScoredInAmp.toStringAsFixed(2)}
                                    > **Avg Notes Scored** ${teleopAvgNotesScored.toStringAsFixed(2)}
                                    > **Goes Under Stage** ${teleopGoesUnderStage ? "Yes" : "No"}
                                    > **Driver Rating** ${teleopDriverRating.toStringAsFixed(2)}/10
                                    > **Avg Scored While Amped** ${teleopAvgScoredWhileAmped.toStringAsFixed(2)}
                                    ## End Game
                                    > **Can Climb** ${endgameCanClimb ? "Yes" : "No"}
                                    > **Harmony Attempt Success Rate** ${(endgameHarmonyAttemptSuccessRate * 100).toStringAsFixed(2)}%
                                    > **% of Games Scored Trap** ${(endgamePercentOfGamesScoredTrap * 100).toStringAsFixed(2)}%
                                    ## Misc
                                    > **Win Likelihood** ${(miscWinLikelihoods * 100).toStringAsFixed(2)}%

                                    `Timestamp: ${DateFormat("yyyy-MM-dd HH:mm:ss").format(DateTime.now())} UTC`
                                    """))
                        .then((_) => ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                                content: Text(
                                    "Copied to Clipboard! Now send it on Discord!")))),
                    icon: const Icon(Icons.discord_rounded),
                    label: const Text("Discord Copy")),
                FilledButton.tonalIcon(
                    onPressed: () async => await launchAssuredConfirmDialog(
                        context,
                        message:
                            "Are you sure you want to delete all DUC data for team $teamNumber? This is irreversible!",
                        title: "Delete Team $teamNumber",
                        onConfirm: () async => await Provider.of<
                                DucBaseBit>(context, listen: false)
                            .removeWhere((HollisticMatchScoutingData d) =>
                                d.preliminary.teamNumber ==
                                teamNumber)
                            .then((_) => Debug().info(
                                "Removed all DUC data for team $teamNumber..."))),
                    icon: const Icon(Icons.delete_forever_rounded),
                    label: const Text("Delete"))
              ])
            ]);
          }))),
        ));
      });
      return widgets;
    }
    return <Widget>[
      const SizedBox(height: 24),
      const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(CommunityMaterialIcons.emoticon_cry, size: 96),
          SizedBox(width: 4),
          Icon(CommunityMaterialIcons.duck, size: 32)
        ],
      ),
      const Padding(
        padding: EdgeInsets.all(16),
        child: Text(
          "No DUC data found! Please scan or paste some.",
          style: TextStyle(fontSize: 20),
          softWrap: true,
          textAlign: TextAlign.center,
        ),
      )
    ];
  }
}

class _SearchTeamsDialog extends StatefulWidget {
  final void Function(String teamNumber) onSubmit;
  final bool Function(String teamNumber) onValidate;

  const _SearchTeamsDialog(
      {required this.onSubmit, required this.onValidate});

  @override
  State<_SearchTeamsDialog> createState() =>
      _SearchTeamsDialogState();
}

class _SearchTeamsDialogState extends State<_SearchTeamsDialog> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        title: const Text("Search Teams"),
        icon: const Icon(Icons.search_rounded),
        actions: <Widget>[
          FilledButton.tonalIcon(
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(Icons.cancel_rounded),
              label: const Text("Cancel")),
          FilledButton.tonalIcon(
              onPressed: () => widget.onSubmit(_controller.text),
              icon: const Icon(Icons.check_rounded),
              label: const Text("Search"))
        ],
        content:
            Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
          const Text("Enter a team number to search for:"),
          const SizedBox(height: 8),
          TextFormField(
              controller: _controller,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                  labelText: "Team Number",
                  errorMaxLines: 2,
                  errorText: widget.onValidate(_controller.text)
                      ? null
                      : "Invalid Team Number",
                  hintText: "Enter a team number"))
        ]));
  }
}

class _PasteDucData extends StatefulWidget {
  final BuildContext parentContext;
  const _PasteDucData(this.parentContext);

  @override
  State<_PasteDucData> createState() => _PasteDucDataState();
}

class _PasteDucDataState extends State<_PasteDucData> {
  late TextEditingController _controller;
  late bool _isBadData;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _isBadData = false;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        icon: const Icon(CommunityMaterialIcons.duck),
        title: const Text("Manual Paste DUC data"),
        content: TextFormField(
            controller: _controller,
            keyboardType: TextInputType.multiline,
            decoration: InputDecoration(
                errorMaxLines: 2,
                errorText: _isBadData ? "Bad Data" : null),
            maxLines: null),
        actions: <Widget>[
          FilledButton.tonalIcon(
              onPressed: () {
                final String data = _controller.text;
                String? res = fromDucFormatExtern(data);
                if (res == null) {
                  setState(() => _isBadData = true);
                } else {
                  HollisticMatchScoutingData data =
                      HollisticMatchScoutingData.fromCompatibleFormat(
                          res);
                  if (Provider.of<DucBaseBit>(widget.parentContext,
                          listen: false)
                      .containsID(data.id)) {
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text(
                                "This DUC seems to be already recorded...")));
                    return;
                  }
                  Provider.of<DucBaseBit>(widget.parentContext,
                          listen: false)
                      .add(HollisticMatchScoutingData
                          .fromCompatibleFormat(res));
                  Navigator.of(context).pop();
                  Debug().info(
                      "Submitted new DUC Information from QR_PASTE");
                }
              },
              icon: const Icon(Icons.check_rounded),
              label: const Text("Submit")),
          FilledButton.tonalIcon(
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(Icons.close_rounded),
              label: const Text("Cancel"))
        ]);
  }
}

class _QrScanner extends StatefulWidget {
  const _QrScanner();

  @override
  State<_QrScanner> createState() => _QrScannerState();
}

class _QrScannerState extends State<_QrScanner> {
  late MobileScannerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = MobileScannerController(
      detectionSpeed: DetectionSpeed.noDuplicates,
      facing: CameraFacing.back,
      torchEnabled: false,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        const SizedBox(height: 20),
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            "If the camera below does not show, exit and re-enter this page.",
            style: TextStyle(fontSize: 16),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.only(left: 8, right: 8),
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.blue[400]),
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Row(children: <Widget>[
                Icon(Icons.info_rounded, color: Colors.black),
                SizedBox(width: 8),
                Text(
                  "The scanner will automatically detect QR DUC date.",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.bold),
                  softWrap: true,
                ),
              ]),
            ),
          ),
        ),
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.only(
              bottom:
                  20), // sized box below doesnt work well because of the mobile scanner being present
          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                FilledButton.tonalIcon(
                  label: const Text("Flashlight"),
                  onPressed: () => _controller.toggleTorch(),
                  icon: ValueListenableBuilder<TorchState>(
                    valueListenable: _controller.torchState,
                    builder: (BuildContext context, TorchState state,
                            Widget? child) =>
                        state == TorchState.on
                            ? const Icon(Icons.flash_on_rounded)
                            : const Icon(Icons.flash_off_rounded),
                  ),
                ),
                const SizedBox(width: 8),
                FilledButton.tonalIcon(
                    label: const Text("Orientation"),
                    onPressed: () => _controller.switchCamera(),
                    icon: ValueListenableBuilder<CameraFacing>(
                      valueListenable: _controller.cameraFacingState,
                      builder: (BuildContext context,
                              CameraFacing state, Widget? child) =>
                          state == CameraFacing.front
                              ? const Icon(Icons.camera_front_rounded)
                              : const Icon(Icons.camera_rear_rounded),
                    ))
              ]),
        ),
        SizedBox(
          width: 512,
          height: 512,
          child: MobileScanner(
            controller: _controller,
            onDetect: (BarcodeCapture capture) {
              final List<Barcode> barcodes = capture.barcodes;
              for (final Barcode barcode in barcodes) {
                if (barcode.format == BarcodeFormat.qrCode &&
                    barcode.rawValue != null) {
                  Debug().info(
                      "[DUC] found external code from QR_SCAN. Received RAW=${barcode.rawValue}");
                  Debug().info("Checking if it is a DUC...");
                  String? res =
                      fromDucFormatExtern(barcode.rawValue!);
                  if (res != null) {
                    HollisticMatchScoutingData data =
                        HollisticMatchScoutingData
                            .fromCompatibleFormat(res);
                    if (Provider.of<DucBaseBit>(context,
                            listen: false)
                        .containsID(data.id)) {
                      Debug().warn("DUC already exists, Ignored...");
                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text(
                                  "This DUC seems to be already recorded...")));
                      return;
                    }
                    Debug().info(
                        "It is a unique DUC! Adding to the list...");
                    Provider.of<DucBaseBit>(context, listen: false)
                        .add(HollisticMatchScoutingData
                            .fromCompatibleFormat(res));
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content:
                                Text("DUC Detected and Added!")));
                  } else {
                    Debug().warn("Not DUC detected, Ignored...");
                  }
                  break;
                }
              }
            },
          ),
        ),
      ],
    );
  }
}

class DucMatchTile extends StatefulWidget {
  final HollisticMatchScoutingData match;
  final void Function(String id) onDelete;

  const DucMatchTile(
      {super.key, required this.match, required this.onDelete});

  @override
  State<DucMatchTile> createState() => _DucMatchTileState();
}

class _DucMatchTileState extends State<DucMatchTile> {
  @override
  Widget build(BuildContext context) {
    void launchInsightView() {
      Navigator.of(context)
          .push(MaterialPageRoute<Widget>(builder: (BuildContext _) {
        return Scaffold(
          resizeToAvoidBottomInset: false,
          body: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(
                  parent: BouncingScrollPhysics()),
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(children: <Widget>[
                  const Row(children: <Widget>[
                    Icon(Icons.info_rounded),
                    SizedBox(width: 8),
                    Text("Preliminary",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20)),
                  ]),
                  const SizedBox(height: 8),
                  Row(
                    children: <Widget>[
                      Text.rich(
                          TextSpan(children: <InlineSpan>[
                            const TextSpan(
                                text: "Time: ",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold)),
                            TextSpan(
                                text: DateFormat(
                                        Shared.GENERAL_TIME_FORMAT)
                                    .format(DateTime
                                        .fromMillisecondsSinceEpoch(
                                            widget.match.preliminary
                                                .timeStamp))),
                            const TextSpan(
                                text: "\nMatch: ",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold)),
                            TextSpan(
                                text:
                                    "${widget.match.preliminary.matchType.name.formalize} #${widget.match.preliminary.matchNumber}"),
                            const TextSpan(
                                text: "\nTeam: ",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold)),
                            TextSpan(
                                text:
                                    "${widget.match.preliminary.teamNumber}"),
                            const TextSpan(
                                text: "\nAlliance: ",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold)),
                            TextSpan(
                                text: widget.match.preliminary
                                    .alliance.name.formalize,
                                style: TextStyle(
                                    color: widget
                                        .match.preliminary.alliance
                                        .toColor(),
                                    backgroundColor: Colors.black)),
                            const TextSpan(
                                text: "\nStarting Position: ",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold)),
                            TextSpan(
                                text: widget.match.preliminary
                                    .startingPosition.name.formalize),
                          ]),
                          style: const TextStyle(fontSize: 16)),
                      const Spacer() // more scuffed solutions XD (see above)
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Row(children: <Widget>[
                    Icon(CommunityMaterialIcons.robot),
                    SizedBox(width: 8),
                    Text("Auto",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20)),
                  ]),
                  const SizedBox(height: 8),
                  Row(
                    children: <Widget>[
                      Text.rich(
                          TextSpan(children: <InlineSpan>[
                            const TextSpan(
                                text: "Taxi: ",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold)),
                            TextSpan(
                                text: widget.match.auto.taxi
                                    ? "Yes"
                                    : "No"),
                            const TextSpan(
                                text: "\nScored Speaker: ",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold)),
                            TextSpan(
                                text: widget.match.auto.scoredSpeaker
                                    .toString()),
                            const TextSpan(
                                text: "\nScored Amp: ",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold)),
                            TextSpan(
                                text: widget.match.auto.scoredAmp
                                    .toString()),
                            const TextSpan(
                                text: "\nNotes Picked Up: ",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold)),
                            TextSpan(
                                text: widget.match.auto.notesPickedUp
                                    .map((AutoPickup e) =>
                                        e.name.formalize)
                                    .join(", ")),
                            const TextSpan(
                                text: "\nNotes Preloaded: ",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold)),
                            TextSpan(
                              text: widget.match.auto.notePreloaded
                                  ? "Yes"
                                  : "No",
                            ),
                            const TextSpan(
                                text: "\nNotes Picked up: ",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold)),
                            TextSpan(
                                text: widget.match.auto.notesPickedUp
                                    .map((AutoPickup e) =>
                                        e.name.formalize)
                                    .join(", ")),
                            const TextSpan(
                                text: "\nAMP Missed: ",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold)),
                            TextSpan(
                                text: widget.match.auto.missedAmp
                                    .toString()),
                            const TextSpan(
                                text: "\nSpeaker Missed: ",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold)),
                            TextSpan(
                                text: widget.match.auto.missedSpeaker
                                    .toString()),
                          ]),
                          style: const TextStyle(fontSize: 16)),
                      const Spacer()
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Row(children: <Widget>[
                    Icon(Icons.group_rounded),
                    SizedBox(width: 8),
                    Text("Tele-Op",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20)),
                  ]),
                  const SizedBox(height: 8),
                  Row(
                    children: <Widget>[
                      Text.rich(
                          TextSpan(children: <InlineSpan>[
                            const TextSpan(
                                text: "Scored Speaker: ",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold)),
                            TextSpan(
                                text: widget
                                    .match.teleop.scoredSpeaker
                                    .toString()),
                            const TextSpan(
                                text: "\nScored Amp: ",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold)),
                            TextSpan(
                                text: widget.match.teleop.scoredAmp
                                    .toString()),
                            const TextSpan(
                                text: "\nPieces Scored: ",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold)),
                            TextSpan(
                                text: widget.match.teleop.piecesScored
                                    .toString()),
                            const TextSpan(
                                text: "\nUnder Stage: ",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold)),
                            TextSpan(
                                text: widget.match.teleop.underStage
                                    ? "Yes"
                                    : "No"),
                            const TextSpan(
                                text: "\nDriver Rating: ",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold)),
                            TextSpan(
                                text: widget.match.teleop.driverRating
                                    .toString()),
                            const TextSpan(
                                text: "\nScored While Amped: ",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold)),
                            TextSpan(
                                text: widget
                                    .match.teleop.scoredWhileAmped
                                    .toString()),
                            const TextSpan(
                                text: "\nMissed Amp: ",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold)),
                            TextSpan(
                                text: widget.match.teleop.missedAmp
                                    .toString()),
                            const TextSpan(
                                text: "\nMissed Speaker: ",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold)),
                            TextSpan(
                                text: widget
                                    .match.teleop.missedSpeaker
                                    .toString()),
                          ]),
                          style: const TextStyle(fontSize: 16)),
                      const Spacer()
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Row(children: <Widget>[
                    Icon(Icons.commit_rounded),
                    SizedBox(width: 8),
                    Text("Endgame",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20)),
                  ]),
                  const SizedBox(height: 8),
                  Row(
                    children: <Widget>[
                      Text.rich(
                          TextSpan(children: <InlineSpan>[
                            const TextSpan(
                                text: "End State: ",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold)),
                            TextSpan(
                                text: widget.match.endgame.endState
                                    .name.formalize),
                            const TextSpan(
                                text: "\nHarmony: ",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold)),
                            TextSpan(
                                text: widget.match.endgame.harmony
                                    .name.formalize),
                            const TextSpan(
                                text: "\nHarmony Attempted: ",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold)),
                            TextSpan(
                                text: widget.match.endgame
                                        .harmonyAttempted
                                    ? "Yes"
                                    : "No"),
                            const TextSpan(
                                text: "\nTrap Scored: ",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold)),
                            TextSpan(
                                text: widget.match.endgame.trapScored
                                    .name.formalize),
                            const TextSpan(
                                text: "\nCoopertition: ",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold)),
                            TextSpan(
                                text: widget.match.misc.coopertition
                                    .toString()),
                            const TextSpan(
                                text: "\nMatch Result: ",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold)),
                            TextSpan(
                                text: widget.match.endgame.matchResult
                                    .name.formalize),
                          ]),
                          style: const TextStyle(fontSize: 16)),
                      const Spacer()
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Row(children: <Widget>[
                    Icon(Icons.miscellaneous_services_rounded),
                    SizedBox(width: 8),
                    Text("Misc",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20)),
                  ]),
                  const SizedBox(height: 8),
                  Row(
                    children: <Widget>[
                      Text.rich(
                          TextSpan(children: <InlineSpan>[
                            const TextSpan(
                                text: "ID: ",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold)),
                            TextSpan(text: widget.match.id),
                            const TextSpan(
                                text: "\nTimestamp: ",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold)),
                            TextSpan(
                                text: DateFormat(
                                        Shared.GENERAL_TIME_FORMAT)
                                    .format(DateTime
                                        .fromMillisecondsSinceEpoch(
                                            widget.match.preliminary
                                                .timeStamp))),
                          ]),
                          style: const TextStyle(fontSize: 16)),
                      const Spacer()
                    ],
                  ),
                  const SizedBox(height: 40)
                ]),
              )),
          appBar: AppBar(
              title: Row(
            children: <Widget>[
              const Icon(Icons.insights_rounded),
              const SizedBox(width: 8),
              Text(
                  "Insights for match ${widget.match.preliminary.matchNumber} of team ${widget.match.preliminary.teamNumber}"),
            ],
          )),
        );
      }));
    }

    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8, top: 8),
      child: Card(
        child: form_sec_rigid(
          context,
          headerIcon: Icon(Icons.flag_circle_rounded,
              size: 40,
              color:
                  PreferCanonicalModal.isCanonicalPreferred(context)
                      ? widget.match.preliminary.alliance.toColor()
                      : null),
          title: Text.rich(TextSpan(
              text:
                  "${widget.match.preliminary.matchType.name.formalize} #${widget.match.preliminary.matchNumber} | Team ${widget.match.preliminary.teamNumber} | ${widget.match.preliminary.alliance.name.formalize}\n",
              style: const TextStyle(
                  fontWeight: FontWeight.w700, fontSize: 20),
              children: <InlineSpan>[
                TextSpan(
                    text: DateFormat(Shared.GENERAL_TIME_FORMAT)
                        .format(DateTime.fromMillisecondsSinceEpoch(
                            widget.match.preliminary.timeStamp)),
                    style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        overflow: TextOverflow.ellipsis,
                        fontSize: 14)),
                TextSpan(
                    text: "\n${widget.match.id}",
                    style: const TextStyle(
                        fontWeight: FontWeight.w300,
                        overflow: TextOverflow.ellipsis,
                        fontSize: 12))
              ])),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                form_label_2("Overview",
                    allowRigid: false,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        fontStyle: FontStyle.italic,
                        overflow: TextOverflow.ellipsis),
                    icon: const Icon(Icons.data_exploration_rounded),
                    child: Row(children: <Widget>[
                      Text.rich(TextSpan(children: <InlineSpan>[
                        const TextSpan(
                            text: "- Starting Position: ",
                            style: TextStyle(
                                overflow: TextOverflow.ellipsis,
                                height: 1.6,
                                fontWeight: FontWeight.w700)),
                        TextSpan(
                            text:
                                "${widget.match.preliminary.startingPosition.name.formalize}\n",
                            style: const TextStyle(
                              height: 1.6,
                            )),
                        const TextSpan(
                            text: "- Harmonized: ",
                            style: TextStyle(
                                overflow: TextOverflow.ellipsis,
                                height: 1.6,
                                fontWeight: FontWeight.w700)),
                        TextSpan(
                            text:
                                "${widget.match.endgame.harmony.name.formalize}\n",
                            style: const TextStyle(
                                height: 1.6,
                                overflow: TextOverflow.ellipsis)),
                        const TextSpan(
                            text: "- Trap Scored: ",
                            style: TextStyle(
                                height: 1.6,
                                fontWeight: FontWeight.w700,
                                overflow: TextOverflow.ellipsis)),
                        TextSpan(
                            text:
                                "${widget.match.endgame.trapScored.name.formalize}\n",
                            style: const TextStyle(
                                height: 1.6,
                                overflow: TextOverflow.ellipsis)),
                        const TextSpan(
                            text: "- Auto Speaker Scored: ",
                            style: TextStyle(
                                height: 1.6,
                                fontWeight: FontWeight.w700,
                                overflow: TextOverflow.ellipsis)),
                        TextSpan(
                            text:
                                "${widget.match.auto.scoredSpeaker}\n",
                            style: const TextStyle(
                                height: 1.6,
                                overflow: TextOverflow.ellipsis)),
                        const TextSpan(
                            text: "- TeleOp Speaker Scored: ",
                            style: TextStyle(
                                height: 1.6,
                                fontWeight: FontWeight.w700,
                                overflow: TextOverflow.ellipsis)),
                        TextSpan(
                            text:
                                "${widget.match.teleop.scoredSpeaker}\n",
                            style: const TextStyle(
                                height: 1.6,
                                overflow: TextOverflow.ellipsis)),
                      ])),
                      const VerticalDivider(),
                      Text.rich(TextSpan(children: <InlineSpan>[
                        const TextSpan(
                            text: "- End: ",
                            style: TextStyle(
                                overflow: TextOverflow.ellipsis,
                                height: 1.6,
                                fontWeight: FontWeight.w700)),
                        TextSpan(
                            text:
                                "${widget.match.endgame.endState.name.replaceAll("_", " ").formalize}\n",
                            style: const TextStyle(
                              height: 1.6,
                            )),
                        const TextSpan(
                            text: "- Coopertition: ",
                            style: TextStyle(
                                overflow: TextOverflow.ellipsis,
                                height: 1.6,
                                fontWeight: FontWeight.w700)),
                        TextSpan(
                            text:
                                "${widget.match.misc.coopertition}\n",
                            style: const TextStyle(
                                height: 1.6,
                                overflow: TextOverflow.ellipsis)),
                        const TextSpan(
                            text: "- TeleOp Missed: ",
                            style: TextStyle(
                                height: 1.6,
                                fontWeight: FontWeight.w700,
                                overflow: TextOverflow.ellipsis)),
                        TextSpan(
                            text:
                                "${widget.match.teleop.missedAmp + widget.match.teleop.missedSpeaker}\n",
                            style: const TextStyle(
                                height: 1.6,
                                overflow: TextOverflow.ellipsis)),
                        const TextSpan(
                            text: "- Driver Rating: ",
                            style: TextStyle(
                                height: 1.6,
                                fontWeight: FontWeight.w700,
                                overflow: TextOverflow.ellipsis)),
                        TextSpan(
                            text:
                                "${widget.match.teleop.driverRating}\n",
                            style: const TextStyle(
                                height: 1.6,
                                overflow: TextOverflow.ellipsis)),
                        const TextSpan(
                            text: "- TeleOp Scored Amped: ",
                            style: TextStyle(
                                height: 1.6,
                                fontWeight: FontWeight.w700,
                                overflow: TextOverflow.ellipsis)),
                        TextSpan(
                            text:
                                "${widget.match.teleop.scoredWhileAmped}\n",
                            style: const TextStyle(
                                height: 1.6,
                                overflow: TextOverflow.ellipsis)),
                      ])),
                    ])),
                form_label_rigid("Insight",
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        fontStyle: FontStyle.italic,
                        overflow: TextOverflow.ellipsis),
                    child: PreferCompactModal.isCompactPreferred(
                            context)
                        ? IconButton.filledTonal(
                            onPressed: () => launchInsightView(),
                            icon: const Icon(Icons.search_rounded))
                        : FilledButton.tonalIcon(
                            onPressed: () => launchInsightView(),
                            icon: const Icon(Icons.search_rounded),
                            label: const Text("View"))),
                form_label_rigid(
                  'Transfer',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      fontStyle: FontStyle.italic,
                      overflow: TextOverflow.ellipsis),
                  child: Expanded(
                    child: Wrap(
                      children: strutAll(<Widget>[
                        if (ShowConsoleModal.isShowingConsole(
                            context))
                          IconButton.filledTonal(
                              icon: const Icon(Icons.developer_board),
                              onPressed: () async =>
                                  await launchConfirmDialog(context,
                                      message: Column(
                                        children: <Widget>[
                                          Text(widget.match.csvData),
                                          const SizedBox(height: 20),
                                          FilledButton.tonalIcon(
                                              onPressed: () async =>
                                                  await Clipboard.setData(
                                                      ClipboardData(
                                                          text: widget
                                                              .match
                                                              .csvData)),
                                              icon: const Icon(Icons
                                                  .copy_all_rounded),
                                              label:
                                                  const Text("COPY"))
                                        ],
                                      ),
                                      onConfirm: () {})),
                        if (PreferCompactModal.isCompactPreferred(
                            context))
                          IconButton.filledTonal(
                            icon: const Icon(
                                CommunityMaterialIcons.duck),
                            onPressed: () => ducSharedDialog(context),
                          )
                        else
                          FilledButton.icon(
                              onPressed: () async =>
                                  ducSharedDialog(context),
                              icon: const Icon(
                                  CommunityMaterialIcons.duck),
                              label: const Text(
                                  "DUC Share")), // duc stands for Dynamic User Capture
                        if (PreferCompactModal.isCompactPreferred(
                            context))
                          IconButton.filledTonal(
                            icon: const Icon(Icons.qr_code_rounded),
                            onPressed: () => qrSharedDialog(context),
                          )
                        else
                          FilledButton.icon(
                              onPressed: () =>
                                  qrSharedDialog(context),
                              icon: const Icon(Icons.qr_code_rounded),
                              label: const Text("QR Share")),
                        if (PreferCompactModal.isCompactPreferred(
                            context))
                          IconButton.filledTonal(
                            icon: const Icon(
                                Icons.delete_forever_rounded),
                            onPressed: () async =>
                                await launchAssuredConfirmDialog(
                                    context,
                                    onConfirm: () => widget.onDelete
                                        .call(widget.match.id),
                                    message:
                                        "Are you sure want to delete THIS entry?",
                                    title: "Delete entry"),
                          )
                        else
                          FilledButton.icon(
                              onPressed: () async =>
                                  await launchAssuredConfirmDialog(
                                      context,
                                      onConfirm: () => widget.onDelete
                                          .call(widget.match.id),
                                      message:
                                          "Are you sure want to delete THIS entry?",
                                      title: "Delete entry"),
                              icon: const Icon(
                                  Icons.delete_forever_rounded),
                              label: const Text("Delete")),
                      ], width: 6),
                    ),
                  ),
                  icon: const Icon(Icons.cell_tower_rounded),
                ),
              ]),
        ),
      ),
    );
  }

  void ducSharedDialog(BuildContext context) {
    Widget qr =
        _createPrettyQrDataWidget(data: widget.match.toDucFormat());
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (BuildContext context) {
          return Scaffold(
            appBar: AppBar(
              title: const Row(
                children: <Widget>[
                  Icon(CommunityMaterialIcons.duck),
                  Text("DUC Share"),
                ],
              ),
            ),
            body: Stack(children: <Widget>[
              Icon(CommunityMaterialIcons.duck,
                  size: 248, color: Colors.black..withOpacity(0.4)),
              SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(
                    parent: BouncingScrollPhysics()),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Center(
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.amber,
                            borderRadius: BorderRadius.circular(8)),
                        child: const Padding(
                          padding: EdgeInsets.all(6),
                          child: Text.rich(
                              TextSpan(children: <InlineSpan>[
                            WidgetSpan(
                                child: Icon(
                                    CommunityMaterialIcons.duck,
                                    color: Colors.black)),
                            TextSpan(
                                text: " Show to a Scouting Leader",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18))
                          ], style: TextStyle(color: Colors.black))),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Center(
                      child: GestureDetector(
                        onTap: () async => launchConfirmDialog(
                            context,
                            message: SizedBox(
                                width: 512, height: 512, child: qr),
                            onConfirm: () {},
                            title: "DUC Share",
                            icon: const Icon(Icons.qr_code_rounded)),
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: Colors.black),
                          child: Padding(
                            padding: const EdgeInsets.all(24),
                            child: SizedBox(
                              width: 512,
                              height: 512,
                              child: qr,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    FilledButton.tonalIcon(
                        onPressed: () async =>
                            await Clipboard.setData(ClipboardData(
                                text: widget.match.toDucFormat())),
                        icon: const Icon(Icons.copy_rounded),
                        label: const Text("Copy")),
                    const SizedBox(
                        height: 40), // idk why, just leave it
                  ],
                ),
              )
            ]),
          );
        },
      ),
    );
  }

  void qrSharedDialog(BuildContext context) {
    Widget qr = _createPrettyQrDataWidget(data: widget.match.csvData);
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (BuildContext context) {
          return Scaffold(
            appBar: AppBar(
              title: const Text("QR Share (Non-DUC)"),
            ),
            body: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(
                  parent: BouncingScrollPhysics()),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Center(
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.amber,
                          borderRadius: BorderRadius.circular(8)),
                      child: const Padding(
                        padding: EdgeInsets.all(6),
                        child:
                            Text.rich(TextSpan(children: <InlineSpan>[
                          WidgetSpan(
                              child: Icon(
                                  CommunityMaterialIcons
                                      .shield_account,
                                  color: Colors.black)),
                          TextSpan(
                              text: " Show to a Scouting Leader",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18))
                        ], style: TextStyle(color: Colors.black))),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: GestureDetector(
                      onTap: () async => launchConfirmDialog(context,
                          message: SizedBox(
                              width: 512, height: 512, child: qr),
                          onConfirm: () {},
                          title: "QR (Non-DUC)",
                          icon: const Icon(Icons.qr_code_rounded)),
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.black),
                        child: Padding(
                          padding: const EdgeInsets.all(24),
                          child: SizedBox(
                            width: 512,
                            height: 512,
                            child: qr,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  FilledButton.tonalIcon(
                      onPressed: () async => await Clipboard.setData(
                          ClipboardData(text: widget.match.csvData)),
                      icon: const Icon(Icons.copy_rounded),
                      label: const Text("Copy")),
                  const SizedBox(
                      height: 40), // idk why, just leave it
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

Widget _createPrettyQrDataWidget({
  required String data,
  bool includeImage = true,
}) {
  const PrettyQrDecoration decorationWithImage = PrettyQrDecoration(
    shape: PrettyQrRoundedSymbol(
        color: Colors.white, borderRadius: BorderRadius.zero),
  );
  const PrettyQrDecoration decorationWithoutImage =
      PrettyQrDecoration(
    shape: PrettyQrRoundedSymbol(color: Colors.white),
  );
  return PrettyQrView.data(
    data: data,
    errorCorrectLevel: QrErrorCorrectLevel.M,
    decoration:
        includeImage ? decorationWithImage : decorationWithoutImage,
  );
}
