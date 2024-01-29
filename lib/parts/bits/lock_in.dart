import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scouting_app_2024/debug.dart';

class LockedInScoutingModal extends ChangeNotifier {
  bool _lockedIn = false;

  bool get lockedIn => _lockedIn;

  void toggle() {
    Debug().info("PerformanceOverlay: $_lockedIn -> ${!_lockedIn}");
    _lockedIn = !_lockedIn;
    notifyListeners();
  }

  static bool isCasual(BuildContext context) =>
      !Provider.of<LockedInScoutingModal>(context, listen: false)._lockedIn;
}
