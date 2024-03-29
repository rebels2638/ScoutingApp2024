import 'package:hive/hive.dart';
import 'package:scouting_app_2024/debug.dart';
import 'package:scouting_app_2024/user/models/shared.dart';
import 'package:scouting_app_2024/user/models/team_model.dart';

part "ephemeral_data.g.dart";

@HiveType(typeId: 0)
class EphemeralScoutingData extends HiveObject {
  @HiveField(0)
  String compressedFormat;

  @HiveField(1)
  int telemetryVersion; // i highly strongly of the utmost do not recommend changing this programmatically unless it is for migration

  @HiveField(2)
  String id;

  EphemeralScoutingData(this.id,
      {required this.compressedFormat,
      this.telemetryVersion = EPHEMERAL_MODELS_VERSION}) {
    if (EPHEMERAL_MODELS_VERSION != telemetryVersion) {
      Debug().warn(
          "MatchData#$id was loaded with version $telemetryVersion which does not match $EPHEMERAL_MODELS_VERSION which can cause conflicts!");
    }
  }

  @override
  Future<void> save() {
    Debug().info("Saved ScoutingData$id");
    return super.save();
  }

  @override
  Future<void> delete() {
    Debug().info("Deleting ScoutingData$id");
    return super.delete();
  }

  factory EphemeralScoutingData.fromHollistic(
      HollisticMatchScoutingData data) {
    return EphemeralScoutingData(data.id,
        compressedFormat: data.toCompatibleFormat());
  }

  @override
  String toString() => "Scouting$id{$compressedFormat}";
}
