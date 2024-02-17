import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:scouting_app_2024/user/env.dart';
import 'package:scouting_app_2024/user/models/ephemeral_data.dart';
import 'package:scouting_app_2024/user/scouting_telemetry.dart';

import 'package:window_manager/window_manager.dart';

import 'package:scouting_app_2024/debug.dart';
import 'package:scouting_app_2024/parts/appview.dart';
import 'package:scouting_app_2024/parts/theme.dart';
import 'package:scouting_app_2024/shared.dart';
import 'package:scouting_app_2024/user/user_telemetry.dart';

const bool fixThisShit = true;

// no one change anything here please - exoad
void main() {
  DateTime now = DateTime.now();
  // nothing should go above this comment besides the DateTime check
  WidgetsFlutterBinding.ensureInitialized();
  Debug().init(); // ! no change this position
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.presentError.call(details);
    Debug().warn("${details.summary} ${details.context}");
  };
  // I LOVE THE THEN FUNCTION OH MY GOD HOLY SHIT, I LOVE THIS FUNCTION, WE SHOULD MAKE EVERYTHING WITH THIS FUNCTION
  if (fixThisShit) {
    Debug().newPhase("DEVICE_ENV");
    DeviceEnv.initItems().then((_) {
      Debug().info(
          "Loaded the Device Environment with: [DocPath=${DeviceEnv.saveLocation.path},CachePath=${DeviceEnv.saveLocation.path}]");
      Debug().newPhase("INIT_BACKEND");
      Hive.init(DeviceEnv.saveLocation.path);
      Hive.registerAdapter(EphemeralScoutingDataAdapter());
      ScoutingTelemetry().loadBoxes().then((_) {
        Debug().newPhase("LOAD_THEMES");
        // this is such a shit idea because we are using so many awaits lmao
        ThemeBlob.loadBuiltinThemes()
            .then((_) => ThemeBlob.loadIntricateThemes().then((_) {
                  Debug().newPhase("LOAD_USER_TELEMETRY");
                  UserTelemetry().init().then((_) async {
                    Bloc.observer = const DebugObserver();
                    const ThemedAppBundle app = ThemedAppBundle();
                    Debug().newPhase("APP");
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
                }));
      });
    });
  } else {
    DeviceEnv.initItems().then((_) {
      DeviceEnv.initializeAppSaveLocale().then((_) {
        Debug().info(
            "Loaded the Device Environment with: [SavePath=${DeviceEnv.saveLocation.path}]");
        Hive.init(DeviceEnv.saveLocation.path);
        const String boxName = "AmogusBoxTest";
        Hive.openBox(boxName);
      });
    });
  }
}
