import 'package:flutter/material.dart';
import 'package:scouting_app_2024/parts/appview.dart';
import 'package:scouting_app_2024/parts/views_delegate.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  ensureViewsInitialized();
  runApp(const ThemedAppBundle());
}
