import 'dart:async';
import 'dart:convert';
import 'package:json_annotation/json_annotation.dart';
import 'package:scouting_app_2024/debug.dart';
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

  void resetHard() => _prefs.setString(userDBName, "");

  static late UserPrefModel _currentModel;

  bool isEmpty() =>
      _prefs.getString(userDBName) ==
      null; // i feel like this is really bad

  UserPrefModel get currentModel => _currentModel;

  Future<void> init() async => await SharedPreferences.getInstance()
          .then((SharedPreferences e) {
        _prefs = e;
        try {
          if (_prefs.getString(userDBName) == null) {
            reset();
            save();
          } else {
            _currentModel = UserPrefModel.fromJson(
                jsonDecode(_prefs.getString(userDBName)!));
          }
        } catch (e) {
          _prefs.clear();
          reset();
          save();
        }
        Debug().info(
            "${jsonDecode(_prefs.getString(userDBName)!).runtimeType} with the following content: ${_prefs.getString(userDBName)}");
        Debug().info(
            "Model ready with the following content: ${_currentModel.toJson().toString()}");
        Timer.periodic(const Duration(seconds: 10),
            (Timer timer) async {
          // this is kinda bad since we dont check if the objects are the same and if it already persists in storage lmao, its just wasting cpu time saving for no reason, whatever
          await save();
        });
      });

  /// resets the model, but does not perform a save
  void reset() {
    _currentModel = UserPrefModel.defaultModel;
  }

  Future<void> save() async {
    Debug().info("Saving User Telemetry...");
    await _prefs
        .setString(userDBName, jsonEncode(_currentModel.toJson()))
        .then((bool success) {
      if (success) {
        Debug().info(
            "UserTelemetry saved OK! Content: ${_currentModel.toJson()}");
      } else {
        Debug().warn(
            "UserTelemetry save FAILED! Content: ${_currentModel.toJson()}");
      }
    });
  }
}

// we dont really store this as json, i just want to have the easy to use mapping feature lmao
@JsonSerializable(ignoreUnannotated: true, checked: true)
class UserPrefModel {
  static final UserPrefModel defaultModel =
      UserPrefModel(selectedTheme: "default_dark");

  // i hate hard coded values, but here we go down this rabbit hole again
  // this should be a theme's id
  @JsonKey(required: false, defaultValue: "default_dark")
  String selectedTheme;

  @JsonKey(required: false, defaultValue: false)
  bool showConsole;

  @JsonKey(required: false, defaultValue: true)
  bool showGameMap;

  @JsonKey(required: false, defaultValue: false)
  bool showExperimental;

  @JsonKey(required: false, defaultValue: false)
  bool showFPSMonitor;

  // make sure to run flutter pub run build_runner build
  UserPrefModel(
      {required this.selectedTheme,
      this.showConsole = false,
      this.showGameMap = true,
      this.showFPSMonitor = false,
      this.showExperimental = false});

  factory UserPrefModel.fromJson(Map<String, dynamic> json) =>
      _$UserPrefModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserPrefModelToJson(this);
}
