import 'dart:async';
import 'package:get_storage/get_storage.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:scouting_app_2024/debug.dart';
import 'package:scouting_app_2024/parts/theme.dart';

part "user_telemetry.g.dart";

/// User Telemetry storage is based on MVC patterning
class UserTelemetry {
  static GetStorage device =
      GetStorage("RebelRobotics2638UserPreferenceTelemetryUnit");
  static final UserTelemetry _singleton = UserTelemetry._();
  factory UserTelemetry() => _singleton;
  UserTelemetry._();

  static late UserPrefModel _currentModel;

  bool isEmpty() =>
      device.getKeys().length == 0 ||
      device.getValues().length ==
          0; // i feel like this is really bad

  void init() {
    Timer.periodic(const Duration(seconds: 10), (Timer timer) async {
      Debug().info(
          "USER_TELEMETRY Saving UserTelemetry Model now. Values: ${_currentModel.toJson()}");
      await save();
      Debug().info(
          "UserTelemetry Receiver Type: ${UserTelemetry.device.getKeys().runtimeType} with keys.length=${UserTelemetry.device.getKeys().length} and values.length=${UserTelemetry.device.getValues().length}");
    });
  }

  /// resets the model, but does not perform a save
  void reset() => _currentModel = UserPrefModel.defaultModel;

  Future<void> save() async {
    for (MapEntry<String, dynamic> entry
        in _currentModel.toJson().entries) {
      Debug()
          .info("USER_TELEMETRY Writing ${entry.key}=${entry.value}");
      await device.write(entry.key, entry.value.toString());
    }
    // is this even necessary??? idek lets leave it here so we absolutely sure
    await device.save();
  }
}

// we dont really store this as json, i just want to have the easy to use mapping feature lmao
@JsonSerializable(ignoreUnannotated: true, checked: true)
class UserPrefModel {
  static final UserPrefModel defaultModel =
      UserPrefModel(selectedTheme: AvaliableThemes.default_dark);

  @JsonKey(required: true, defaultValue: AvaliableThemes.default_dark)
  AvaliableThemes selectedTheme;

  UserPrefModel({required this.selectedTheme});

  factory UserPrefModel.fromJson(Map<String, dynamic> json) =>
      _$UserPrefModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserPrefModelToJson(this);
}
