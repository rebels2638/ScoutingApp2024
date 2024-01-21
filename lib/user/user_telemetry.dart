import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class UserTelemetry {
  static GetStorage device() =>
      GetStorage("RebelRobotics2638UserPreferenceTelemetryUnit");
  static final UserTelemetry _singleton = UserTelemetry._();
  factory UserTelemetry() => _singleton;
  UserTelemetry._();

  void resetIfNew() {
    if (device().getKeys() == null) {
      reset();
    }
  }

  void reset() async {
    Get.find<UserTelemetry>().timestampsShowsMs.val = true;
    await UserTelemetry.device().save();
  }

  final ReadWriteValue<bool> timestampsShowsMs =
      true.val("timestampsShowsMs", getBox: device);
}
