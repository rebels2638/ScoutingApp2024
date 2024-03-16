import 'package:community_material_icon/community_material_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:scouting_app_2024/blobs/blobs.dart';
import 'package:scouting_app_2024/blobs/form_blob.dart';
import 'package:scouting_app_2024/extern/string.dart';
import 'package:scouting_app_2024/parts/bits/prefer_canonical.dart';
import 'package:scouting_app_2024/parts/bits/prefer_compact.dart';
import 'package:scouting_app_2024/parts/bits/show_console.dart';
import 'package:scouting_app_2024/parts/views/shared_dialogs.dart';
import 'package:scouting_app_2024/shared.dart';
import 'package:scouting_app_2024/user/models/shared.dart';
import 'package:scouting_app_2024/user/models/team_model.dart';

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
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8, bottom: 4),
      child: Card(
        child: form_sec_rigid(
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
}
