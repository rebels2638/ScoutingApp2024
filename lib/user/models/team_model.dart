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

  /// VERY FUCKING EXPENSIVE ASS FUNCTION TO CALL LMAOOO
  String get csvData {
    const Map<String, String> compressionK = <String, String>{
      "speaker": "spker",
      "scored": "",
      "coopertition": "coop",
      "comments": "cmt",
      "timestamp": "time",
      "number": "#",
      "type": "T",
      "missed": "miss",
      "alliance": "color",
      "notespreloaded": "preload",
      "notespickedup": "picked",
      "playsdefense": "def",
      "wasdefended": "defed",
      "driverrating": "rting",
      "onchain": "chain",
      "breakdown": "brkdwn",
    };

    const Map<String, String> compressionV = <String, String>{
      "false": "n",
      "no": "n",
      "yes": "y",
      "true": "y",
      "qualification": "qual",
      "red": "r",
      "blue": "b",
      "middle": "m",
      "left": "l",
      "right": "r",
      "practice": "prac",
      "missed": "miss"
    };

    String sanitize(String value, Map<String, String> compression) {
      for (MapEntry<String, String> r in compression.entries) {
        value = value.toLowerCase().trim().replaceAll(r.key, r.value);
      }
      return value;
    }

    StringBuffer header = StringBuffer();
    StringBuffer values = StringBuffer();
    // lol nested functions :D
    void writeValue(String prefix, Map<String, dynamic> map) {
      for (MapEntry<String, dynamic> entry in map.entries) {
        header.write(prefix);
        header.write(sanitize(entry.key, compressionK));
        header.write(",");
        if (entry.value is List<dynamic>) {
          for (int i = 0;
              i < (entry.value as List<dynamic>).length;
              i++) {
            dynamic curr = (entry.value as List<dynamic>)[i];
            values.write(sanitize(
                curr is Enum ? curr.name : curr.toString(),
                compressionV));
            if (i != (entry.value as List<dynamic>).length - 1) {
              values.write("+");
            }
          }
        } else if (entry.value is Enum) {
          values.write(
              sanitize((entry.value as Enum).name, compressionV));
        } else {
          values
              .write(sanitize(entry.value.toString(), compressionV));
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
