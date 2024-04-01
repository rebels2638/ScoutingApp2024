import 'dart:convert';

import 'package:community_material_icon/community_material_icon.dart';
import 'package:file_saver/file_saver.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:scouting_app_2024/blobs/blobs.dart';
import 'package:scouting_app_2024/blobs/form_blob.dart';
import 'package:scouting_app_2024/blobs/special_button.dart';
import 'package:scouting_app_2024/debug.dart';
import 'package:scouting_app_2024/extern/dynamic_user_capture.dart';
import 'package:scouting_app_2024/extern/string.dart';
import 'package:scouting_app_2024/parts/bits/duc_bit.dart';
import 'package:scouting_app_2024/parts/bits/prefer_canonical.dart';
import 'package:scouting_app_2024/parts/bits/prefer_compact.dart';
import 'package:scouting_app_2024/parts/bits/show_console.dart';
import 'package:scouting_app_2024/parts/views/duck/duck_view_navigator.dart';
import 'package:scouting_app_2024/parts/views/shared_dialogs.dart';
import 'package:theme_provider/theme_provider.dart';
import 'dart:io';
import 'qr_scan_widget.dart';
import 'package:scouting_app_2024/shared.dart';
import 'package:scouting_app_2024/user/duc_telemetry.dart';
import 'package:scouting_app_2024/user/match_utils.dart';
import 'package:scouting_app_2024/user/models/shared.dart';
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

// mind the fucking weird ass naming scheme
enum MatchSortMethod {
  byTeam_Number,
  byTeleOp_Speaker_Scored,
  byTeleOp_Amp_Scored,
  byAuto_Speaker_Scored,
  byAuto_Amp_Scored,
}

class DataHostingView extends StatefulWidget
    implements DuckNavigatorViewTrait {
  const DataHostingView({super.key});

  @override
  State<DataHostingView> createState() => _DataHostingViewState();

  @override
  Widget get icon => const Icon(Icons.folder_off_rounded);

  @override
  String get label => "Legacy DUC";

  @override
  Widget get view => this;
}

class _DataHostingViewState extends State<DataHostingView> {
  late Map<int, List<HollisticMatchScoutingData>> teamsData;
  late bool _searched;
  late MatchSortMethod sortMethod;

  @override
  void initState() {
    super.initState();
    sortMethod = MatchSortMethod.byTeam_Number;
    teamsData =
        MatchUtils.filterByTeam(DucTelemetry().allHollisticEntries);
    _searched = false;
  }

