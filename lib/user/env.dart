import 'package:path_provider/path_provider.dart';

class DeviceEnv {
  static late String documentsPath;
  static late String cachePath;

  static Future<void> initItems() async {
    documentsPath = (await getApplicationDocumentsDirectory()).path;
    cachePath = (await getApplicationCacheDirectory()).path;
  }
}
