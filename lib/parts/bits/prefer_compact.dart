import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scouting_app_2024/debug.dart';
import 'package:scouting_app_2024/user/user_telemetry.dart';

class PreferCompactModal extends ChangeNotifier {
  bool _preferCompact = UserTelemetry().currentModel.preferCompact;

  bool get preferCompact => _preferCompact;

  void toggle() {
    Debug().info(
        "Prefer Compact: $_preferCompact -> ${!_preferCompact}");
    _preferCompact = !_preferCompact;
    notifyListeners();
  }

  set preferCompact(bool v) {
    Debug().info("Prefer Compact: $_preferCompact -> $v");
    _preferCompact = v;
    notifyListeners();
  }

  static bool isCompactPreferred(BuildContext context) =>
      Provider.of<PreferCompactModal>(context)._preferCompact;
}