  @override
  Widget build(BuildContext context) {
    switch (sortMethod) {
      case MatchSortMethod.byTeam_Number:
        teamsData.keys.toList().sort();
        break;
      case MatchSortMethod.byAuto_Amp_Scored:
        Debug().info("sorting duc by {AUTO AMP SCORED}");
        teamsData.keys.toList().sort((int a, int b) {
          double aScore = 0.0;
          double bScore = 0.0;
          for (HollisticMatchScoutingData d in teamsData[a]!) {
            aScore += d.auto.scoredAmp;
          }
          for (HollisticMatchScoutingData d in teamsData[b]!) {
            bScore += d.auto.scoredAmp;
          }
          return aScore.compareTo(bScore);
        });
        break;
      case MatchSortMethod.byAuto_Speaker_Scored:
        Debug().info("sorting duc by {AUTO SPEAKER SCORED}");
        teamsData.keys.toList().sort((int a, int b) {
          double aScore = 0.0;
          double bScore = 0.0;
          for (HollisticMatchScoutingData d in teamsData[a]!) {
            aScore += d.auto.scoredSpeaker;
          }
          for (HollisticMatchScoutingData d in teamsData[b]!) {
            bScore += d.auto.scoredSpeaker;
          }
          return aScore.compareTo(bScore);
        });
        break;
      case MatchSortMethod.byTeleOp_Amp_Scored:
        Debug().info("sorting duc by {TELEOP AMP SCORED}");
        teamsData.keys.toList().sort((int a, int b) {
          double aScore = 0.0;
          double bScore = 0.0;
          for (HollisticMatchScoutingData d in teamsData[a]!) {
            aScore += d.teleop.scoredAmp;
          }
          for (HollisticMatchScoutingData d in teamsData[b]!) {
            bScore += d.teleop.scoredAmp;
          }
          return aScore.compareTo(bScore);
        });
        break;
      case MatchSortMethod.byTeleOp_Speaker_Scored:
        Debug().info("sorting duc by {TELEOP SPEAKER SCORED}");
        teamsData.keys.toList().sort((int a, int b) {
          double aScore = 0.0;
          double bScore = 0.0;
          for (HollisticMatchScoutingData d in teamsData[a]!) {
            aScore += d.teleop.scoredSpeaker;
          }
          for (HollisticMatchScoutingData d in teamsData[b]!) {
            bScore += d.teleop.scoredSpeaker;
          }
          return aScore.compareTo(bScore);
        });
        break;
    }
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(
          parent: BouncingScrollPhysics()),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const SizedBox(height: 6),
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
                        text: "Total Teams: ",
                        style:
                            TextStyle(fontWeight: FontWeight.bold)),
                    TextSpan(
                      text: teamsData.keys.length.toString(),
                    ),
                    const TextSpan(
                        text: "\nTotal Matches: ",
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
            Wrap(spacing: 8, runSpacing: 8, children: <Widget>[
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
                                      body: const QrScanner()))),
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
                    onPressed: () async => await showDialog(
                        context: context,
                        builder: (BuildContext _) =>
                            _PasteDucData(context)),
                    icon: const Icon(Icons.paste_rounded),
                    label: const Text("Paste DUC")),
              if (!_searched)
                FilledButton.tonal(
                  onPressed: () async => await Provider.of<
                          DucBaseBit>(context, listen: false)
                      .save()
                      .then((_) =>
                          Debug().info("[DUC] Saved! Mrs. Wang!!!")),
                  child: const Icon(Icons.save_rounded),
                ),
              if (!_searched)
                FilledButton.tonal(
                  onPressed: () async => await launchAssuredConfirmDialog(
                      context,
                      message:
                          "Are you sure you want to delete all DUC data? This is irreversible!",
                      title: "Delete DUC", onConfirm: () {
                    Provider.of<DucBaseBit>(context, listen: false)
                        .removeAll()
                        .then((_) => Debug()
                            .warn("[DUC] Removed all DUC data..."));
                  }),
                  child: const Icon(Icons.delete_forever_rounded),
                ),
              if (!_searched)
                FilledButton.tonal(
                    onPressed: () {
                      Map<int, List<HollisticMatchScoutingData>>
                          teams = teamsData;
                      StringBuffer csvBuffer = StringBuffer(
                          "Team Number,Matches Recorded,Auto % Movement Points,Auto Avg Scored in Speaker,Auto Avg Scored in Amp,Tele-Op Avg Scored in Speaker,Tele-Op Avg Scored in Amp,Tele-Op Avg Notes Scored,Tele-Op Goes Under Stage,Tele-Op Lobs,Endgame Can Climb,Endgame Harmony Attempt Success Rate,Endgame % of Games Scored Trap,Misc Win Likelihoods\n");
                      teams.forEach((int teamNumber,
                          List<HollisticMatchScoutingData> data) {
                        // AUTO CALCULATIONS
                        double autoPercentGetMovementPoints = 0.0;
                        double autoAvgScoredSpeaker = 0.0;
                        double autoAvgScoredInAmp = 0.0;
                        // TELEOP CALCULATIONS
                        double teleopAvgScoredInSpeaker = 0.0;
                        double teleopAvgScoredInAmp = 0.0;
                        double teleopAvgNotesScored = 0.0;
                        bool teleopGoesUnderStage = false;
                        bool teleopLobs = false;
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
                          autoAvgScoredSpeaker +=
                              d.auto.scoredSpeaker;
                          autoAvgScoredInAmp += d.auto.scoredAmp;

                          teleopAvgScoredInSpeaker +=
                              d.teleop.scoredSpeaker;
                          teleopAvgScoredInAmp += d.teleop.scoredAmp;
                          teleopAvgNotesScored += d.teleop.scoredAmp +
                              d.teleop.scoredSpeaker;
                          teleopGoesUnderStage = d.teleop.underStage;
                          teleopLobs = d.teleop.lobs;
                          endgameCanClimb = d.endgame.endState ==
                              EndStatus.on_chain;
                          endgameHarmonyAttemptSuccessRate +=
                              d.endgame.harmonyAttempted &&
                                      d.endgame.harmony == Harmony.yes
                                  ? 1
                                  : 0;
                          endgamePercentOfGamesScoredTrap +=
                              d.endgame.trapScored == TrapScored.yes
                                  ? 1
                                  : 0;
                          miscWinLikelihoods +=
                              d.endgame.matchResult == MatchResult.win
                                  ? 1
                                  : 0;
                        }
                        autoPercentGetMovementPoints /= data.length;
                        autoAvgScoredSpeaker /= data.length;
                        autoAvgScoredInAmp /= data.length;
                        teleopAvgScoredInSpeaker /= data.length;
                        teleopAvgScoredInAmp /= data.length;
                        teleopAvgNotesScored /= data.length;
                        endgameHarmonyAttemptSuccessRate /=
                            data.length;
                        endgamePercentOfGamesScoredTrap /=
                            data.length;
                        miscWinLikelihoods /= data.length;
                        csvBuffer.write(
                            "$teamNumber,${data.length},${autoPercentGetMovementPoints.toStringAsFixed(2)},${autoAvgScoredSpeaker.toStringAsFixed(2)},${autoAvgScoredInAmp.toStringAsFixed(2)},${teleopAvgScoredInSpeaker.toStringAsFixed(2)},${teleopAvgScoredInAmp.toStringAsFixed(2)},${teleopAvgNotesScored.toStringAsFixed(2)},${teleopGoesUnderStage ? "Yes" : "No"},${teleopLobs ? "Yes" : "No"},${endgameCanClimb ? "Yes" : "No"},${(endgameHarmonyAttemptSuccessRate * 100).toStringAsFixed(2)}%,${(endgamePercentOfGamesScoredTrap * 100).toStringAsFixed(2)}%,${(miscWinLikelihoods * 100).toStringAsFixed(2)}%\n");
                      });
                      Navigator.of(context).push(MaterialPageRoute<
                              Widget>(
                          builder: (BuildContext context) => Scaffold(
                              body: SingleChildScrollView(
                                  child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 8, right: 8, top: 14),
                                child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.center,
                                    children: <Widget>[
                                      SpecialButton.premade2(
                                          label:
                                              "Copy as CSV to Clipboard",
                                          icon: const Icon(
                                              Icons.copy_all_rounded),
                                          onPressed: () => Clipboard
                                              .setData(ClipboardData(
                                                  text: csvBuffer
                                                      .toString()))),
                                      ExpansionTile(
                                          childrenPadding:
                                              const EdgeInsets.all(
                                                  12),
                                          controlAffinity:
                                              ListTileControlAffinity
                                                  .leading,
                                          title: const Text(
                                              "CSV Content"),
                                          children: <Widget>[
                                            Text(
                                              csvBuffer.toString(),
                                              style: const TextStyle(
                                                  fontFamily:
                                                      "Monospace",
                                                  fontSize: 12),
                                            ),
                                          ]),
                                      const SizedBox(height: 20),
                                      SpecialButton.premade5(
                                          label: "Export CSV as file",
                                          icon: const Icon(Icons
                                              .file_copy_rounded),
                                          onPressed: () async {
                                            if (!kIsWeb) {
                                              if (Platform.isIOS ||
                                                  Platform
                                                      .isAndroid) {
                                                bool status =
                                                    await Permission
                                                        .storage
                                                        .isGranted;

                                                if (!status) {
                                                  await Permission
                                                      .storage
                                                      .request();
                                                }
                                              }
                                            }
                                            await FileSaver.instance.saveAs(
                                                file: File(
                                                    "Argus_DUC_Dump.csv"),
                                                name:
                                                    "Argus_DUC_Dump",
                                                ext: "csv",
                                                mimeType:
                                                    MimeType.text,
                                                bytes: utf8.encode(
                                                    csvBuffer
                                                        .toString()));
                                          })
                                    ]),
                              )),
                              appBar: AppBar(
                                  title: const Text(
                                      "Export all DUCs")))));
                    },
                    child: const Icon(Icons.upload_file_rounded)),
              if (!_searched)
                FilledButton.tonal(
                  onPressed: () {
                    teamsData = MatchUtils.filterByTeam(
                        DucTelemetry().allHollisticEntries);
                    setState(() {});
                  },
                  child: const Icon(Icons.refresh_rounded),
                ),
              if (_searched)
                FilledButton.tonal(
                  onPressed: () {
                    teamsData = MatchUtils.filterByTeam(
                        DucTelemetry().allHollisticEntries);
                    setState(() => _searched = false);
                  },
                  child: const Icon(Icons.arrow_back_rounded),
                ),
              FilledButton.tonal(
                onPressed: () async => await showDialog(
                    context: context,
                    builder: (BuildContext context) =>
                        _SearchTeamsDialog(onSubmit: (String id) {
                          if (_searched) {
                            // just to make sure we dont rerun the checks
                            teamsData = MatchUtils.filterByTeam(
                                DucTelemetry().allHollisticEntries);
                          }
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
                child: const Icon(Icons.search_rounded),
              )
            ]),
            if (!_searched)
              DropdownButton<MatchSortMethod>(
                  elevation: 12,
                  icon: const Icon(Icons.sort_rounded),
                  value: sortMethod,
                  underline: Container(
                    height: 2,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(2),
                        color: ThemeProvider.themeOf(context)
                            .data
                            .colorScheme
                            .primary),
                  ),
                  items: MatchSortMethod.values
                      .map<DropdownMenuItem<MatchSortMethod>>(
                          (MatchSortMethod e) => DropdownMenuItem<
                                  MatchSortMethod>(
                              value: e,
                              child: Text(
                                  "Sort by ${e.name.split("by")[1].replaceAll("_", " ")}")))
                      .toList(),
                  onChanged: (MatchSortMethod? e) =>
                      setState(() => sortMethod = e!)),
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
        // TELEOP CALCULATIONS
        double teleopAvgScoredInSpeaker = 0.0;
        double teleopAvgScoredInAmp = 0.0;
        double teleopAvgNotesScored = 0.0;
        bool teleopGoesUnderStage = false;
        bool teleopLobs = false;
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

          teleopAvgScoredInSpeaker += d.teleop.scoredSpeaker;
          teleopAvgScoredInAmp += d.teleop.scoredAmp;
          teleopAvgNotesScored +=
              d.teleop.scoredAmp + d.teleop.scoredSpeaker;
          teleopGoesUnderStage = d.teleop.underStage;
          teleopLobs = d.teleop.lobs;
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
        teleopAvgScoredInSpeaker /= data.length;
        teleopAvgScoredInAmp /= data.length;
        teleopAvgNotesScored /= data.length;
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
              child: form_sec_rigid(
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
                                            fontWeight:
                                                FontWeight.bold)),
                                    TextSpan(
                                        text: data.length.toString()),
                                    const TextSpan(
                                        text: "\nWinrate: ",
                                        style: TextStyle(
                                            fontWeight:
                                                FontWeight.bold)),
                                    TextSpan(
                                        text:
                                            "${(miscWinLikelihoods * 100).toStringAsFixed(2)}%",
                                        style: TextStyle(
                                            color: heat(
                                                miscWinLikelihoods),
                                            backgroundColor:
                                                Colors.black)),
                                  ]),
                                  style:
                                      const TextStyle(fontSize: 16)),
                            ],
                          ),
                          const SizedBox(height: 12),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                          runSpacing: 8,
                          spacing: 8,
                          children: <Widget>[
                            FilledButton.tonalIcon(
                                onPressed:
                                    () => Navigator.of(context).push(
                                            MaterialPageRoute<Widget>(
                                          builder: (BuildContext
                                                  context) =>
                                              Scaffold(
                                            resizeToAvoidBottomInset:
                                                false,
                                            appBar: AppBar(
                                                title: Row(
                                              children: <Widget>[
                                                const Icon(Icons
                                                    .auto_graph_rounded),
                                                const SizedBox(
                                                    width: 8),
                                                Text(
                                                    "Stats for team $teamNumber"),
                                              ],
                                            )),
                                            body:
                                                SingleChildScrollView(
                                                    physics:
                                                        const AlwaysScrollableScrollPhysics(
                                                            parent:
                                                                BouncingScrollPhysics()),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets
                                                              .all(
                                                              16),
                                                      child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          children: <Widget>[
                                                            Card(
                                                              child:
                                                                  form_sec_rigid(
                                                                title: const Text(
                                                                    "Auto",
                                                                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
                                                                headerIcon:
                                                                    const Icon(Icons.auto_awesome_rounded),
                                                                child:
                                                                    Padding(
                                                                  padding:
                                                                      const EdgeInsets.all(8.0),
                                                                  child:
                                                                      Row(
                                                                    children: <Widget>[
                                                                      Text.rich(
                                                                        TextSpan(
                                                                          children: <InlineSpan>[
                                                                            const TextSpan(
                                                                              text: "% Movement Points: ",
                                                                              style: TextStyle(fontWeight: FontWeight.bold),
                                                                            ),
                                                                            TextSpan(text: "${(autoPercentGetMovementPoints * 100).toStringAsFixed(2)}%", style: TextStyle(color: heat(autoPercentGetMovementPoints), backgroundColor: Colors.black)),
                                                                            const TextSpan(text: "\nAvg Scored in Speaker: ", style: TextStyle(fontWeight: FontWeight.bold)),
                                                                            TextSpan(
                                                                              text: autoAvgScoredSpeaker.toStringAsFixed(2),
                                                                            ),
                                                                            const TextSpan(
                                                                              text: "\nAvg Scored in Amp: ",
                                                                              style: TextStyle(fontWeight: FontWeight.bold),
                                                                            ),
                                                                            TextSpan(
                                                                              text: autoAvgScoredInAmp.toStringAsFixed(2),
                                                                            ),
                                                                          ],
                                                                          style: const TextStyle(fontSize: 18),
                                                                        ),
                                                                      ),
                                                                      const Spacer(), // this is a scuffed solution
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                                height:
                                                                    16),
                                                            Card(
                                                              child:
                                                                  form_sec_rigid(
                                                                title: const Text(
                                                                    "Tele-Op",
                                                                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
                                                                headerIcon:
                                                                    const Icon(Icons.group_rounded),
                                                                child:
                                                                    Padding(
                                                                  padding:
                                                                      const EdgeInsets.all(8.0),
                                                                  child:
                                                                      Row(
                                                                    children: <Widget>[
                                                                      Text.rich(
                                                                        TextSpan(children: <InlineSpan>[
                                                                          const TextSpan(
                                                                            text: "Avg Scored in Speaker: ",
                                                                            style: TextStyle(fontWeight: FontWeight.bold),
                                                                          ),
                                                                          TextSpan(
                                                                            text: teleopAvgScoredInSpeaker.toStringAsFixed(2),
                                                                          ),
                                                                          const TextSpan(
                                                                            text: "\nAvg Scored in Amp: ",
                                                                            style: TextStyle(fontWeight: FontWeight.bold),
                                                                          ),
                                                                          TextSpan(
                                                                            text: teleopAvgScoredInAmp.toStringAsFixed(2),
                                                                          ),
                                                                          const TextSpan(
                                                                            text: "\nAvg Notes Scored: ",
                                                                            style: TextStyle(fontWeight: FontWeight.bold),
                                                                          ),
                                                                          TextSpan(
                                                                            text: teleopAvgNotesScored.toStringAsFixed(2),
                                                                          ),
                                                                          const TextSpan(
                                                                            text: "\nGoes Under Stage: ",
                                                                            style: TextStyle(fontWeight: FontWeight.bold),
                                                                          ),
                                                                          TextSpan(
                                                                            text: teleopGoesUnderStage ? "Yes" : "No",
                                                                          ),
                                                                          TextSpan(
                                                                            text: teleopLobs ? "Yes" : "No",
                                                                          ),
                                                                        ], style: const TextStyle(fontSize: 18)),
                                                                      ),
                                                                      const Spacer(),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                                height:
                                                                    16),
                                                            Card(
                                                              child:
                                                                  form_sec_rigid(
                                                                title: const Text(
                                                                    "End Game",
                                                                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
                                                                headerIcon:
                                                                    const Icon(Icons.commit_rounded),
                                                                child:
                                                                    Padding(
                                                                  padding:
                                                                      const EdgeInsets.all(8.0),
                                                                  child:
                                                                      Row(
                                                                    children: <Widget>[
                                                                      Text.rich(
                                                                        TextSpan(children: <InlineSpan>[
                                                                          const TextSpan(
                                                                            text: "Can Climb: ",
                                                                            style: TextStyle(fontWeight: FontWeight.bold),
                                                                          ),
                                                                          TextSpan(
                                                                            text: endgameCanClimb ? "Yes" : "No",
                                                                          ),
                                                                          const TextSpan(
                                                                            text: "\nHarmony Attempt Success Rate: ",
                                                                            style: TextStyle(fontWeight: FontWeight.bold),
                                                                          ),
                                                                          TextSpan(
                                                                            text: "${(endgameHarmonyAttemptSuccessRate * 100).toStringAsFixed(2)}% ",
                                                                            style: TextStyle(color: heat(endgameHarmonyAttemptSuccessRate), backgroundColor: Colors.black),
                                                                          ),
                                                                          const TextSpan(
                                                                            text: "\n% of Games Scored Trap: ",
                                                                            style: TextStyle(fontWeight: FontWeight.bold),
                                                                          ),
                                                                          TextSpan(
                                                                            text: "${(endgamePercentOfGamesScoredTrap * 100).toStringAsFixed(2)}% ",
                                                                            style: TextStyle(color: heat(endgamePercentOfGamesScoredTrap), backgroundColor: Colors.black),
                                                                          ),
                                                                        ], style: const TextStyle(fontSize: 18)),
                                                                      ),
                                                                      const Spacer(),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                                height:
                                                                    16),
                                                            Card(
                                                              child:
                                                                  form_sec_rigid(
                                                                title: const Text(
                                                                    "Misc",
                                                                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
                                                                headerIcon:
                                                                    const Icon(Icons.miscellaneous_services_rounded),
                                                                child:
                                                                    Padding(
                                                                  padding:
                                                                      const EdgeInsets.all(8.0),
                                                                  child:
                                                                      Row(
                                                                    children: <Widget>[
                                                                      Text.rich(
                                                                        TextSpan(children: <InlineSpan>[
                                                                          const TextSpan(
                                                                            text: "Win Likelihood: ",
                                                                            style: TextStyle(fontWeight: FontWeight.bold),
                                                                          ),
                                                                          TextSpan(
                                                                            text: "${(miscWinLikelihoods * 100).toStringAsFixed(2)}%",
                                                                            style: TextStyle(color: heat(miscWinLikelihoods), backgroundColor: Colors.black),
                                                                          ),
                                                                        ], style: const TextStyle(fontSize: 18)),
                                                                      ),
                                                                      const Spacer(),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                                height:
                                                                    40),
                                                          ]),
                                                    )),
                                          ),
                                        )),
                                icon: const Icon(
                                    Icons.auto_graph_rounded),
                                label: const Text("View Stats")),
                            const SizedBox(height: 8),
                            FilledButton.tonalIcon(
                                onPressed: () => Navigator.of(context)
                                    .push(MaterialPageRoute<Widget>(
                                        builder: (BuildContext
                                                context) =>
                                            Scaffold(
                                                body:
                                                    PreferCompactModal
                                                            .isCompactPreferred(
                                                                context)
                                                        ? Builder(
                                                            // this could be optimized further with a futurebuilder
                                                            builder:
                                                                (BuildContext
                                                                    context) {
                                                              List<Widget>
                                                                  widgets =
                                                                  <Widget>[];
                                                              for (HollisticMatchScoutingData match
                                                                  in data) {
                                                                Debug()
                                                                    .info("DUC_TEAM_MATCH_HISTORY: Adding match ${match.id}");
                                                                widgets
                                                                    .add(DucMatchTile(
                                                                  match:
                                                                      match,
                                                                  onDelete:
                                                                      (String id) {
                                                                    Provider.of<DucBaseBit>(context, listen: false).removeID(id);
                                                                    Provider.of<DucBaseBit>(context, listen: false).save();
                                                                  },
                                                                ));
                                                              }
                                                              return form_grid_2(
                                                                crossAxisCount:
                                                                    2,
                                                                mainAxisSpacing:
                                                                    14,
                                                                crossAxisSpacing:
                                                                    14,
                                                                children:
                                                                    widgets,
                                                              );
                                                            },
                                                          )
                                                        : ListView
                                                            .builder(
                                                            physics: const AlwaysScrollableScrollPhysics(
                                                                parent:
                                                                    BouncingScrollPhysics(decelerationRate: ScrollDecelerationRate.normal)),
                                                            padding: const EdgeInsets
                                                                .only(
                                                                bottom:
                                                                    40),
                                                            itemCount:
                                                                data.length,
                                                            itemBuilder:
                                                                (BuildContext context,
                                                                    int index) {
                                                              return DucMatchTile(
                                                                match:
                                                                    data[index],
                                                                onDelete:
                                                                    (String id) {
                                                                  Provider.of<DucBaseBit>(context, listen: false).removeID(id);
                                                                  Provider.of<DucBaseBit>(context, listen: false).save();
                                                                },
                                                              );
                                                            },
                                                          ),
                                                appBar: AppBar(
                                                    title: Row(
                                                        children: <Widget>[
                                                      const Icon(Icons
                                                          .history_rounded),
                                                      const SizedBox(
                                                          width: 8),
                                                      Text(
                                                          "Match History for Team $teamNumber"),
                                                    ]))))),
                                icon:
                                    const Icon(Icons.search_rounded),
                                label: const Text("View Matches")),
                            const SizedBox(height: 8),
                            FilledButton.tonalIcon(
                                onPressed: () async => await Clipboard
                                        .setData(
                                            ClipboardData(text: """
                                    # Team $teamNumber
                                    ## Auto
                                    > **% Movement Points** ${(autoPercentGetMovementPoints * 100).toStringAsFixed(2)}%
                                    > **Avg Scored in Speaker** ${autoAvgScoredSpeaker.toStringAsFixed(2)}
                                    > **Avg Scored in Amp** ${autoAvgScoredInAmp.toStringAsFixed(2)}
                                    ## Tele-Op
                                    > **Avg Scored in Speaker** ${teleopAvgScoredInSpeaker.toStringAsFixed(2)}
                                    > **Avg Scored in AMP** ${teleopAvgScoredInAmp.toStringAsFixed(2)}
                                    > **Avg Notes Scored** ${teleopAvgNotesScored.toStringAsFixed(2)}
                                    > **Goes Under Stage** ${teleopGoesUnderStage ? "Yes" : "No"}
                                    > **Lobs** ${teleopLobs ? "Yes" : "No"}
                                    ## End Game
                                    > **Can Climb** ${endgameCanClimb ? "Yes" : "No"}
                                    > **Harmony Attempt Success Rate** ${(endgameHarmonyAttemptSuccessRate * 100).toStringAsFixed(2)}%
                                    > **% of Games Scored Trap** ${(endgamePercentOfGamesScoredTrap * 100).toStringAsFixed(2)}%
                                    ## Misc
                                    > **Win Likelihood** ${(miscWinLikelihoods * 100).toStringAsFixed(2)}%

                                    `Timestamp: ${DateFormat("yyyy-MM-dd HH:mm:ss").format(DateTime.now())} UTC`
                                    """))
                                    .then((_) => ScaffoldMessenger.of(
                                            context)
                                        .showSnackBar(const SnackBar(
                                            content: Text(
                                                "Copied to Clipboard! Now send it on Discord!")))),
                                icon:
                                    const Icon(Icons.discord_rounded),
                                label: const Text("Discord Copy")),
                            FilledButton.tonalIcon(
                                onPressed: () async => await launchAssuredConfirmDialog(
                                    context,
                                    message:
                                        "Are you sure you want to delete all DUC data for team $teamNumber? This is irreversible!",
                                    title: "Delete Team $teamNumber",
                                    onConfirm: () async =>
                                        await Provider.of<DucBaseBit>(
                                                context,
                                                listen: false)
                                            .removeWhere(
                                                (HollisticMatchScoutingData d) =>
                                                    d.preliminary
                                                        .teamNumber ==
                                                    teamNumber)
                                            .then((_) =>
                                                Debug().info("Removed all DUC data for team $teamNumber..."))),
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
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8, top: 8),
      child: Card(
        child: form_sec_rigid(
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
                      ])),
                    ])),
                form_label_rigid("Insight",
                    icon: const Icon(Icons.insights_rounded),
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        fontStyle: FontStyle.italic,
                        overflow: TextOverflow.ellipsis),
                    child: Expanded(
                      child: Row(
                        children: <Widget>[
                          PreferCompactModal.isCompactPreferred(context)
                              ? IconButton.filledTonal(
                                  onPressed: () =>
                                      SharedDialogsMatches
                                          .launchInsightView(
                                              context, widget.match),
                                  icon: const Icon(
                                      Icons.search_rounded))
                              : FilledButton.tonalIcon(
                                  onPressed: () =>
                                      SharedDialogsMatches
                                          .launchInsightView(
                                              context, widget.match),
                                  icon:
                                      const Icon(Icons.search_rounded),
                                  label: const Text("View")),
                        ],
                      ),
                    )),
                const SizedBox(height: 8),
                form_label_rigid(
                  'Transfer',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      fontStyle: FontStyle.italic,
                      overflow: TextOverflow.ellipsis),
                  icon: const Icon(Icons.cell_tower_rounded),
                  child: Expanded(
                    child: Wrap(
                      runSpacing: 8,
                      spacing: 8,
                      children: <Widget>[
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
                            onPressed: () =>
                                SharedDialogsMatches.ducSharedDialog(
                                    context, widget.match),
                          )
                        else
                          FilledButton.icon(
                              onPressed: () async =>
                                  SharedDialogsMatches
                                      .ducSharedDialog(
                                          context, widget.match),
                              icon: const Icon(
                                  CommunityMaterialIcons.duck),
                              label: const Text(
                                  "DUC Share")), // duc stands for Dynamic User Capture
                        if (PreferCompactModal.isCompactPreferred(
                            context))
                          IconButton.filledTonal(
                            icon: const Icon(Icons.qr_code_rounded),
                            onPressed: () =>
                                SharedDialogsMatches.qrSharedDialog(
                                    context, widget.match),
                          )
                        else
                          FilledButton.icon(
                              onPressed: () =>
                                  SharedDialogsMatches.qrSharedDialog(
                                      context, widget.match),
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
                      ],
                    ),
                  ),
                ),
                if (widget.match.comments.isNotEmpty)
                  const SizedBox(height: 8),
                if (widget.match.comments.isNotEmpty)
                  form_label_rigid(
                    "Comments",
                    icon: const Icon(Icons.comment_rounded),
                    child: Expanded(
                      child: Row(
                        children: <Widget>[
                          PreferCompactModal.isCompactPreferred(context)
                              ? IconButton.filledTonal(
                                  onPressed: () async =>
                                      await launchInformDialog(
                                          context,
                                          message: Text(widget.match
                                              .comments.comment!),
                                          title:
                                              "Comments (${widget.match.comments.comment!.length}/$COMMENTS_MAX_CHARS)",
                                          icon: const Icon(
                                              Icons.comment_rounded)),
                                  icon: const Icon(
                                      Icons.comment_rounded))
                              : FilledButton.tonalIcon(
                                  onPressed: () async => await launchInformDialog(
                                      context,
                                      message: Text(
                                          widget.match.comments.comment!),
                                      title: "Comments (${widget.match.comments.comment!.length}/$COMMENTS_MAX_CHARS)",
                                      icon: const Icon(Icons.comment_rounded)),
                                  icon: const Icon(Icons.comment_rounded),
                                  label: const Text("View Comments"))
                        ],
                      ),
                    ),
                  ),
              ]),
        ),
      ),
    );
  }
}
