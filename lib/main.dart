import 'package:flutter/material.dart';
import 'package:scouting_app_2024/debug.dart';
import 'package:scouting_app_2024/parts/appview.dart';

void main() {
  DateTime now = DateTime.now();
  WidgetsFlutterBinding.ensureInitialized();
  Debug().init();
  const ThemedAppBundle app = ThemedAppBundle();
  runApp(app);
  Debug().info(
      "Took ${DateTime.now().millisecondsSinceEpoch - now.millisecondsSinceEpoch} ms to launch the app...");
}
