import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scouting_app_2024/debug.dart';
import 'package:scouting_app_2024/user/user_telemetry.dart';

class PreferTonalModal extends ChangeNotifier {
  bool _preferTonal = UserTelemetry().currentModel.preferTonal;

  bool get preferTonal => _preferTonal;

  void toggle() {
    Debug().info("Prefer Tonal: $_preferTonal -> ${!_preferTonal}");
    _preferTonal = !_preferTonal;
    notifyListeners();
  }

  set preferTonal(bool v) {
    Debug().info("Prefer Tonal: $_preferTonal -> $v");
    _preferTonal = v;
    notifyListeners();
  }

  static bool isTonalPreferred(BuildContext context) =>
      Provider.of<PreferTonalModal>(context)._preferTonal;
}
