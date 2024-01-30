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
        activeIcon: const Icon(Icons.fact_check_rounded),
        icon: const Icon(Icons.fact_check_outlined),
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
      appBar: AppBar( // A top menu for 'all' actions
        title: const Text('CRESCENDO 2024'), 
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.delete_forever),
            onPressed: () {
              // TODO: deletes all matches, popup to confirm 
            },
          ),
          IconButton(
            icon: Icon(Icons.download),
            onPressed: () {
              // TODO: exports all matches?
            },
          ),
        ],
      ),
      body: form_sec(
        context,
        backgroundColor: Colors.transparent,
        header: (icon: Icons.calendar_month, title: "Past Matches"),
        child: matches.isEmpty
          ? const Center(child: Text('No past matches available!'))
          : ListView.builder(
              itemCount: matches.length,
              shrinkWrap: true, 
              itemBuilder: (BuildContext context, int index) {
                return MatchTile(
                  match: matches[index],
                  onDelete: removeMatch,
                );
              },
            ),
      ),
    );
  }
}

class MatchTile extends StatelessWidget {
  final TeamMatchData match;
  final Function(int) onDelete;

  const MatchTile({Key? key, required this.match, required this.onDelete}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: form_col(<Widget>[
        form_label(
          '${formalizeWord(match.matchType.name)} #${match.matchID}: (Team X)',
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
          icon: Icon(Icons.stadium),
        ),
      ]),
    );
  }
}
