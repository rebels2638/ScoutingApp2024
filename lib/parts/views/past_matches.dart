import 'package:flutter/material.dart';
import 'package:scouting_app_2024/parts/views_delegate.dart';
import "package:scouting_app_2024/blobs/form_blob.dart";
import "package:scouting_app_2024/user/team_model.dart";
import "package:scouting_app_2024/blobs/locale_blob.dart";
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'package:scouting_app_2024/blobs/blobs.dart';
import 'package:scouting_app_2024/debug.dart';

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
  List<PastMatchesOverViewData> matches = <PastMatchesOverViewData>[];

  @override
  void initState() {
    super.initState();
    loadMatches();
    final QrCode qrCode = QrCode(
      8,
      QrErrorCorrectLevel.H,
    )..addData("test sample data");

    qrImage = QrImage(qrCode);
  }

//this is all from team_model.dart
  void loadMatches() {
    // todo, below just placeholder data
    matches = <PastMatchesOverViewData>[
      PastMatchesOverViewData(
        matchID: 1,
        matchType: MatchType.practice,
        startingPosition: MatchStartingPosition.left,
        endStatus: EndStatus.parked,
        autoPickup: AutoPickup.m,
        harmony: Harmony.yes,
        trapScored: TrapScored.missed,
      ),
      PastMatchesOverViewData(
        matchID: 2,
        matchType: MatchType.practice,
        startingPosition: MatchStartingPosition.middle,
        endStatus: EndStatus.parked,
        autoPickup: AutoPickup.m,
        harmony: Harmony.yes,
        trapScored: TrapScored.missed,
      ),
      PastMatchesOverViewData(
        matchID: 3,
        matchType: MatchType.qualification,
        startingPosition: MatchStartingPosition.right,
        endStatus: EndStatus.parked,
        autoPickup: AutoPickup.m,
        harmony: Harmony.yes,
        trapScored: TrapScored.missed,
      ),
      PastMatchesOverViewData(
        matchID: 4,
        matchType: MatchType.qualification,
        startingPosition: MatchStartingPosition.left,
        endStatus: EndStatus.parked,
        autoPickup: AutoPickup.m,
        harmony: Harmony.yes,
        trapScored: TrapScored.missed,
      ),
      PastMatchesOverViewData(
        matchID: 5,
        matchType: MatchType.playoff,
        startingPosition: MatchStartingPosition.middle,
        endStatus: EndStatus.parked,
        autoPickup: AutoPickup.m,
        harmony: Harmony.yes,
        trapScored: TrapScored.missed,
      ),
      PastMatchesOverViewData(
        matchID: 6,
        matchType: MatchType.playoff,
        startingPosition: MatchStartingPosition.right,
        endStatus: EndStatus.parked,
        autoPickup: AutoPickup.m,
        harmony: Harmony.yes,
        trapScored: TrapScored.missed,
      )
    ];

    setState(() {});
  }

  void removeMatch(int matchID) {
    setState(() {
      matches.removeWhere(
          (PastMatchesOverViewData m) => m.matchID == matchID);
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
                  children: [
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
                      onPressed: () {
                        // TODO: exports all matches?
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: matches.isEmpty
                ? const Center(
                    child: Text('No past matches available!'))
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
  final PastMatchesOverViewData match;
  final Function(int) onDelete;

  const MatchTile(
      {super.key, required this.match, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: form_sec(
        context,
        backgroundColor: Colors.transparent,
        header: (
          icon: (match.matchType == MatchType.practice)
              ? Icons.flag_circle
              : Icons.emoji_events,
          title:
              "${formalizeWord(match.matchType.name)} #${match.matchID}: (Team X)" // remember to update
        ),
        child: form_col(<Widget>[
          form_label(
            'Transfer Options',
            child: Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: strutAll(<Widget>[
                  ElevatedButton(
                    onPressed: () async => await launchConfirmDialog(
                        showOkLabel: false,
                        denyLabel: "Close",
                        icon: const Icon(Icons.warning_amber_rounded),
                        title: "Warning",
                        context,
                        message: const Text(
                            "Bluetooth feature not yet available!"),
                        onConfirm: () {}),
                    child: const Text('Beam via Bluetooth'),
                  ),
                  ElevatedButton(
                    child: const Text('Generate QR Code'),
                    onPressed: () async => await launchConfirmDialog(
                        showOkLabel: false,
                        denyLabel: "Close",
                        icon: const Icon(Icons.cloud_sync),
                        title: "Transfer Scouting Data via QR Code",
                        context,
                        message: PrettyQrView.data(
                          data: matchDataToCsv(match),
                          errorCorrectLevel: QrErrorCorrectLevel.H,
                          decoration: const PrettyQrDecoration(
                            shape: PrettyQrRoundedSymbol(
                              color: Color(0xFFFFFFFF),
                            ),
                            image: PrettyQrDecorationImage(
                              image: AssetImage(
                                  'assets/appicon_header.png'),
                              position:
                                  PrettyQrDecorationImagePosition
                                      .embedded,
                            ),
                          ),
                        ),
                        onConfirm: () => Debug().info(
                            "PAST MATCHES: Popped QR Code Display for ${formalizeWord(match.matchType.name)} #${match.matchID}")),
                  ),
                  ElevatedButton(
                    onPressed: () async => await launchConfirmDialog(
                      showOkLabel: true,
                      okLabel: "Delete",
                      denyLabel: "No",
                      icon: const Icon(Icons.warning_amber_rounded),
                      title: "Delete Past Match",
                      context,
                      message: const Text(
                          "Are you sure you want to delete this match?"),
                      onConfirm: () => onDelete(match.matchID),
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
        ]),
      ),
    );
  }
}

String matchDataToCsv(PastMatchesOverViewData match) {
  // Convert match data to csv for QR code export
  String csv =
      '${match.matchID},${match.matchType.name},${match.startingPosition.name},${match.endStatus.name},${match.autoPickup.name},${match.harmony.name},${match.trapScored.name},';

  return csv;
}
