import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scouting_app_2024/debug.dart';
import 'package:scouting_app_2024/user/user_telemetry.dart';

class UseAlternativeLayoutModal extends ChangeNotifier {
  bool _useAlt = UserTelemetry().currentModel.useAltLayout;

  bool get useAlt => _useAlt;

  void toggle() {
    Debug().info("Use AltLayout: $_useAlt -> ${!_useAlt}");
    _useAlt = !_useAlt;
    notifyListeners();
  }

  set useAlt(bool v) {
    Debug().info("Use AltLayout: $_useAlt -> $v");
    _useAlt = v;
    notifyListeners();
  }

  static bool isAlternativeLayoutPreferred(BuildContext context) =>
      Provider.of<UseAlternativeLayoutModal>(context)._useAlt;
}
