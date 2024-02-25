import 'package:community_material_icon/community_material_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'package:scouting_app_2024/blobs/blobs.dart';
import 'package:scouting_app_2024/blobs/form_blob.dart';
import 'package:scouting_app_2024/blobs/hints_blob.dart';
import 'package:scouting_app_2024/extern/dynamic_user_capture.dart';
import 'package:scouting_app_2024/extern/string.dart';
import 'package:scouting_app_2024/parts/bits/prefer_canonical.dart';
import 'package:scouting_app_2024/parts/bits/prefer_compact.dart';
import 'package:scouting_app_2024/parts/bits/show_console.dart';
import 'package:scouting_app_2024/shared.dart';
import 'package:scouting_app_2024/user/models/shared.dart';
import 'package:scouting_app_2024/user/models/team_model.dart';
import 'package:theme_provider/theme_provider.dart';

class MatchTile extends StatefulWidget {
  final HollisticMatchScoutingData match;
  final void Function(String id) onDelete;

  const MatchTile(
      {super.key, required this.match, required this.onDelete});

  @override
  State<MatchTile> createState() => _MatchTileState();
}

class _MatchTileState extends State<MatchTile> {
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
                      Flexible(
                        child: Text.rich(
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
                                  text: widget
                                      .match
                                      .preliminary
                                      .startingPosition
                                      .name
                                      .formalize),
                            ]),
                            style: const TextStyle(fontSize: 16)),
                      ),
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
                      Flexible(
                        child: Text.rich(
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
                                  text: widget
                                      .match.auto.scoredSpeaker
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
                                  text: widget
                                      .match.auto.notesPickedUp
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
                                  text: widget
                                      .match.auto.notesPickedUp
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
                                  text: widget
                                      .match.auto.missedSpeaker
                                      .toString()),
                            ]),
                            style: const TextStyle(fontSize: 16)),
                      ),
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
                      Flexible(
                        child: Text.rich(
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
                                  text: widget
                                      .match.teleop.piecesScored
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
                                  text: widget
                                      .match.teleop.driverRating
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
                      ),
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
                      Flexible(
                        child: Text.rich(
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
                                  text: widget.match.endgame
                                      .trapScored.name.formalize),
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
                                  text: widget.match.endgame
                                      .matchResult.name.formalize),
                            ]),
                            style: const TextStyle(fontSize: 16)),
                      ),
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
                      Flexible(
                        child: Text.rich(
                            TextSpan(children: <InlineSpan>[
                              TextSpan(
                                  text: "Comments:\n",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                  children: <InlineSpan>[
                                    WidgetSpan(
                                        child: Container(
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: ThemeProvider
                                                            .themeOf(
                                                                context)
                                                        .data
                                                        .iconTheme
                                                        .color!),
                                                borderRadius:
                                                    BorderRadius
                                                        .circular(2)),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets
                                                      .all(2),
                                              child: Text(
                                                  widget
                                                          .match
                                                          .comments
                                                          .comment ??
                                                      "None",
                                                  style:
                                                      const TextStyle(
                                                          fontSize:
                                                              16),
                                                  softWrap: true),
                                            ))),
                                  ]),
                              const TextSpan(
                                  text: "\nID: ",
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
                      ),
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
      padding: const EdgeInsets.only(left: 8.0, right: 8, bottom: 4),
      child: Card(
        child: form_sec_rigid(
          context,
          headerIcon: Icon(Icons.flag_circle_rounded,
              size: 40,
              color:
                  PreferCanonicalModal.isCanonicalPreferred(context)
                      ? widget.match.preliminary.alliance.toColor()
                      : null),
          title: Flexible(
            child: Text.rich(TextSpan(
                text:
                    "${widget.match.preliminary.matchType.name.capitalizeFirst} #${widget.match.preliminary.matchNumber} | Team ${widget.match.preliminary.teamNumber} | ${widget.match.preliminary.alliance.name.capitalizeFirst}\n",
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
          ),
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
                                "${widget.match.preliminary.startingPosition.name.capitalizeFirst}\n",
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
                                "${widget.match.endgame.harmony.name.capitalizeFirst}\n",
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
                                "${widget.match.endgame.trapScored.name.capitalizeFirst}\n",
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
                    icon: const Icon(Icons.insights_rounded),
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        fontStyle: FontStyle.italic,
                        overflow: TextOverflow.ellipsis),
                    child: Expanded(
                      child: Row(
                        children: <Widget>[
                          PreferCompactModal.isCompactPreferred(
                                  context)
                              ? IconButton.filledTonal(
                                  onPressed: () =>
                                      launchInsightView(),
                                  icon: const Icon(
                                      Icons.search_rounded))
                              : FilledButton.tonalIcon(
                                  onPressed: () =>
                                      launchInsightView(),
                                  icon: const Icon(
                                      Icons.search_rounded),
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
                                          Text(
                                              "${widget.match.csvData}\n\n${widget.match.commentsCSVData}",
                                              softWrap: true),
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
                    const SizedBox(height: 20),
                    const InformationalHintsBlob(
                        "Show to a scouting leader",
                        "A scouting leader will be able to help you with collecting data. Data here is encoded in a CSV format"),
                    const SizedBox(height: 20),
                    const Text("Match Data",
                        style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    FilledButton.tonalIcon(
                        onPressed: () async =>
                            await Clipboard.setData(ClipboardData(
                                text: widget.match.toDucFormat())),
                        icon: const Icon(Icons.copy_rounded),
                        label: const Text("Copy")),
                    const SizedBox(height: 8),
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
                              child: qr,
                            ),
                          ),
                        ),
                      ),
                    ),
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
    Widget? commentsQr;
    if (widget.match.comments.isNotEmpty) {
      commentsQr = _createPrettyQrDataWidget(
          data: widget.match.commentsCSVData);
    }
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
                  const SizedBox(height: 20),
                  const InformationalHintsBlob(
                      "Show to a scouting leader",
                      "A scouting leader will be able to help you with collecting data. Data here is encoded in a CSV format"),
                  if (commentsQr != null)
                    const WarningHintsBlob("Comments are separated!",
                        "Due to technical limitations, comments are scanned separately (scroll down)")
                  else
                    const InformationalHintsBlob("No Comments Data",
                        "This match didn't have any comments attached to it."),
                  const SizedBox(height: 20),
                  const Text("Match Data",
                      style: TextStyle(
                          fontSize: 24, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  FilledButton.tonalIcon(
                      onPressed: () async => await Clipboard.setData(
                          ClipboardData(text: widget.match.csvData)),
                      icon: const Icon(Icons.copy_rounded),
                      label: const Text("Copy")),
                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap: () async => launchConfirmDialog(context,
                        message: SizedBox(
                            width: 512, height: 512, child: qr),
                        onConfirm: () {},
                        title: "QR (Non-DUC)",
                        icon: const Icon(Icons.qr_code_rounded)),
                    child: Container(
                      width: 512,
                      height: 512,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.black),
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: qr,
                      ),
                    ),
                  ),
                  if (commentsQr != null) const Divider(),
                  if (commentsQr != null)
                    const Text("Comments Data",
                        style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold)),
                  if (commentsQr != null)
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: TextField(
                        controller: TextEditingController(
                            text: widget.match.comments.comment),
                        readOnly: true,
                        decoration: const InputDecoration(
                          labelText: "Comments View",
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                  if (commentsQr != null)
                    FilledButton.tonalIcon(
                        onPressed: () async =>
                            await Clipboard.setData(ClipboardData(
                                text: widget.match.commentsCSVData)),
                        icon: const Icon(Icons.copy_rounded),
                        label: const Text("Copy")),
                  const SizedBox(height: 8),
                  if (commentsQr != null)
                    GestureDetector(
                      onTap: () async => launchConfirmDialog(context,
                          message: SizedBox(
                              width: 512,
                              height: 512,
                              child: commentsQr),
                          onConfirm: () {},
                          title: "Comments Data (QR)",
                          icon: const Icon(Icons.qr_code_rounded)),
                      child: Container(
                        width: 512,
                        height: 512,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.black),
                        child: Padding(
                          padding: const EdgeInsets.all(24),
                          child: commentsQr,
                        ),
                      ),
                    ),
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
