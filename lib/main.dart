import 'package:flutter/material.dart';
import 'package:scouting_app_2024/blobs/debug.dart';
import 'package:scouting_app_2024/parts/appview.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Debug().init();
  final ThemedAppBundle app = ThemedAppBundle();
  runApp(app);
}
