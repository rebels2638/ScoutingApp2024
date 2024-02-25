import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scouting_app_2024/debug.dart';
import 'package:scouting_app_2024/user/user_telemetry.dart';

class ShowHintsGuideModal extends ChangeNotifier {
  bool _showingHints = UserTelemetry().currentModel.showHints;

  bool get showingHints => _showingHints;

  void toggle() {
    Debug().info(
        "Show Hints Guide: $_showingHints -> ${!_showingHints}");
    _showingHints = !_showingHints;
    notifyListeners();
  }

  set showingHints(bool v) {
    Debug().info("Show Hints Guide: $_showingHints -> $v");
    _showingHints = v;
    notifyListeners();
  }

  static bool isShowingHints(BuildContext context) =>
      Provider.of<ShowHintsGuideModal>(context)._showingHints;
}
