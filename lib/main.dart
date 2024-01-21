import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scouting_app_2024/debug.dart';
import 'package:scouting_app_2024/parts/appview.dart';
import 'package:scouting_app_2024/user/user_telemetry.dart';

void main() {
  Get.put<UserTelemetry>(UserTelemetry());
  DateTime now = DateTime.now();
  WidgetsFlutterBinding.ensureInitialized();
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.presentError.call(details);
    Debug().warn(details.summary);
  };
  Debug().init();
  const ThemedAppBundle app = ThemedAppBundle();
  runApp(app);
  Debug().info(
      "Took ${DateTime.now().millisecondsSinceEpoch - now.millisecondsSinceEpoch} ms to launch the app...");
  UserTelemetry().reset();
  Debug().info(
      "UserTelemetry Receiver Type: ${UserTelemetry.device().getKeys().runtimeType}");
}
