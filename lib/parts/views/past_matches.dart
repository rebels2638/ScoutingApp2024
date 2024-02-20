import 'package:community_material_icon/community_material_icon.dart';
import 'package:flutter/material.dart';
import 'package:scouting_app_2024/parts/bits/prefer_compact.dart';
import 'package:scouting_app_2024/parts/bits/show_experimental.dart';
import 'package:scouting_app_2024/parts/views_delegate.dart';
import "package:scouting_app_2024/blobs/form_blob.dart";
import 'package:scouting_app_2024/user/models/team_bloc.dart';
import 'package:scouting_app_2024/user/models/team_model.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'package:scouting_app_2024/blobs/blobs.dart';
import 'package:scouting_app_2024/debug.dart';
import 'package:scouting_app_2024/user/scouting_telemetry.dart';
import 'package:theme_provider/theme_provider.dart';

class PastMatchesView extends StatefulWidget
    implements AppPageViewExporter {
  const PastMatchesView({super.key});

  @override
  ({
    Widget child,
    ({Icon activeIcon, Icon icon, String label, String tooltip}) item
  }) exportAppPageView() {
    return (
      child: this,
      item: (
        activeIcon: const Icon(Icons.receipt_rounded),
        icon: const Icon(Icons.receipt_outlined),
        label: "History",
        tooltip: "View data collected from past matches"
      )
    );
  }

  @override
  State<PastMatchesView> createState() => _PastMatchesViewState();
}

class _PastMatchesViewState extends State<PastMatchesView> {
  late QrImage qrImage;
  List<HollisticMatchScoutingData> matches =
      <HollisticMatchScoutingData>[];

  @override
  void initState() {
    super.initState();
    loadMatches();
  }

//this is all from team_model.dart
  void loadMatches() {
    // todo, below just placeholder data
    Debug().info(
        "PAST_MATCHES: Loading ${ScoutingTelemetry().length} past matches");
    matches.add(HollisticMatchScoutingData.idOptional(
        preliminary: PrelimInfo.optional(),
        misc: MiscInfo.optional(),
        auto: AutoInfo.optional(),
        teleop: TeleOpInfo.optional(),
        endgame: EndgameInfo.optional()));
    matches.add(HollisticMatchScoutingData.idOptional(
        preliminary: PrelimInfo.optional(),
        misc: MiscInfo.optional(),
        auto: AutoInfo.optional(),
        teleop: TeleOpInfo.optional(),
        endgame: EndgameInfo.optional()));

    setState(() {});
  }

