import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:scouting_app_2024/user/env.dart';
import 'package:scouting_app_2024/user/scouting_telemetry.dart';

import 'package:window_manager/window_manager.dart';

import 'package:scouting_app_2024/debug.dart';
import 'package:scouting_app_2024/parts/appview.dart';
import 'package:scouting_app_2024/parts/theme.dart';
import 'package:scouting_app_2024/shared.dart';
import 'package:scouting_app_2024/user/user_telemetry.dart';

const bool fixThisShit = true;

// no one change anything here please - exoad
void main() async {
  DateTime now = DateTime.now();
  // nothing should go above this comment besides the DateTime check
  WidgetsFlutterBinding.ensureInitialized();
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.presentError.call(details);
    Debug().warn("${details.summary} ${details.context}");
  };
  Debug().init();
  // I LOVE THE THEN FUNCTION OH MY GOD HOLY SHIT, I LOVE THIS FUNCTION, WE SHOULD MAKE EVERYTHING WITH THIS FUNCTION
  if (fixThisShit) {
    DeviceEnv.initItems().then((_) {
      Debug().init();
      Debug().info(
          "Loaded the Device Environment with: [DocPath=${DeviceEnv.documentsPath},CachePath=${DeviceEnv.cachePath}]");
      Hive.init(DeviceEnv.documentsPath);
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
  } else {
    await DeviceEnv.initItems();
    DeviceEnv.initializeAppSaveLocale().then((_) async {
      Debug().info(
          "Loaded the Device Environment with: [DocPath=${DeviceEnv.documentsPath},CachePath=${DeviceEnv.cachePath}]");
      await Hive.initFlutter(Shared.DEVICE_STORAGE_SUBDIR);
      const String boxName = "AmogusBoxTest";
      Hive.boxExists(boxName).then((bool v) async {
        if (v) {
          Debug().info("Exists");
        } else {
          Debug().info("Does not exist");
          if (Hive.isBoxOpen(boxName)) {
            Debug().info("Box is already opened");
          } else {
            Debug().info("Box is not opened");
            await Hive.openBox(boxName);
          }
        }
      });
    });
  }
}
