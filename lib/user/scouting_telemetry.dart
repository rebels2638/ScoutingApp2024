import 'package:hive_flutter/hive_flutter.dart';
import 'package:scouting_app_2024/debug.dart';
import 'package:scouting_app_2024/user/models/epehemeral_data.dart';
import 'package:scouting_app_2024/user/models/shared.dart';

class ScoutingTelemetry {
  late final Box<EphemeralScoutingData> _storedFinalizedMatches;

  static final ScoutingTelemetry _singleton = ScoutingTelemetry._();
  factory ScoutingTelemetry() => _singleton;
  ScoutingTelemetry._();

  static Future<void> initDb() async => await Hive.initFlutter();

  Future<void> loadBoxes() async {
    _storedFinalizedMatches =
        await Hive.openBox<EphemeralScoutingData>(
            "storedFinalizedMatches");
    Debug().info(
        "Finished loading the 'storedFinalizedMatches' box containing ${_storedFinalizedMatches.length} entries.");
  }

  Future<void> put(EphemeralScoutingData data) =>
      _storedFinalizedMatches.add(data);

  void forEach(void Function(EphemeralScoutingData? data) fx) {
    for (int i = 0; i < _storedFinalizedMatches.length; i++) {
      fx(_storedFinalizedMatches.getAt(i));
    }
  }

  ({bool res, List<String> failedIds}) validateAllEntriesVersion() {
    List<String> failedIds = <String>[];
    for (int i = 0; i < _storedFinalizedMatches.length; i++) {
      if (_storedFinalizedMatches.getAt(i)!.telemetryVersion !=
          EPHEMERAL_MODELS_VERSION) {
        failedIds.add(_storedFinalizedMatches.getAt(i)!.id);
      }
    }
    return (res: failedIds.isEmpty, failedIds: failedIds);
  }

  Future<EphemeralScoutingData?> searchFor(String id) async {
    for (int i = 0; i < _storedFinalizedMatches.length; i++) {
      if (_storedFinalizedMatches.getAt(i)!.id == id) {
        return _storedFinalizedMatches.getAt(i);
      }
    }
    return null;
  }

  Future<void> save(EphemeralScoutingData data) async {
    _storedFinalizedMatches.add(data);
    await data.save();
  }

  Future<void> delete(int index) async =>
      await _storedFinalizedMatches.deleteAt(index);

  Future<void> clear() async => await _storedFinalizedMatches.clear();
}
