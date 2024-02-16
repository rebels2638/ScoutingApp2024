import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:scouting_app_2024/debug.dart';
import 'package:scouting_app_2024/shared.dart';

class DeviceEnv {
  static late String documentsPath;
  static late String cachePath;

  static Future<void> initItems() async {
    documentsPath = (await getApplicationDocumentsDirectory()).path;
    cachePath = (await getApplicationCacheDirectory()).path;
  }

  static Future<void> initializeAppSaveLocale() async {
    Directory dir = await (Shared.PREFER_DOCS_DIR
        ? getApplicationDocumentsDirectory()
        : getApplicationCacheDirectory());
    String path =
        "${dir.path}${Platform.pathSeparator}${Shared.DEVICE_STORAGE_SUBDIR}";
    Debug().info("Found the storage location at $path");
    if (!await Directory(path).exists()) {
      Directory(path).create(recursive: true);
      Debug().info("Created the storage location at $path");
    }
  }
}
