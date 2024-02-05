import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scouting_app_2024/debug.dart';
import 'package:scouting_app_2024/user/user_telemetry.dart';

class ShowPastMatchesWhileLockedInModal extends ChangeNotifier {
  bool _showPastMatchesWhileLockedIn = UserTelemetry().currentModel.showPastMatchesWhileLockedIn;

  bool get showingPastMatchesWhileLockedIn => _showPastMatchesWhileLockedIn;

  void toggle() {
    Debug().info("Show game_map: $_showPastMatchesWhileLockedIn -> ${!_showPastMatchesWhileLockedIn}");
    _showPastMatchesWhileLockedIn = !_showPastMatchesWhileLockedIn;
    notifyListeners();
  }

  set showingPastMatchesWhileLockedIn(bool v) {
    Debug().info("Show game_map: $_showPastMatchesWhileLockedIn -> $v");
    _showPastMatchesWhileLockedIn = v;
    notifyListeners();
  }

  static bool isShowingPastMatches(BuildContext context) =>
      Provider.of<ShowPastMatchesWhileLockedInModal>(context)._showPastMatchesWhileLockedIn;
}
