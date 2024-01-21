import 'package:get_storage/get_storage.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:scouting_app_2024/parts/theme.dart';

part "user_telemetry.g.dart";

/// User Telemetry storage is based on MVC patterning
class UserTelemetry {
  static GetStorage device() =>
      GetStorage("RebelRobotics2638UserPreferenceTelemetryUnit");
  static final UserTelemetry _singleton = UserTelemetry._();
  factory UserTelemetry() => _singleton;
  UserTelemetry._();

  static late UserPrefModel currentModel;

  bool isEmpty() =>
      device().getKeys().length == 0 ||
      device().getValues().length ==
          0; // i feel like this is really bad

  void init() {}

  /// resets the model, but does not perform a save
  void reset() => currentModel = UserPrefModel.defaultModel;

  Future<void> save() async => await device().save();
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
