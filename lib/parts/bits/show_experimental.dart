import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scouting_app_2024/debug.dart';
import 'package:scouting_app_2024/user/user_telemetry.dart';

class ShowExperimentalModal extends ChangeNotifier {
  bool _showExperimental =
      UserTelemetry().currentModel.showExperimental;

  bool get showingExperimental => _showExperimental;

  void toggle() {
    Debug().info(
        "Show Experimental: $_showExperimental -> ${!_showExperimental}");
    _showExperimental = !_showExperimental;
    notifyListeners();
  }

  set showingExperimental(bool v) {
    Debug().info("Show Experimental: $_showExperimental -> $v");
    _showExperimental = v;
    notifyListeners();
  }

  static bool isShowingExperimental(BuildContext context) =>
      Provider.of<ShowExperimentalModal>(context)._showExperimental;
}