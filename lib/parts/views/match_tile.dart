import 'package:community_material_icon/community_material_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'package:scouting_app_2024/blobs/blobs.dart';
import 'package:scouting_app_2024/blobs/form_blob.dart';
import 'package:scouting_app_2024/extern/dynamic_user_capture.dart';
import 'package:scouting_app_2024/extern/string.dart';
import 'package:scouting_app_2024/parts/bits/prefer_canonical.dart';
import 'package:scouting_app_2024/parts/bits/prefer_compact.dart';
import 'package:scouting_app_2024/parts/bits/show_console.dart';
import 'package:scouting_app_2024/shared.dart';
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
          context,
          headerIcon: Icon(Icons.flag_circle_rounded,
              size: 40,
              color:
                  PreferCanonicalModal.isCanonicalPreferred(context)
                      ? widget.match.preliminary.alliance.toColor()
                      : null),
          title: Text.rich(TextSpan(
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