  void removeMatch(int matchID) {
    setState(() {
      matches.removeWhere((HollisticMatchScoutingData m) =>
          m.preliminary.matchNumber == matchID);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                const Row(
                  children: <Widget>[
                    Icon(Icons.calendar_month),
                    SizedBox(width: 8.0),
                    Text("Past Matches",
                        style: TextStyle(fontSize: 20.0)),
                  ],
                ),
                Row(
                  children: strutAll(<Widget>[
                    IconButton.filledTonal(
                        onPressed: () {},
                        icon: const Icon(Icons.refresh_rounded)),
                    IconButton.filledTonal(
                      icon: const Icon(Icons.delete_forever),
                      onPressed: () async =>
                          await launchConfirmDialog(
                        // deletes all matches
                        okLabel: "Delete All",
                        denyLabel: "Cancel",
                        icon: const Icon(Icons.warning_amber_rounded),
                        title: "Confirm Deletion",
                        context,
                        message: const Text(
                            "Are you sure you want to delete all past matches? This action cannot be undone."),
                        onConfirm: () async =>
                            // TODO: delete all past matches from backend
                            await launchAssuredConfirmDialog(context,
                                message:
                                    "Are you sure you want to DELETE ALL entries?",
                                title: "Delete all entries",
                                onConfirm: () {
                          setState(() {
                            matches.clear();
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text(
                                    "All past matches deleted.")),
                          );
                        }),
                      ),
                    ),
                    IconButton.filledTonal(
                      icon: const Icon(Icons.download),
                      onPressed: () async {
                        /*
                        String exportData = matches
                            .map((PastMatchesOverViewData match) =>
                                matchDataToCsv(match))
                            .join("\n");
                        Widget qrWidget = createPrettyQrDataWidget(
                          data: exportData,
                          includeImage: false,
                        );
                        await launchConfirmDialog(
                          showOkLabel: false,
                          denyLabel: "Close",
                          icon: const Icon(Icons.cloud_sync),
                          title:
                              "Transfer All Scouting Data via QR Code",
                          context,
                          message: qrWidget,
                          onConfirm: () {},
                        );
                        */
                      },
                    ),
                  ], width: 14),
                ),
              ],
            ),
          ),
          Expanded(
              child: matches.isEmpty
                  ? Center(
                      child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(CommunityMaterialIcons.emoticon_sad,
                            color: ThemeProvider.themeOf(context)
                                .data
                                .secondaryHeaderColor,
                            size: 64),
                        const SizedBox(height: 18),
                        // this is so badly optimized because we are calling a non compile const ThemeProvider.themeOf
                        Text.rich(
                          TextSpan(children: <InlineSpan>[
                            TextSpan(
                                text: "No past matches found...\n\n",
                                style: TextStyle(
                                    color:
                                        ThemeProvider.themeOf(context)
                                            .data
                                            .secondaryHeaderColor,
                                    fontSize: 28,
                                    fontWeight: FontWeight.w600)),
                            TextSpan(
                                text:
                                    "Hint: \"maybe go scout a team?\" ~ Jack",
                                style: TextStyle(
                                    color:
                                        ThemeProvider.themeOf(context)
                                            .data
                                            .secondaryHeaderColor,
                                    fontStyle: FontStyle.italic))
                          ]),
                          textAlign: TextAlign.center,
                        )
                      ],
                    ))
                  : PreferCompactModal.isCompactPreferred(context)
                      ? Builder(
                          builder: (BuildContext context) {
                            List<Widget> widgets = <Widget>[];
                            for (HollisticMatchScoutingData match
                                in matches) {
                              Debug().info(
                                  "PAST_MATCHES: Adding match ${match.id}");
                              widgets.add(MatchTile(
                                match: match,
                                onDelete: removeMatch,
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
                      : RefreshIndicator(
                          onRefresh: () async =>
                              await Future<void>.delayed(
                                  const Duration(milliseconds: 750),
                                  () => loadMatches()),
                          displacement: 20,
                          child: ListView.builder(
                            physics:
                                const AlwaysScrollableScrollPhysics(
                                    parent: BouncingScrollPhysics(
                                        decelerationRate:
                                            ScrollDecelerationRate
                                                .normal)),
                            padding:
                                const EdgeInsets.only(bottom: 40),
                            itemCount: matches.length,
                            itemBuilder:
                                (BuildContext context, int index) {
                              return MatchTile(
                                match: matches[index],
                                onDelete: removeMatch,
                              );
                            },
                          ),
                        )),
        ],
      ),
    );
  }
}

