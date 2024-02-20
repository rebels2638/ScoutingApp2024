import 'package:flutter/material.dart';
import 'package:scouting_app_2024/debug.dart';

class AppBarCelebrationModal extends ChangeNotifier {
  void toggle() {
    Debug().info("AppBarCelebrationModal: Shown!");
    notifyListeners();
  }
}
