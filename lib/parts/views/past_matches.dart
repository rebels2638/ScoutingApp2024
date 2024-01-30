import 'package:flutter/material.dart';
import 'package:scouting_app_2024/parts/views_delegate.dart';
import "package:scouting_app_2024/blobs/form_blob.dart";
import "package:scouting_app_2024/user/team_model.dart";
import "package:scouting_app_2024/blobs/locale_blob.dart";

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
  List<TeamMatchData> matches = [];

  @override
  void initState() {
    super.initState();
    loadMatches();
  }

  void loadMatches() {
    // todo, below just placeholder data
    matches = [
      TeamMatchData(matchID: 1, matchType: MatchType.practice, startingPosition: MatchStartingPosition.left),
      TeamMatchData(matchID: 2, matchType: MatchType.practice, startingPosition: MatchStartingPosition.middle),
      TeamMatchData(matchID: 3, matchType: MatchType.qualification, startingPosition: MatchStartingPosition.right),
      TeamMatchData(matchID: 4, matchType: MatchType.qualification, startingPosition: MatchStartingPosition.left),
      TeamMatchData(matchID: 5, matchType: MatchType.playoff, startingPosition: MatchStartingPosition.middle),
      TeamMatchData(matchID: 6, matchType: MatchType.playoff, startingPosition: MatchStartingPosition.right)
    ];

    setState(() {});
  }

  void removeMatch(int matchID) {
    setState(() {
      matches.removeWhere((m) => m.matchID == matchID);
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
                children: [
                  Icon(Icons.calendar_month),
                  SizedBox(width: 8.0),
                  Text("Past Matches", style: TextStyle(fontSize: 20.0)),
                ],
              ),
              Row(
                children: <Widget>[
                  IconButton(
                    icon: const Icon(Icons.delete_forever),
                    onPressed: () {
                      // TODO: deletes all matches, popup to confirm 
                    },
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
            ? const Center(child: Text('No past matches available!'))
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
  final TeamMatchData match;
  final Function(int) onDelete;

  const MatchTile({super.key, required this.match, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: form_sec(context,
        backgroundColor: Colors.transparent,
        header: (
          icon: Icons.emoji_events,
          title: "${formalizeWord(match.matchType.name)} #${match.matchID}: (Team X)"
        ),
        child: form_col(<Widget>[
          form_label(
            'Transfer Options',
            child: Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  ElevatedButton(
                    onPressed: () {
                      // TODO: send via bluetooth 
                    },
                    child: const Text('Beam via Bluetooth'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // TODO: generate QR code and display
                    },
                    child: const Text('Generate QR Code'),
                  ),
                  ElevatedButton(
                    onPressed: () => onDelete(match.matchID),
                    child: const Text('Delete'),
                  ),
                ],
              ),
            ),
            icon: const Icon(Icons.cell_tower),
          ),
          const SizedBox(
            height: 15, 
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text('Placeholder Text #1'),
                Text('Placeholder Text #2'),
                Text('Placeholder Text #3'),
                Text('Placeholder Text #4'),
              ],
            ),
          ),
        ]),
      ),
    );
  }
}

