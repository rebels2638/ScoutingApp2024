import 'package:hive_flutter/hive_flutter.dart';
import 'package:scouting_app_2024/debug.dart';
import 'package:scouting_app_2024/user/models/epehemeral_data.dart';
import 'package:scouting_app_2024/user/models/shared.dart';

const String _BOX_NAME = "Argus_PMD";

class ScoutingTelemetry {
  late Box<EphemeralScoutingData> _storedFinalizedMatches;

  static final ScoutingTelemetry _singleton = ScoutingTelemetry._();
  factory ScoutingTelemetry() => _singleton;
  ScoutingTelemetry._();

  Future<void> deleteDisk() async {
    Debug().warn("Deleting all past matches from disk...");
    _storedFinalizedMatches.deleteFromDisk();
  }

  Future<void> loadBoxes() async {
    try {
      _storedFinalizedMatches =
          await Hive.openBox<EphemeralScoutingData>(_BOX_NAME);
    } catch (e) {
      Debug().warn(
          "Failed to find the allocated Hive DB! Maybe this is the first time? Trying to set it manually [Fault: $e}]");
      _storedFinalizedMatches = await Hive.openBox(_BOX_NAME);
      _storedFinalizedMatches.flush();
    }
    Debug().info(
        "Finished loading the 'storedFinalizedMatches' box containing ${_storedFinalizedMatches.length} entries. Found ${validateAllEntriesVersion().failedIds.length} entries that had conflicting telemetry versions.");
  }

  Future<void> put(EphemeralScoutingData data) async {}

  void forEach(void Function(EphemeralScoutingData? data) fx) {
    for (int i = 0; i < _storedFinalizedMatches.length; i++) {
      fx(_storedFinalizedMatches.getAt(i));
    }
  }

  bool hasFailingTelemetryVersions() {
    for (int i = 0; i < _storedFinalizedMatches.length; i++) {
      if (_storedFinalizedMatches.getAt(i)!.telemetryVersion !=
          EPHEMERAL_MODELS_VERSION) {
        return true;
      }
    }
    return false;
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
