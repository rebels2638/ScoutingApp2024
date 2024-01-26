import 'dart:async';
import 'package:json_annotation/json_annotation.dart';
import 'package:scouting_app_2024/debug.dart';
import 'package:scouting_app_2024/parts/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

part "user_telemetry.g.dart";

/// User Telemetry storage is based on MVC patterning
class UserTelemetry {
  static SharedPreferences getPrefs() => UserTelemetry()._prefs;

  late final SharedPreferences _prefs;
  static const String userDBName = "Rebels2638AppUserTelemetry";
  static final UserTelemetry _singleton = UserTelemetry._();
  factory UserTelemetry() => _singleton;
  UserTelemetry._();

  static late UserPrefModel _currentModel;

  bool isEmpty() =>
      _prefs.getString(userDBName) == null ||
      _prefs
          .getString(userDBName)!
          .isEmpty; // i feel like this is really bad

  UserPrefModel get currentModel => _currentModel;

  void init() {
    SharedPreferences.getInstance()
        .then((SharedPreferences e) => _prefs = e);
    Timer.periodic(const Duration(seconds: 10), (Timer timer) async {
      Debug().info(
          "USER_TELEMETRY Saving UserTelemetry Model now. Values: ${_currentModel.toJson()}");
      await save();
      Debug().info(
          "UserTelemetry Received the following content: ${_prefs.getString(userDBName)}");
    });
  }

  /// resets the model, but does not perform a save
  void reset() => _currentModel = UserPrefModel.defaultModel;

  Future<void> save() async {
    for (MapEntry<String, dynamic> entry
        in _currentModel.toJson().entries) {
      Debug()
          .info("USER_TELEMETRY Writing ${entry.key}=${entry.value}");
      await _prefs.setString(userDBName, entry.value.toString());
    }
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
