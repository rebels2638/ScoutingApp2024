import 'package:community_material_icon/community_material_icon.dart';
import 'package:flutter/material.dart';
import 'package:scouting_app_2024/parts/views_delegate.dart';
import "package:scouting_app_2024/blobs/form_blob.dart";
import 'package:scouting_app_2024/user/models/team_model.dart';
import "package:scouting_app_2024/blobs/locale_blob.dart";
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
        activeIcon: const Icon(Icons.history),
        icon: const Icon(Icons.history),
        label: "History",
        tooltip: "View data collected from past matches"
      )
    );
  }

  @override
  State<PastMatchesView> createState() => _PastMatchesViewState();
}

class _PastMatchesViewState extends State<PastMatchesView> {
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
    ScoutingTelemetry()
        .forEachHollistic((HollisticMatchScoutingData data) {
      matches.add(data);
    });

    setState(() {});
  }

  void removeMatch(int matchID) {
    setState(() {
      matches.removeWhere((HollisticMatchScoutingData m) =>
          m.preliminary.matchNumber == matchID);
    });
  }

  @protected
  late QrImage qrImage;

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
                  children: <Widget>[
                    IconButton(
                      icon: const Icon(Icons.delete_forever),
                      onPressed: () async =>
                          await launchConfirmDialog(
                        // deletes all matches
                        okLabel: "Delete",
                        denyLabel: "Cancel",
                        icon: const Icon(Icons.warning_amber_rounded),
                        title: "Confirm Deletion",
                        context,
                        message: const Text(
                            "Are you sure you want to delete all past matches? This action cannot be undone."),
                        onConfirm: () {
                          // TODO: delete all past matches from backend
                          setState(() {
                            matches.clear();
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text(
                                    "All past matches deleted.")),
                          );
                        },
                      ),
                    ),
                    IconButton(
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
                  ],
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
                      strut(height: 18),
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
                : ListView.builder(
                    itemCount: matches.length,
                    itemBuilder: (BuildContext context, int index) {
                      return MatchTile(
                        match: matches[index],
                        onDelete: removeMatch,
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class MatchTile extends StatelessWidget {
  final HollisticMatchScoutingData match;
  final Function(int) onDelete;

  const MatchTile(
      {super.key, required this.match, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: form_sec_2(
        context,
        backgroundColor: Colors.transparent,
        iconColor: TeamAlliance.blue.toColor(),
        header: (
          icon: Icons.flag_circle_rounded,
          title:
              "${formalizeWord(match.preliminary.matchType.name)} #${match.preliminary.matchNumber}: (Team X)" // remember to update
        ),
        child: form_col(<Widget>[
          form_label(
            'Transfer Options',
            child: Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: strutAll(<Widget>[
                  FilledButton(
                    child: const Text('Beam via Bluetooth'),
                    onPressed: () async => await launchConfirmDialog(
                        showOkLabel: false,
                        denyLabel: "Close",
                        icon: const Icon(Icons.warning_amber_rounded),
                        title: "Warning",
                        context,
                        message: const Text(
                            "Bluetooth feature not yet available!"),
                        onConfirm: () {}),
                  ),
                  FilledButton(
                    child: const Text('Generate QR Code'),
                    onPressed: () async {
                      /*
                      String matchData = matchDataToCsv(match);
                      Widget qrWidget = createPrettyQrDataWidget(
                        data: matchDataToCsv(match),
                        includeImage: true,
                      );
                      await launchConfirmDialog(
                        showOkLabel: false,
                        denyLabel: "Close",
                        icon: const Icon(Icons.cloud_sync),
                        title: "Transfer Scouting Data via QR Code",
                        context,
                        message: qrWidget,
                        onConfirm: () => Debug().info(
                            "PAST MATCHES: Popped QR Code Display for ${formalizeWord(match.matchType.name)} #${match.matchID}"),
                      );
                      */
                    },
                  ),
                  FilledButton(
                    onPressed: () async => await launchConfirmDialog(
                      showOkLabel: true,
                      okLabel: "Delete",
                      denyLabel: "No",
                      icon: const Icon(Icons.warning_amber_rounded),
                      title: "Delete Past Match",
                      context,
                      message: const Text(
                          "Are you sure you want to delete this match?"),
                      onConfirm: () {} /*onDelete(match.matchID)*/,
                    ),
                    child: const Text('Delete'),
                  ),
                  /*
                  ElevatedButton(
                    onPressed: () => onDelete(match.matchID),
                    child: const Text('Delete'),
                  ),
                  */
                ], width: 6),
              ),
            ),
            icon: const Icon(Icons.cell_tower),
          ),
          /**
          const SizedBox(
            height: 15,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text('Placeholder Text 1'),
                Text('Placeholder Text 2'),
                Text('Placeholder Text 3')
              ],
            ),
          ),
          **/
        ]),
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
