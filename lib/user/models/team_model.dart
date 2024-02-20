import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:scouting_app_2024/blobs/qr_converter_blob.dart';
import 'package:scouting_app_2024/debug.dart';
import 'package:scouting_app_2024/user/models/team_bloc.dart';
import 'package:uuid/uuid.dart';

enum TeamAlliance {
  blue(0xFF2463B0),
  red(0xFFE92A2f);

  final int color;

  const TeamAlliance(this.color);

  Color toColor() => Color(color);
}

enum MatchType { practice, qualification, playoff }

enum MatchStartingPosition { left, middle, right }

enum EndStatus { parked, onstage, failed }

enum AutoPickup { l, m, r, no }

enum Harmony { yes, no, failed }

enum TrapScored { yes, no, missed }

enum MicScored { yes, no, missed }

class HollisticMatchScoutingData
    extends QRCompatibleData<HollisticMatchScoutingData>
    with QRCompressedCompatibleDataBlob<HollisticMatchScoutingData> {
  PrelimInfo preliminary;
  AutoInfo auto;
  TeleOpInfo teleop;
  EndgameInfo endgame;
  MiscInfo misc;
  late String id;

  HollisticMatchScoutingData.idOptional({
    required this.preliminary,
    required this.misc,
    required this.auto,
    required this.teleop,
    required this.endgame,
  }) {
    Debug().warn("DEVELOPMENT FUNCTIONALITY IN PRODUCTION CODE");

    id = const Uuid().v1();
  }

  HollisticMatchScoutingData(
      {required this.preliminary,
      required this.misc,
      required this.auto,
      required this.teleop,
      required this.endgame,
      required this.id});

  @override
  String toString() {
    return "ID: $id Preliminary: ${preliminary.exportMap().toString()}\nAuto: ${auto.exportMap().toString()}\nTeleop: ${teleop.exportMap().toString()}\nEndgame: ${endgame.exportMap().toString()}";
  }

  static HollisticMatchScoutingData fromCompatibleFormat(
      String rawData) {
    Debug().info("Decoding a hollistic match scouting data...");
    final Map<dynamic, dynamic> data =
        jsonDecode(rawData) as Map<dynamic, dynamic>;
    return HollisticMatchScoutingData(
      preliminary: PrelimInfo.fromCompatibleFormat(
          data["preliminary"].toString()),
      auto: AutoInfo.fromCompatibleFormat(data["auto"].toString()),
      teleop:
          TeleOpInfo.fromCompatibleFormat(data["teleop"].toString()),
      endgame: EndgameInfo.fromCompatibleFormat(
          data["endgame"].toString()),
      misc: MiscInfo.fromCompatibleFormat(data["misc"].toString()),
      id: data["id"].toString(),
    );
  }

  static HollisticMatchScoutingData fromCompressedCompatibleFormat(
      List<int> compressedData) {
    return HollisticMatchScoutingData.fromCompatibleFormat(
        utf8.decode(gzip.decode(compressedData)));
  }

  @override
  String toCompatibleFormat() {
    return jsonEncode(<dynamic, dynamic>{
      "id": id,
      "preliminary": preliminary.toCompatibleFormat(),
      "auto": auto.toCompatibleFormat(),
      "teleop": teleop.toCompatibleFormat(),
      "endgame": endgame.toCompatibleFormat(),
      "misc": misc.toCompatibleFormat()
    });
  }
}
