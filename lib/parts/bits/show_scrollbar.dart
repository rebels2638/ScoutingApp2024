import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scouting_app_2024/debug.dart';
import 'package:scouting_app_2024/user/user_telemetry.dart';

class ShowScrollBarModal extends ChangeNotifier {
  bool _showScrollBar = UserTelemetry().currentModel.showScrollbar;

  bool get showingScrollbar => _showScrollBar;

  void toggle() {
    Debug().info(
        "Show Scrollbars: $_showScrollBar -> ${!_showScrollBar}");
    _showScrollBar = !_showScrollBar;
    notifyListeners();
  }

  set showingScrollbar(bool v) {
    Debug().info("Show Scrollbars: $_showScrollBar -> $v");
    _showScrollBar = v;
    notifyListeners();
  }

  static bool isShowingScrollbar(BuildContext context) =>
      Provider.of<ShowScrollBarModal>(context)._showScrollBar;
}
