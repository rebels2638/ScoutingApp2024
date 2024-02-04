import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scouting_app_2024/debug.dart';
import 'package:scouting_app_2024/user/user_telemetry.dart';

class ShowGameMapModal extends ChangeNotifier {
  bool _showGameMap = UserTelemetry().currentModel.showGameMap;

  bool get showingGameMap => _showGameMap;

  void toggle() {
    Debug().info("Show game_map: $_showGameMap -> ${!_showGameMap}");
    _showGameMap = !_showGameMap;
    notifyListeners();
  }

  set showingGameMap(bool v) {
    Debug().info("Show game_map: $_showGameMap -> $v");
    _showGameMap = v;
    notifyListeners();
  }

  static bool isShowingConsole(BuildContext context) =>
      Provider.of<ShowGameMapModal>(context)._showGameMap;
}
