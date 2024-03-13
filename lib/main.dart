import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:scouting_app_2024/parts/loader.dart';
import 'package:scouting_app_2024/user/awards/awards_telemetry.dart';
import 'package:scouting_app_2024/user/duc_telemetry.dart';
import 'package:scouting_app_2024/user/env.dart';
import 'package:scouting_app_2024/user/models/ephemeral_data.dart';
import 'package:scouting_app_2024/user/scouting_telemetry.dart';
import 'package:scouting_app_2024/utils.dart';
import 'package:platform_info/platform_info.dart';
import 'package:window_manager/window_manager.dart';
import 'package:scouting_app_2024/user/models/shared.dart';
import 'package:scouting_app_2024/debug.dart';
import 'package:scouting_app_2024/parts/theme.dart';
import 'package:scouting_app_2024/shared.dart';
import 'package:scouting_app_2024/user/user_telemetry.dart';

Future<void> _prepareAppLaunch() async {
  Debug().newPhase("DEVICE_ENV");
  await DeviceEnv.initItems();
  Debug().info(
      "Loaded the Device Environment with: [DocPath=${DeviceEnv.saveLocation.path},CachePath=${DeviceEnv.saveLocation.path}]");
  Debug().newPhase("LOAD_THEMES");
  // this is such a shit idea because we are using so many awaits lmao, who gives a fuck amirite? all ik is that it works "fine" and you shouldnt touch this shitty piece of code unless some cosmic ray flips some bit that fucks this up, so cha cha real smooth, keep your hands off of this
  await ThemeBlob.loadBuiltinThemes();
  await ThemeBlob.loadIntricateThemes();
  Debug().newPhase("LOAD_LOCALE");
  LocaleUtils.loadWordsRules();
  Debug().newPhase("INIT_BACKEND");
  Hive.init(DeviceEnv.saveLocation.path);
  Hive.registerAdapter(EphemeralScoutingDataAdapter());
  await ScoutingTelemetry().loadBoxes();
  await DucTelemetry()
      .loadBoxes(); // lol DucTelemetry is a carbon copy of ScoutingTelemetry
  Debug().newPhase("VALIDATE_BOXES");
  // eval all scouting stuffs
  ({bool res, List<String> failedIds}) r =
      ScoutingTelemetry().validateAllEntriesVersion();
  Debug().info("Current model version: $EPHEMERAL_MODELS_VERSION");
  Debug().warn(
      "Check validation for boxes is good? ${r.res} with ${r.failedIds.length} failed");
  for (String rr in r.failedIds) {
    Debug().warn(
        "[RMF] version_not_compatible -> $rr ($rr =/= $EPHEMERAL_MODELS_VERSION)");
    ScoutingTelemetry().deleteID(rr);
  }
  // eval all duc stuffs
  ({bool res, List<String> failedIds}) r2 =
      DucTelemetry().validateAllEntriesVersion();
  Debug().info("Current model version: $EPHEMERAL_MODELS_VERSION");
  Debug().warn(
      "[DUC_BOX] Check validation for boxes is good? ${r2.res} with ${r2.failedIds.length} failed");
  for (String rr in r2.failedIds) {
    Debug().warn(
        "[DUC_BOX RMF] version_not_compatible -> $rr ($rr =/= $EPHEMERAL_MODELS_VERSION)");
    DucTelemetry().deleteID(rr);
  }
  Debug().newPhase("LOAD_USER_TELEMETRY");
  await UserTelemetry().init();
  Debug().newPhase("LOAD_USER_AWARDS");
  await AwardsTelemetry().init();
  Debug().newPhase("HOOK_LIFECYCLE");
  WidgetsBinding.instance.addObserver(AppLifecycleListener(
      onStateChange: (AppLifecycleState value) =>
          Debug().warn("{APP_LIFE_CYCLE} => $value")));
  Debug().newPhase("APP_LAUNCH");
  Timer.periodic(
      const Duration(seconds: Shared.USER_USAGE_TIME_PROBE_PERIODIC),
      (Timer _) async {
    Debug().info("Probing user usage time...");
    UserTelemetry().currentModel.usedTimeHours +=
        Shared.USER_USAGE_TIME_PROBE_PERIODIC / 3600;
    if (Shared.SAVE_ON_PROBE) {
      await UserTelemetry().save();
      Debug().info("Saved probe time...");
    } else {
      Debug().warn(
          "Not saving probe time... Waiting for next save cycle.");
    }
  });
  Debug().newPhase("COMPATIBILITY_CHECK");
  if (DeviceEnv.isPhone) {
    Debug().warn("Detected MOBILE, forcing COMPACT");
    UserTelemetry().currentModel.preferCompact = true;
    UserTelemetry().currentModel.useAltLayout = true;
  }
}

late final DateTime APP_START_TIME;

// no one change anything here please - exoad
void main() async {
  APP_START_TIME = DateTime.now();
  // nothing should go above this comment besides the DateTime check
  WidgetsFlutterBinding.ensureInitialized();
  Debug().init(); // ! no change this position
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.presentError.call(details);
    Debug().warn("${details.summary} ${details.context}");
  };

  // I LOVE THE THEN FUNCTION OH MY GOD HOLY SHIT, I LOVE THIS FUNCTION, WE SHOULD MAKE EVERYTHING WITH THIS FUNCTION
  runApp(LoadingAppViewScreen(task: _prepareAppLaunch()));
  if (Platform.I.isWindows) {
    // ig we only support windows, so extern/platform.dart is fucking useless LMAO
    await WindowManager.instance.ensureInitialized();
    await windowManager.setTitle(
        "2638 Scout \"$APP_CANONICAL_NAME\" (Build $REBEL_ROBOTICS_APP_VERSION)");
  }
  Debug().info("""
  \nBEGIN
  =========================================
  PROCESSOR_COUNT  = ${Platform.I.numberOfProcessors}
  VERSION          = ${Platform.I.version}
  OPERATING_SYSTEM = ${Platform.I.operatingSystem}
  BUILD_MODE       = ${Platform.I.buildMode}
  LOCALE           = ${Platform.I.locale}
  IO_SUPPORT       = ${Platform.I.isIO ? "NON_WEB" : "WEB"}
  DESIGN           = ${Platform.I.isMaterial ? "Material" : Platform.I.isCupertino ? "Cupertino" : "Unknown"}
  =========================================
  END
  """);
}
