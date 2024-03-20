import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scouting_app_2024/debug.dart';
import 'package:scouting_app_2024/user/user_telemetry.dart';

class ShowLegacyItemsModal extends ChangeNotifier {
  bool _showingLegacyItems =
      UserTelemetry().currentModel.showLegacyItems;

  bool get showingLegacyItems => _showingLegacyItems;

  void toggle() {
    Debug().info(
        "Show Legacy Items: $_showingLegacyItems -> ${!_showingLegacyItems}");
    _showingLegacyItems = !_showingLegacyItems;
    notifyListeners();
  }

  set showingLegacyItems(bool v) {
    Debug().info("Show Legacy Items: $_showingLegacyItems -> $v");
    _showingLegacyItems = v;
    notifyListeners();
  }

  static bool isShowingLegacyItems(BuildContext context) =>
      Provider.of<ShowLegacyItemsModal>(context)._showingLegacyItems;
}