class MatchTile extends StatefulWidget {
  final HollisticMatchScoutingData match;
  final Function(int) onDelete;

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
          iconColor: TeamAlliance.blue.toColor(),
          headerIcon: const Icon(Icons.flag_circle_rounded, size: 40),
          title: Text.rich(TextSpan(
              text: "{MatchType} {MatchNumber} | {TeamNumber}\n",
              style: const TextStyle(
                  fontWeight: FontWeight.w700, fontSize: 20),
              children: <InlineSpan>[
                const TextSpan(
                    text: "{hh}:{mm} {MM}/{DD}/{YYYY}",
                    style: TextStyle(
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
                    child: const Text.rich(
                        TextSpan(children: <InlineSpan>[
                      TextSpan(
                          text: "Starting Position: ",
                          style: TextStyle(
                              overflow: TextOverflow.ellipsis,
                              height: 1.6,
                              fontWeight: FontWeight.w700)),
                      TextSpan(
                          text: "{X}\n",
                          style: TextStyle(height: 1.6)),
                      TextSpan(
                          text: "Harmonized: ",
                          style: TextStyle(
                              overflow: TextOverflow.ellipsis,
                              height: 1.6,
                              fontWeight: FontWeight.w700)),
                      TextSpan(
                          text: "{X}\n",
                          style: TextStyle(
                              height: 1.6,
                              overflow: TextOverflow.ellipsis)),
                      TextSpan(
                          text: "Trap Scored: ",
                          style: TextStyle(
                              height: 1.6,
                              fontWeight: FontWeight.w700,
                              overflow: TextOverflow.ellipsis)),
                      TextSpan(
                          text: "{X}",
                          style: TextStyle(
                              height: 1.6,
                              overflow: TextOverflow.ellipsis)),
                    ]))),
                const SizedBox(height: 8),
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
                        if (ShowExperimentalModal
                            .isShowingExperimental(context))
                          if (PreferCompactModal.isCompactPreferred(
                              context))
                            FilledButton(
                              child:
                                  const Icon(Icons.bluetooth_rounded),
                              onPressed: () async =>
                                  await launchConfirmDialog(
                                      showOkLabel: false,
                                      denyLabel: "Close",
                                      icon: const Icon(Icons
                                          .warning_amber_rounded),
                                      title: "Warning",
                                      context,
                                      message: const Text(
                                          "Bluetooth feature not yet available!"),
                                      onConfirm: () {}),
                            )
                          else
                            FilledButton.icon(
                                onPressed: () async =>
                                    await launchConfirmDialog(
                                        showOkLabel: false,
                                        denyLabel: "Close",
                                        icon: const Icon(Icons
                                            .warning_amber_rounded),
                                        title: "Warning",
                                        context,
                                        message: const Text(
                                            "Bluetooth feature not yet available!"),
                                        onConfirm: () {}),
                                icon: const Icon(
                                    Icons.bluetooth_rounded),
                                label: const Text("Bluetooth Share")),
                        if (PreferCompactModal.isCompactPreferred(
                            context))
                          FilledButton(
                            child: const Icon(Icons.qr_code_rounded),
                            onPressed: () {}, // TODO,
                          )
                        else
                          FilledButton.icon(
                              onPressed: () {}, // TODO,
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
                                      onConfirm: () {},
                                      message:
                                          "Are you sure want to delete THIS entry?",
                                      title: "Delete entry"), // TODO
                              icon: const Icon(
                                  Icons.delete_forever_rounded),
                              label: const Text("Delete")),
                        /*
                    ElevatedButton(
                      onPressed: () => onDelete(match.matchID),
                      child: const Text('Delete'),
                    ),
                    */
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

/*
String matchDataToCsv(PastMatchesOverViewData match) {
  // Convert match data to csv for QR code export
  String csv =
      '${match.matchID},${match.matchType.name},${match.startingPosition.name},${match.endStatus.name},${match.autoPickup.name},${match.harmony.name},${match.trapScored.name} \n';

  return csv;
}
*/

Widget createPrettyQrDataWidget({
  required String data,
  bool includeImage = false,
}) {
  const PrettyQrDecoration decorationWithImage = PrettyQrDecoration(
    shape: PrettyQrRoundedSymbol(color: Color(0xFFFFFFFF)),
    image: PrettyQrDecorationImage(
      image: AssetImage('assets/appicon_header.png'),
      position: PrettyQrDecorationImagePosition.embedded,
    ),
  );
  const PrettyQrDecoration decorationWithoutImage =
      PrettyQrDecoration(
    shape: PrettyQrRoundedSymbol(color: Color(0xFFFFFFFF)),
  );
  return PrettyQrView.data(
    data: data,
    errorCorrectLevel: QrErrorCorrectLevel.H,
    decoration:
        includeImage ? decorationWithImage : decorationWithoutImage,
  );
}
