import 'dart:async';

import 'package:flutter/material.dart';
import 'package:scouting_app_2024/debug.dart';
import 'package:scouting_app_2024/shared.dart';
import 'package:scouting_app_2024/user/duc_telemetry.dart';
import 'package:scouting_app_2024/user/models/ephemeral_data.dart';
import 'package:scouting_app_2024/user/models/team_model.dart';

// this is stupid, but oh well (fuck you)
class DucBaseBit with ChangeNotifier {
  final List<HollisticMatchScoutingData> _data;

  DucBaseBit(this._data) {
    Timer.periodic(const Duration(seconds: Shared.DUC_SAVE_PERIOD),
        (_) async {
      Debug().info("[DUC] Saving AUTOMATICALLY");
      await save();
    });
  }

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

  bool containsID(String id) {
    for (HollisticMatchScoutingData r in _data) {
      if (r.id == id) {
        return true;
      }
    }
    return false;
  }

  void add(HollisticMatchScoutingData data) {
    _data.add(data);
    notifyListeners();
    save();
  }

  Future<void> removeAll() async {
    _data.clear();
    await DucTelemetry().clear();
    notifyListeners();
  }

  Future<void> removeWhere(
      bool Function(HollisticMatchScoutingData data) filter) async {
    _data.removeWhere(filter);
    await save();
    notifyListeners();
  }

  Future<void> remove(HollisticMatchScoutingData data) async {
    _data.remove(data);
    save();
    notifyListeners();
  }

  Future<void> removeID(String id) async {
    _data.removeWhere(
        (HollisticMatchScoutingData element) => element.id == id);
    notifyListeners();
    await save();
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
