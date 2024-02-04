import 'dart:io';

import 'package:flutter/material.dart';
import 'package:bloc/bloc.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:scouting_app_2024/debug.dart';
import 'package:scouting_app_2024/parts/appview.dart';
import 'package:scouting_app_2024/shared.dart';
import 'package:scouting_app_2024/user/user_telemetry.dart';
import 'package:window_manager/window_manager.dart';

void main() async {
  DateTime now = DateTime.now();
  // nothing should go above this comment besides the DateTime check
  Get.put<UserTelemetry>(UserTelemetry());
  WidgetsFlutterBinding.ensureInitialized();
  GetStorage.init("RebelRobotics2638UserPreferenceTelemetryUnit");
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.presentError.call(details);
    Debug().warn("${details.summary} ${details.context}");
  };
  Debug().init();
  UserTelemetry().reset();
  UserTelemetry().init();
  Bloc.observer = const DebugObserver();
  const ThemedAppBundle app = ThemedAppBundle();
  runApp(app);
  if (Platform.isWindows) {
    await WindowManager.instance.ensureInitialized();
    await windowManager.setTitle(
        "2638 Scout \"$APP_CANONICAL_NAME\" (Build $REBEL_ROBOTICS_APP_VERSION)");
  }
  Debug().info(
      "Took ${DateTime.now().millisecondsSinceEpoch - now.millisecondsSinceEpoch} ms to launch the app...");
}
