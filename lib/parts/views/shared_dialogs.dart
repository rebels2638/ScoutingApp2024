import 'package:community_material_icon/community_material_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'package:scouting_app_2024/blobs/blobs.dart';
import 'package:scouting_app_2024/blobs/hints_blob.dart';
import 'package:scouting_app_2024/extern/dynamic_user_capture.dart';
import 'package:scouting_app_2024/extern/string.dart';
import 'package:scouting_app_2024/shared.dart';
import 'package:scouting_app_2024/user/models/team_model.dart';
import 'package:theme_provider/theme_provider.dart';

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

final class SharedDialogsMatches {
  static void ducSharedDialog(
      BuildContext context, HollisticMatchScoutingData match) {
    Widget qr = _createPrettyQrDataWidget(data: match.toDucFormat());
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
                                text: match.toDucFormat())),
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

  static void qrSharedDialog(
      BuildContext context, HollisticMatchScoutingData match) {
    Widget qr = _createPrettyQrDataWidget(data: match.csvData);
    Widget? commentsQr;
    if (match.comments.isNotEmpty) {
      commentsQr =
          _createPrettyQrDataWidget(data: match.commentsCSVData);
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
                          ClipboardData(text: match.csvData)),
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
                            text: match.comments.comment),
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
                                text: match.commentsCSVData)),
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

  static void launchInsightView(
      BuildContext context, HollisticMatchScoutingData match) {
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
                          fontWeight: FontWeight.bold, fontSize: 20)),
                ]),
                const SizedBox(height: 8),
                Row(
                  children: <Widget>[
                    Flexible(
                      child: Text.rich(
                          TextSpan(children: <InlineSpan>[
                            const TextSpan(
                                text: "Scouter: ",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold)),
                            TextSpan(text: match.preliminary.scouter),
                            const TextSpan(
                                text: "\nTime: ",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold)),
                            TextSpan(
                                text: DateFormat(
                                        Shared.GENERAL_TIME_FORMAT)
                                    .format(DateTime
                                        .fromMillisecondsSinceEpoch(
                                            match.preliminary
                                                .timeStamp))),
                            const TextSpan(
                                text: "\nMatch: ",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold)),
                            TextSpan(
                                text:
                                    "${match.preliminary.matchType.name.formalize} #${match.preliminary.matchNumber}"),
                            const TextSpan(
                                text: "\nTeam: ",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold)),
                            TextSpan(
                                text:
                                    "${match.preliminary.teamNumber}"),
                            const TextSpan(
                                text: "\nAlliance: ",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold)),
                            TextSpan(
                                text: match.preliminary.alliance.name
                                    .formalize,
                                style: TextStyle(
                                    color: match.preliminary.alliance
                                        .toColor(),
                                    backgroundColor: Colors.black)),
                            const TextSpan(
                                text: "\nStarting Position: ",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold)),
                            TextSpan(
                                text: match.preliminary
                                    .startingPosition.name.formalize),
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
                          fontWeight: FontWeight.bold, fontSize: 20)),
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
                                text: match.auto.taxi ? "Yes" : "No"),
                            const TextSpan(
                                text: "\nScored Speaker: ",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold)),
                            TextSpan(
                                text: match.auto.scoredSpeaker
                                    .toString()),
                            const TextSpan(
                                text: "\nScored Amp: ",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold)),
                            TextSpan(
                                text:
                                    match.auto.scoredAmp.toString()),
                            const TextSpan(
                                text: "\nNotes Preloaded: ",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold)),
                            TextSpan(
                              text: match.auto.notePreloaded
                                  ? "Yes"
                                  : "No",
                            ),
                            const TextSpan(
                                text: "\nAMP Missed: ",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold)),
                            TextSpan(
                                text:
                                    match.auto.missedAmp.toString()),
                            const TextSpan(
                                text: "\nSpeaker Missed: ",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold)),
                            TextSpan(
                                text: match.auto.missedSpeaker
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
                          fontWeight: FontWeight.bold, fontSize: 20)),
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
                                text: match.teleop.scoredSpeaker
                                    .toString()),
                            const TextSpan(
                                text: "\nScored Amp: ",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold)),
                            TextSpan(
                                text: match.teleop.scoredAmp
                                    .toString()),
                            const TextSpan(
                                text: "\nPieces Scored: ",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold)),
                            TextSpan(
                                text: match.teleop.piecesScored
                                    .toString()),
                            const TextSpan(
                                text: "\nUnder Stage: ",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold)),
                            TextSpan(
                                text: match.teleop.underStage
                                    ? "Yes"
                                    : "No"),
                            const TextSpan(
                                text: "\nMissed Amp: ",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold)),
                            TextSpan(
                                text: match.teleop.missedAmp
                                    .toString()),
                            const TextSpan(
                                text: "\nMissed Speaker: ",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold)),
                            TextSpan(
                                text: match.teleop.missedSpeaker
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
                          fontWeight: FontWeight.bold, fontSize: 20)),
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
                                text: match
                                    .endgame.endState.name.formalize),
                            const TextSpan(
                                text: "\nHarmony: ",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold)),
                            TextSpan(
                                text: match
                                    .endgame.harmony.name.formalize),
                            const TextSpan(
                                text: "\nHarmony Attempted: ",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold)),
                            TextSpan(
                                text: match.endgame.harmonyAttempted
                                    ? "Yes"
                                    : "No"),
                            const TextSpan(
                                text: "\nTrap Scored: ",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold)),
                            TextSpan(
                                text: match.endgame.trapScored.name
                                    .formalize),
                            const TextSpan(
                                text: "\nCoopertition: ",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold)),
                            TextSpan(
                                text: match.misc.coopertition
                                    .toString()),
                            const TextSpan(
                                text: "\nMatch Result: ",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold)),
                            TextSpan(
                                text: match.endgame.matchResult.name
                                    .formalize),
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
                          fontWeight: FontWeight.bold, fontSize: 20)),
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
                                                const EdgeInsets.all(
                                                    2),
                                            child: Text(
                                                match.comments
                                                        .comment ??
                                                    "None",
                                                style:
                                                    const TextStyle(
                                                        fontSize: 16),
                                                softWrap: true),
                                          ))),
                                ]),
                            const TextSpan(
                                text: "\nID: ",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold)),
                            TextSpan(text: match.id),
                            const TextSpan(
                                text: "\nTimestamp: ",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold)),
                            TextSpan(
                                text: DateFormat(
                                        Shared.GENERAL_TIME_FORMAT)
                                    .format(DateTime
                                        .fromMillisecondsSinceEpoch(
                                            match.preliminary
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
                "Insights for match ${match.preliminary.matchNumber} of team ${match.preliminary.teamNumber}"),
          ],
        )),
      );
    }));
  }
}
