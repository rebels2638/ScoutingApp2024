import 'package:flutter/material.dart';

enum TeamAlliance {
  blue(0xFF2463B0),
  red(0xFFE92A2f);

  final int color;

  const TeamAlliance(this.color);

  Color toColor() => Color(color);
}

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

enum EndStatus { parked, onstage, failed}

enum AutoPickup { left, middle, right, none}

enum Harmony { yes, no, failed }

enum TrapScored { yes, no, missed }

class TeamMatchData {
  int matchID;
  MatchType matchType;
  MatchStartingPosition startingPosition;

  TeamMatchData(
      {required this.matchID,
      required this.matchType,
      required this.startingPosition});
}
