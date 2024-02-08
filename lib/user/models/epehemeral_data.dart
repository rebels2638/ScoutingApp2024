import 'package:hive_flutter/hive_flutter.dart';
import 'package:scouting_app_2024/debug.dart';
import 'package:scouting_app_2024/extern/mystify_scoutinginfo.dart';
import 'package:scouting_app_2024/user/models/shared.dart';
import 'package:scouting_app_2024/user/models/team_model.dart';

@HiveType(typeId: 0)
class EphemeralScoutingData extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  Map<String, dynamic> prelim;

  @HiveField(2)
  Map<String, dynamic> auto;

  @HiveField(4)
  Map<String, dynamic> teleop;

  @HiveField(5)
  Map<String, dynamic> endgame;

  @HiveField(6)
  Map<String, dynamic> misc;

  @HiveField(7)
  int telemetryVersion; // i highly strongly of the utmost do not recommend changing this programmatically unless it is for migration

  EphemeralScoutingData(this.id,
      {required this.prelim,
      this.telemetryVersion = EPHEMERAL_MODELS_VERSION,
      required this.auto,
      required this.teleop,
      required this.endgame,
      required this.misc}) {
    if (EPHEMERAL_MODELS_VERSION != telemetryVersion) {
      Debug().warn(
          "MatchData#$id was loaded with version $telemetryVersion which does not match $EPHEMERAL_MODELS_VERSION which can cause conflicts!");
    }
  }

  factory EphemeralScoutingData.fromHollistic(
      HollisticMatchScoutingData data) {
    return EphemeralScoutingData(data.id,
        prelim: data.preliminary.breakDownComplex(),
        auto: data.auto.breakDownComplex(),
        teleop: data.teleop.breakDownComplex(),
        endgame: data.endgame.breakDownComplex(),
        misc: data.misc.breakDownComplex());
  }
}
