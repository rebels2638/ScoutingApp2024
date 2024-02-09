import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:scouting_app_2024/user/env.dart';
import 'package:scouting_app_2024/user/scouting_telemetry.dart';

import 'package:window_manager/window_manager.dart';

import 'package:scouting_app_2024/debug.dart';
import 'package:scouting_app_2024/parts/appview.dart';
import 'package:scouting_app_2024/parts/theme.dart';
import 'package:scouting_app_2024/shared.dart';
import 'package:scouting_app_2024/user/user_telemetry.dart';

// no one change anything here please - exoad
void main() async {
  DateTime now = DateTime.now();
  // nothing should go above this comment besides the DateTime check
  WidgetsFlutterBinding.ensureInitialized();
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.presentError.call(details);
    Debug().warn("${details.summary} ${details.context}");
  };
  // I LOVE THE THEN FUNCTION OH MY GOD HOLY SHIT, I LOVE THIS FUNCTION, WE SHOULD MAKE EVERYTHING WITH THIS FUNCTION
  DeviceEnv.initItems().then((_) {
    Debug().init();
    ScoutingTelemetry.initDb();
    ScoutingTelemetry().loadBoxes().then((_) =>
        // this is such a shit idea because we are using so many awaits lmao
        ThemeBlob.loadBuiltinThemes()
            .then((_) => ThemeBlob.loadIntricateThemes().then((_) {
                  UserTelemetry().init().then((_) async {
                    Bloc.observer = const DebugObserver();
                    const ThemedAppBundle app = ThemedAppBundle();
                    runApp(app);
                    if (Platform.isWindows) {
                      // ig we only support windows, so extern/platform.dart is fucking useless LMAO
                      await WindowManager.instance
                          .ensureInitialized();
                      await windowManager.setTitle(
                          "2638 Scout \"$APP_CANONICAL_NAME\" (Build $REBEL_ROBOTICS_APP_VERSION)");
                    }
                    Debug().info(
                        "Took ${DateTime.now().millisecondsSinceEpoch - now.millisecondsSinceEpoch} ms to launch the app...");
                  });
                })));
  });
}
