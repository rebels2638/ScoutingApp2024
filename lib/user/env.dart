import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:scouting_app_2024/debug.dart';
import 'package:scouting_app_2024/shared.dart';

class DeviceEnv {
  static late String documentsPath;
  static late String cachePath;

  static Future<void> initItems() async {
    documentsPath = (await getApplicationDocumentsDirectory()).path;
    cachePath = (await getApplicationCacheDirectory()).path;
  }

  static Future<String> initializeAppSaveLocale() async {
    Directory dir = (await (Shared.PREFER_DOCS_DIR && !Platform.isIOS
        ? getExternalStorageDirectory()
        : getApplicationCacheDirectory()))!;
    String path =
        "${dir.path}${Platform.pathSeparator}${Shared.DEVICE_STORAGE_SUBDIR}";
    Debug().info(
        "Found the storage location at $path. Now asking for perms?");
    if (Platform.isAndroid || Platform.isIOS) {
      PermissionStatus status = await Permission.storage.status;
      if (!status.isGranted) {
        await Permission.storage.request();
      }
    }
    if (!await Directory(path).exists()) {
      Directory(path).create(recursive: true);
      Debug().info("Created the storage location at $path");
    }
    return path;
  }
}
