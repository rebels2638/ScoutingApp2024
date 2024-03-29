import 'package:hive_flutter/hive_flutter.dart';
import 'package:scouting_app_2024/debug.dart';
import 'package:scouting_app_2024/user/models/ephemeral_data.dart';
import 'package:scouting_app_2024/user/models/shared.dart';
import 'package:scouting_app_2024/user/models/team_model.dart';

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

  void forEachHollistic(
      void Function(HollisticMatchScoutingData data) cb) {
    for (EphemeralScoutingData data
        in _storedFinalizedMatches.values) {
      Debug().info("Found scattered match data: ${data.id}");
      cb.call(HollisticMatchScoutingData.fromCompatibleFormat(
          data.compressedFormat));
    }
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
        "Finished loading the 'storedFinalizedMatches' box containing ${_storedFinalizedMatches.length} entries. Found ${validateAllEntriesVersion().failedData.length} entries that had conflicting telemetry versions.");
  }

  int get length => _storedFinalizedMatches.length;

  Future<void> put(EphemeralScoutingData data) async {
    _storedFinalizedMatches.put(data.id, data).then(
        (_) => Debug().warn("OK. Saved an entry for scouting..."));
  }

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

  ({bool res, List<EphemeralScoutingData> failedData}) validateAllEntriesVersion() {
    List<EphemeralScoutingData> failedShits = <EphemeralScoutingData>[];
    for (int i = 0; i < _storedFinalizedMatches.length; i++) {
      if (_storedFinalizedMatches.getAt(i)!.telemetryVersion !=
          EPHEMERAL_MODELS_VERSION) {
        failedShits.add(_storedFinalizedMatches.getAt(i)!);
      }
    }
    return (res: failedShits.isEmpty, failedData: failedShits);
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

  Future<void> deleteID(String id) async {
    for (int i = 0; i < _storedFinalizedMatches.length; i++) {
      if (_storedFinalizedMatches.getAt(i)!.id == id) {
        await _storedFinalizedMatches.deleteAt(i).then((_) => Debug().warn("[BOX] Deleted the entry with ID: $id"));
        return;
      }
    }
  }

  Future<void> clear() async => await _storedFinalizedMatches.clear();
}
