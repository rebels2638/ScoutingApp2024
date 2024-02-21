import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'package:scouting_app_2024/blobs/blobs.dart';
import 'package:scouting_app_2024/blobs/form_blob.dart';
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

String compressMatchData(String data) {
  return base64.encode(gzip.encode(utf8.encode(data)));
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
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        fontStyle: FontStyle.italic,
                        overflow: TextOverflow.ellipsis),
                    icon: const Icon(Icons.data_exploration_rounded),
                    child: Text.rich(TextSpan(children: <InlineSpan>[
                      const TextSpan(
                          text: "Starting Position: ",
                          style: TextStyle(
                              overflow: TextOverflow.ellipsis,
                              height: 1.6,
                              fontWeight: FontWeight.w700)),
                      TextSpan(
                          text:
                              "${widget.match.preliminary.startingPosition.name.capitalizeFirst}\n",
                          style: const TextStyle(height: 1.6)),
                      const TextSpan(
                          text: "Harmonized: ",
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
                          text: "Trap Scored: ",
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
                    ]))),
                form_label_rigid(
                  'Transfer Options',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      fontStyle: FontStyle.italic,
                      overflow: TextOverflow.ellipsis),
                  child: Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: strutAll(<Widget>[
                        if (ShowConsoleModal.isShowingConsole(
                            context))
                          FilledButton(
                              child:
                                  const Icon(Icons.developer_board),
                              onPressed: () async =>
                                  await launchConfirmDialog(context,
                                      message: Column(
                                        children: <Widget>[
                                          Text(compressMatchData(
                                              widget.match.csvData)),
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
                          FilledButton(
                            child: const Icon(Icons.qr_code_rounded),
                            onPressed: () async =>
                                await launchConfirmDialog(context,
                                    message: SizedBox(
                                      width: Shared.QR_CODE_SIZE,
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color: Colors.black,
                                            borderRadius:
                                                BorderRadius.circular(
                                                    8)),
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.all(
                                                  16),
                                          child: Center(
                                            child: _createPrettyQrDataWidget(
                                                data:
                                                    compressMatchData(
                                                        widget.match
                                                            .csvData)),
                                          ),
                                        ),
                                      ),
                                    ),
                                    title: "QR Share",
                                    onConfirm: () {}),
                          )
                        else
                          FilledButton.icon(
                              onPressed: () async =>
                                  await launchConfirmDialog(context,
                                      message: SizedBox(
                                        width: Shared.QR_CODE_SIZE,
                                        child: Container(
                                          decoration: BoxDecoration(
                                              color: Colors.black,
                                              borderRadius:
                                                  BorderRadius
                                                      .circular(8)),
                                          child: Padding(
                                            padding:
                                                const EdgeInsets.all(
                                                    16),
                                            child: Center(
                                              child: _createPrettyQrDataWidget(
                                                  data: compressMatchData(
                                                      widget.match
                                                          .csvData)),
                                            ),
                                          ),
                                        ),
                                      ),
                                      title: "QR Share",
                                      onConfirm: () {}),
                              icon: const Icon(Icons.qr_code_rounded),
                              label: const Text("QR Share")),
                        if (PreferCompactModal.isCompactPreferred(
                            context))
                          FilledButton(
                            child: const Icon(
                                Icons.delete_forever_rounded),
                            onPressed: () {},
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
