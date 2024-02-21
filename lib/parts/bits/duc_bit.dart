import 'package:flutter/material.dart';
import 'package:scouting_app_2024/user/duc_telemetry.dart';
import 'package:scouting_app_2024/user/models/ephemeral_data.dart';
import 'package:scouting_app_2024/user/models/team_model.dart';

// this is stupid, but oh well (fuck you)
class DucBaseBit with ChangeNotifier {
  final List<HollisticMatchScoutingData> _data;

  DucBaseBit(this._data);

  int get length => _data.length;

  void forEach(void Function(HollisticMatchScoutingData e) r) {
    for (HollisticMatchScoutingData data in _data) {
      r.call(data);
    }
  }

  // hella expensive, like hella
  Future<void> save() async {
    await DucTelemetry().clear();
    for (HollisticMatchScoutingData r in _data) {
      await DucTelemetry()
          .put(EphemeralScoutingData.fromHollistic(r));
    }
  }

  void add(HollisticMatchScoutingData data) {
    _data.add(data);
    notifyListeners();
    save();
  }

  void remove(HollisticMatchScoutingData data) {
    _data.remove(data);
    notifyListeners();
    save();
  }

  void removeID(String id) {
    _data.removeWhere(
        (HollisticMatchScoutingData element) => element.id == id);
    notifyListeners();
    save();
  }

  List<HollisticMatchScoutingData> filter(
      bool Function(HollisticMatchScoutingData data) filter) {
    List<HollisticMatchScoutingData> temp =
        <HollisticMatchScoutingData>[];
    for (HollisticMatchScoutingData r in _data) {
      if (filter.call(r)) {
        temp.add(r);
      }
    }
    return temp;
  }
}
