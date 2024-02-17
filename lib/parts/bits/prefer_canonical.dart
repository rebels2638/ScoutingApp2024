import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scouting_app_2024/debug.dart';
import 'package:scouting_app_2024/user/user_telemetry.dart';

class PreferCanonicalModal extends ChangeNotifier {
  bool _preferCanonical = UserTelemetry().currentModel.preferTonal;

  bool get preferCanonical => _preferCanonical;

  void toggle() {
    Debug().info(
        "Prefer Canonical: $_preferCanonical -> ${!_preferCanonical}");
    _preferCanonical = !_preferCanonical;
    notifyListeners();
  }

  set preferCanonical(bool v) {
    Debug().info("Prefer Canonical: $_preferCanonical -> $v");
    _preferCanonical = v;
    notifyListeners();
  }

  static bool isCanonicalPreferred(BuildContext context) =>
      Provider.of<PreferCanonicalModal>(context)._preferCanonical;
}
