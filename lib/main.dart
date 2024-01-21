import 'package:flutter/material.dart';
import 'package:bloc/bloc.dart';
import 'package:get/get.dart';
import 'package:scouting_app_2024/debug.dart';
import 'package:scouting_app_2024/parts/appview.dart';
import 'package:scouting_app_2024/user/user_telemetry.dart';

void main() {
  DateTime now = DateTime.now();
  // nothing should go above this comment besides the DateTime check
  Get.put<UserTelemetry>(UserTelemetry());
  WidgetsFlutterBinding.ensureInitialized();
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.presentError.call(details);
    Debug().warn(details.summary);
  };
  Debug().init();
  Bloc.observer = const DebugObserver();
  const ThemedAppBundle app = ThemedAppBundle();
  runApp(app);
  Debug().info(
      "Took ${DateTime.now().millisecondsSinceEpoch - now.millisecondsSinceEpoch} ms to launch the app...");
  Debug().info(
      "UserTelemetry Receiver Type: ${UserTelemetry.device().getKeys().runtimeType} with keys.length=${UserTelemetry.device().getKeys().length} and values.length=${UserTelemetry.device().getValues().length}");
}
