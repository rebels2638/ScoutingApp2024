enum TeamAlliance { blue, red }

class TeamModelBlock {
  TeamAlliance alliance;
  int number;
  DateTime timeStamp;
  List<TeamMatchData> matchData;

  TeamModelBlock(
      {required this.alliance,
      required this.number,
      required this.matchData,
      required this.timeStamp});

  bool playedMatch(int id) {
    bool r = false;
    for (TeamMatchData element in matchData) {
      r = element.matchID == id;
    }
    return r;
  }
}

enum MatchType { practice, qualification, playoff }

enum MatchStartingPosition { left, middle, right }

class TeamMatchData {
  int matchID;
  MatchType matchType;
  MatchStartingPosition startingPosition;

  TeamMatchData(
      {required this.matchID,
      required this.matchType,
      required this.startingPosition});
}