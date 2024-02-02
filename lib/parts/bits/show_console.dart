import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scouting_app_2024/debug.dart';

class ShowConsoleModal extends ChangeNotifier {
  bool _showConsole = false;

  bool get showingConsole => _showConsole;

  void toggle() {
    Debug().info("Show console: $_showConsole -> ${!_showConsole}");
    _showConsole = !_showConsole;
    notifyListeners();
  }

  set showingConsole(bool v) {
    Debug().info("Show console: $_showConsole -> $v");
    _showConsole = v;
    notifyListeners();
  }

  static bool isShowingConsole(BuildContext context) =>
      Provider.of<ShowConsoleModal>(context)._showConsole;
}