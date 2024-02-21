import 'package:hive/hive.dart';
import 'package:scouting_app_2024/debug.dart';
import 'package:scouting_app_2024/user/models/ephemeral_data.dart';
import 'package:scouting_app_2024/user/models/shared.dart';
import 'package:scouting_app_2024/user/models/team_model.dart';

const String _BOX_NAME = "duc_store";

class DucTelemetry {
  late Box<EphemeralScoutingData> _storedFinalizedMatches;

  static final DucTelemetry _singleton = DucTelemetry._();
  factory DucTelemetry() => _singleton;
  DucTelemetry._();

  Future<void> deleteDisk() async {
    Debug().warn("Deleting all past matches from disk...");
    _storedFinalizedMatches.deleteFromDisk();
  }

  void forEachHollistic(
      void Function(HollisticMatchScoutingData data) cb) {
    for (EphemeralScoutingData data
        in _storedFinalizedMatches.values) {
      Debug()
          .info("[DUC_BOX] Found scattered match data: ${data.id}");
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
          "[DUC_BOX] Failed to find the allocated Hive DB! Maybe this is the first time? Trying to set it manually [Fault: $e}]");
      _storedFinalizedMatches = await Hive.openBox(_BOX_NAME);
      _storedFinalizedMatches.flush();
    }
    Debug().info(
        "[DUC_BOX] Finished loading the 'storedFinalizedMatches' box containing ${_storedFinalizedMatches.length} entries. Found ${validateAllEntriesVersion().failedIds.length} entries that had conflicting telemetry versions.");
  }

  List<EphemeralScoutingData> get allEntries =>
      _storedFinalizedMatches.values.toList();

  List<HollisticMatchScoutingData> get allHollisticEntries {
    List<HollisticMatchScoutingData> temp =
        <HollisticMatchScoutingData>[];
    for (EphemeralScoutingData data
        in _storedFinalizedMatches.values) {
      temp.add(HollisticMatchScoutingData.fromCompatibleFormat(
          data.compressedFormat));
    }
    return temp;
  }

  int get length => _storedFinalizedMatches.length;

  Future<void> put(EphemeralScoutingData data) async {
    _storedFinalizedMatches.put(data.id, data).then((_) =>
        Debug().warn("[DUC_BOX] OK. Saved an entry for scouting..."));
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

  Future<void> deleteID(String id) async {
    for (int i = 0; i < _storedFinalizedMatches.length; i++) {
      if (_storedFinalizedMatches.getAt(i)!.id == id) {
        await _storedFinalizedMatches.deleteAt(i).then((_) =>
            Debug().warn("[DUC_BOX] Deleted the entry with ID: $id"));
        return;
      }
    }
  }

  Future<void> clear() async => await _storedFinalizedMatches.clear();
}
