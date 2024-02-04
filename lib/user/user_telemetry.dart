import 'dart:async';
import 'dart:convert';
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

  Future<void> init() async => await SharedPreferences.getInstance()
          .then((SharedPreferences e) {
        _prefs = e;
        if (isEmpty()) {
          reset();
        }
        _currentModel = UserPrefModel.fromJson(
            jsonDecode(_prefs.getString(userDBName)!));
        Debug().info(
            "${jsonDecode(_prefs.getString(userDBName)!).runtimeType} with the following content: ${_prefs.getString(userDBName)}");
        Debug().info(
            "Model ready with the following content: ${_currentModel.toJson().toString()}");
        Timer.periodic(const Duration(seconds: 10),
            (Timer timer) async {
          // this is kinda bad since we dont check if the objects are the same and if it already persists in storage lmao, its just wasting cpu time saving for no reason, whatever
          await save();
          Debug().info("Saved telemetry model");
        });
      });

  /// resets the model, but does not perform a save
  void reset() {
    _currentModel = UserPrefModel.defaultModel;
    save();
  }

  Future<void> save() async {
    await _prefs.setString(
        userDBName, jsonEncode(_currentModel.toJson()));
  }
}

// we dont really store this as json, i just want to have the easy to use mapping feature lmao
@JsonSerializable(ignoreUnannotated: true, checked: true)
class UserPrefModel {
  static final UserPrefModel defaultModel =
      UserPrefModel(selectedTheme: AvaliableThemes.default_dark);

  @JsonKey(required: true, defaultValue: AvaliableThemes.default_dark)
  AvaliableThemes selectedTheme;

  @JsonKey(required: false, defaultValue: false)
  bool showConsole;

  // make sure to run flutter pub run build_runner build
  UserPrefModel(
      {required this.selectedTheme, this.showConsole = false});

  factory UserPrefModel.fromJson(Map<String, dynamic> json) =>
      _$UserPrefModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserPrefModelToJson(this);
}
