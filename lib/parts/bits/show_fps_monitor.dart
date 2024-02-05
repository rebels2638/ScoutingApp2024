import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scouting_app_2024/debug.dart';
import 'package:scouting_app_2024/user/user_telemetry.dart';

class ShowFPSMonitorModal extends ChangeNotifier {
  bool _showFPSMonitor =
      UserTelemetry().currentModel.showFPSMonitor;

  bool get showingFPSMonitor => _showFPSMonitor;

  void toggle() {
    Debug().info(
        "Show FPSMonitor: $_showFPSMonitor -> ${!_showFPSMonitor}");
    _showFPSMonitor = !_showFPSMonitor;
    notifyListeners();
  }

  set showingFPSMonitor(bool v) {
    Debug().info("Show FPSMonitor: $_showFPSMonitor -> $v");
    _showFPSMonitor = v;
    notifyListeners();
  }

  static bool isShowingFPSMonitor(BuildContext context) =>
      Provider.of<ShowFPSMonitorModal>(context)._showFPSMonitor;
}