import 'package:flutter/material.dart';
import 'package:scouting_app_2024/blobs/qr_converter_blob.dart';
import 'package:scouting_app_2024/user/models/team_bloc.dart';
import 'package:scouting_app_2024/shared.dart';

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
  List<PastMatchesOverViewData> matchData;

  TeamModelBlock(
      {required this.alliance,
      required this.number,
      required this.matchData,
      required this.timeStamp});

  bool playedMatch(int id) {
    bool r = false;
    for (PastMatchesOverViewData element in matchData) {
      r = element.matchID == id;
    }
    return r;
  }
}

enum MatchType { practice, qualification, playoff }

enum MatchStartingPosition { left, middle, right }

enum EndStatus { parked, onstage, failed }

enum AutoPickup { l, m, r, no }

enum Harmony { yes, no, failed }

enum TrapScored { yes, no, missed }

enum MicScored { yes, no, missed }

class HollisticMatchScoutingData {
  PrelimInfo preliminary;
  AutoInfo auto;
  TeleOpInfo teleop;
  EndgameInfo endgame;
  MiscInfo misc;
  late String id;

  HollisticMatchScoutingData({
    required this.preliminary,
    required this.misc,
    required this.auto,
    required this.teleop,
    required this.endgame,
  }) {
    id = Shared.uuid.v1();
  }

  @override
  String toString() {
    return "ID: $id Preliminary: ${preliminary.exportMap().toString()}\nAuto: ${auto.exportMap().toString()}\nTeleop: ${teleop.exportMap().toString()}\nEndgame: ${endgame.exportMap().toString()}";
  }
}

//for past_matches.dart
class PastMatchesOverViewData {
  // not hollistic
  int matchID;
  MatchType matchType;
  MatchStartingPosition startingPosition;
  EndStatus endStatus;
  AutoPickup autoPickup;
  Harmony harmony;
  TrapScored trapScored;

  PastMatchesOverViewData({
    required this.matchID,
    required this.matchType,
    required this.startingPosition,
    required this.endStatus,
    required this.autoPickup,
    required this.harmony,
    required this.trapScored,
  });
}
