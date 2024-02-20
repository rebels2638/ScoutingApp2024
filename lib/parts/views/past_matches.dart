import 'package:community_material_icon/community_material_icon.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scouting_app_2024/parts/bits/prefer_canonical.dart';
import 'package:scouting_app_2024/parts/bits/prefer_compact.dart';
import 'package:scouting_app_2024/parts/bits/show_experimental.dart';
import 'package:scouting_app_2024/parts/views_delegate.dart';
import "package:scouting_app_2024/blobs/form_blob.dart";
import 'package:scouting_app_2024/shared.dart';
import 'package:scouting_app_2024/user/models/team_model.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'package:scouting_app_2024/blobs/blobs.dart';
import 'package:scouting_app_2024/debug.dart';
import 'package:scouting_app_2024/user/scouting_telemetry.dart';
import 'package:theme_provider/theme_provider.dart';
import 'package:intl/intl.dart';

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
  final List<String> _matchIdsCache = <String>[];

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
    ScoutingTelemetry()
        .forEachHollistic((HollisticMatchScoutingData match) {
      if (!_matchIdsCache.contains(match.id)) {
        Debug().info("PAST_MATCHES: Adding match ${match.id}");
        matches.add(match);
        _matchIdsCache.add(match.id);
      } else {
        Debug().warn(
            "PAST_MATCHES: Match ${match.id} already exists! Ignoring it");
      }
    });
    setState(() {});
  }

  void removeMatch(String id) {
    setState(() {
      matches
          .removeWhere((HollisticMatchScoutingData m) => m.id == id);
    });
    _matchIdsCache.removeWhere((String m) => m == id);
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
                        onPressed: () => loadMatches(),
                        icon: const Icon(Icons.refresh_rounded)),
                    IconButton.filledTonal(
                        icon: const Icon(Icons.delete_forever),
                        onPressed: () async =>
                            await launchAssuredConfirmDialog(context,
                                message:
                                    "Are you sure you want to DELETE ALL ${matches.length} entries?",
                                title:
                                    "Delete ${matches.length} entries",
                                onConfirm: () {
                              setState(() {
                                matches.clear();
                              });
                              _matchIdsCache.clear();
                              ScoutingTelemetry().clear();
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(
                                const SnackBar(
                                    content: Text(
                                        "All past matches deleted. Cleare")),
                              );
                            })),
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
                                .appBarTheme
                                .foregroundColor,
                            size: 64),
                        const SizedBox(height: 18),
                        // this is so badly optimized because we are calling a non compile const ThemeProvider.themeOf
                        Text.rich(
                            const TextSpan(children: <InlineSpan>[
                              TextSpan(
                                  text:
                                      "No past matches found...\n\n",
                                  style: TextStyle(
                                      fontSize: 28,
                                      fontWeight: FontWeight.w600)),
                              TextSpan(
                                  text:
                                      "Hint: \"maybe go scout a team?\" ~ Jack",
                                  style: TextStyle(
                                      fontStyle: FontStyle.italic))
                            ]),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: ThemeProvider.themeOf(context)
                                    .data
                                    .appBarTheme
                                    .foregroundColor))
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
                                      onConfirm: () => widget.onDelete
                                          .call(widget.match.id),
                                      message:
                                          "Are you sure want to delete THIS entry?",
                                      title: "Delete entry"), // TODO
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
