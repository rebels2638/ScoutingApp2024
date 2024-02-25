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

enum MatchResult { win, loss, tie }

enum MatchStartingPosition { amp, middle, stage }

enum EndStatus { on_chain, on_stage, failed }

enum AutoPickup { amp, middle, stage, no }

enum Harmony { yes, no, missed }

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
  CommentsInfo comments;
  late String id;

  HollisticMatchScoutingData.idOptional(
      {required this.preliminary,
      required this.misc,
      required this.auto,
      required this.teleop,
      required this.endgame,
      required this.comments}) {
    Debug().warn("DEVELOPMENT FUNCTIONALITY IN PRODUCTION CODE");

    id = const Uuid().v1();
  }

  HollisticMatchScoutingData(
      {required this.preliminary,
      required this.misc,
      required this.auto,
      required this.teleop,
      required this.endgame,
      required this.comments,
      required this.id});

  @override
  String toString() {
    return "ID: $id Preliminary: ${preliminary.exportMap().toString()}\nAuto: ${auto.exportMap().toString()}\nTeleop: ${teleop.exportMap().toString()}\nEndgame: ${endgame.exportMap().toString()}\nComments:${comments.isNotEmpty ? comments.comment : "Empty"}";
  }

  /// VERY FUCKING EXPENSIVE ASS FUNCTION TO CALL LMAOOO
  String get csvData {
    StringBuffer header = StringBuffer();
    StringBuffer values = StringBuffer();
    // lol nested functions :D
    void writeValue(String prefix, Map<String, dynamic> map) {
      for (MapEntry<String, dynamic> entry in map.entries) {
        header.write(prefix);
        header.write(entry.key);
        header.write(",");
        if (entry.value is List<dynamic>) {
          for (int i = 0;
              i < (entry.value as List<dynamic>).length;
              i++) {
            dynamic curr = (entry.value as List<dynamic>)[i];
            values.write(curr is Enum ? curr.name : curr.toString());
            if (i != (entry.value as List<dynamic>).length - 1) {
              values.write("+");
            }
          }
        } else if (entry.value is Enum) {
          values.write((entry.value as Enum).name);
        } else {
          values.write(entry.value.toString());
        }
        values.write(",");
      }
    }

    Map<String, dynamic> preliminaryMap = preliminary.exportMap();
    preliminaryMap.remove("timestamp");
    writeValue("", preliminaryMap);
    writeValue("A", auto.exportMap());
    writeValue("T", teleop.exportMap());
    writeValue("E", endgame.exportMap());
    writeValue("M", misc.exportMap());
    String headerStr = header.toString();
    String valueStr = values.toString();
    if (headerStr.endsWith(",")) {
      headerStr = headerStr.substring(0, headerStr.length - 1);
    }
    if (valueStr.endsWith(",")) {
      valueStr = valueStr.substring(0, valueStr.length - 1);
    }
    return "$headerStr\n$valueStr";
  }

  String get commentsCSVData {
    return "Match,Team,Comment\n${comments.matchNumber},${comments.teamNumber},${comments.isEmpty ? "No Comments" : comments.comment!.trim().replaceAll(",", "_")}";
  }

  static HollisticMatchScoutingData fromCompatibleFormat(
      String rawData) {
    Debug().info("Decoding a hollistic match scouting data...");
    final Map<dynamic, dynamic> data =
        jsonDecode(rawData) as Map<dynamic, dynamic>;
    PrelimInfo prelim =
        PrelimInfo.fromCompatibleFormat(data["prelim"].toString());
    return HollisticMatchScoutingData(
      comments: data.containsKey("cmt")
          ? CommentsInfo.fromCompatibleFormat(data["cmt"].toString())
          : CommentsInfo.optional(
              associatedId: data["id"].toString(),
              matchNumber: prelim.matchNumber,
              teamNumber: prelim.teamNumber),
      preliminary: prelim,
      auto: AutoInfo.fromCompatibleFormat(data["auto"].toString()),
      teleop:
          TeleOpInfo.fromCompatibleFormat(data["tele"].toString()),
      endgame:
          EndgameInfo.fromCompatibleFormat(data["end"].toString()),
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
    Map<dynamic, dynamic> map = <dynamic, dynamic>{
      "id": id,
      "prelim": preliminary.toCompatibleFormat(),
      "auto": auto.toCompatibleFormat(),
      "tele": teleop.toCompatibleFormat(),
      "end": endgame.toCompatibleFormat(),
      "misc": misc.toCompatibleFormat()
    };
    if (comments.isNotEmpty) {
      map["cmt"] = comments.toCompatibleFormat();
    }
    return jsonEncode(map);
  }
}
