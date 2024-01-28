import 'package:flutter/material.dart';
import 'package:scouting_app_2024/debug.dart';

class PerformanceOverlayModal extends ChangeNotifier {
  bool _show = false;

  bool get show => _show;

  void toggle() {
    Debug().info("PerformanceOverlay: $_show -> ${!_show}");
    _show = !_show;
    notifyListeners();
  }
}
