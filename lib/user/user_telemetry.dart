import 'dart:async';
import 'dart:convert';
import 'package:json_annotation/json_annotation.dart';
import 'package:scouting_app_2024/debug.dart';
import 'package:hive/hive.dart';
import 'package:scouting_app_2024/shared.dart';

part "user_telemetry.g.dart";

const String _USER_TELEMETRY_BOX_NAME = "user_preferences";

/// User Telemetry storage is based on MVC patterning
class UserTelemetry {
  late Box<String> userPrefsTelemetryBox;

  static const String userDBName = "Rebels2638AppUserTelemetry";
  static final UserTelemetry _singleton = UserTelemetry._();
  factory UserTelemetry() => _singleton;
  UserTelemetry._();

  void resetHard() => userPrefsTelemetryBox.put(userDBName, "");

  static late UserPrefModel _currentModel;

  bool isEmpty() =>
      userPrefsTelemetryBox.get(userDBName) ==
      null; // i feel like this is really bad

  // ignore: unnecessary_getters_setters
  UserPrefModel get currentModel => _currentModel;

  set currentModel(UserPrefModel model) => _currentModel = model;

  Future<void> init() async =>
      await Hive.openBox<String>(_USER_TELEMETRY_BOX_NAME)
          .then((Box<String> e) {
        userPrefsTelemetryBox = e;
        Debug().info(
            "Loading User Telemetry. Box content is: ${userPrefsTelemetryBox.values.toString()}");
        if (!userPrefsTelemetryBox.containsKey(userDBName)) {
          Debug()
              .warn("COULD NOT FIND USER_PREFS, CREATING NEW MODEL");
          reset();
          save();
        } else {
          Debug().info("FOUND USER_PREFS, LOADING MODEL");
          _currentModel = UserPrefModel.fromJson(
              jsonDecode(userPrefsTelemetryBox.get(userDBName)!));
        }
        Debug().warn(
            "Loaded the following contents for USER_PREF: ${_currentModel.toJson().toString()}");
        Timer.periodic(
            const Duration(seconds: Shared.USER_TELEMETRY_SAVE_CYCLE),
            (Timer _) async => await save());
      });

  /// resets the model, but does not perform a save
  void reset() {
    Debug().warn("Reset User Telemetry");
    _currentModel = UserPrefModel.defaultModel;
  }

  Future<void> save() async {
    Debug().info(
        "Saving User Telemetry...Entries: ${_currentModel.toJson()}");
    await userPrefsTelemetryBox.put(
        userDBName, jsonEncode(_currentModel.toJson()));
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

  @JsonKey(required: false, defaultValue: true)
  bool preferTonal;

  @JsonKey(required: false, defaultValue: true)
  bool preferCanonical;

  @JsonKey(required: false, defaultValue: false)
  bool preferCompact;

  @JsonKey(required: false, defaultValue: false)
  bool useAltLayout;

  @JsonKey(required: false, defaultValue: true)
  bool showHints;

  @JsonKey(required: false, defaultValue: 0)
  double usedTimeHours;

  @JsonKey(required: false, defaultValue: false)
  bool seenPatchNotes;

  @JsonKey(required: false, defaultValue: false)
  bool showScrollbar;

  @JsonKey(required: false, defaultValue: "Unspecified User")
  String profileName;

  @JsonKey(required: false, defaultValue: false)
  bool profileArmed;

  @JsonKey(required: false, defaultValue: "")
  String profileId;

  @JsonKey(required: false, defaultValue: 0)
  int totalScoutedMatches;

  // make sure to run flutter pub run build_runner build
  UserPrefModel(
      {required this.selectedTheme,
      this.showConsole = false,
      this.profileId = "",
      this.totalScoutedMatches = 0,
      this.showGameMap = true,
      this.useAltLayout = false,
      this.seenPatchNotes = false,
      this.profileArmed = false,
      this.profileName = "Unspecified User",
      this.usedTimeHours = 0,
      this.preferCompact = false,
      this.showScrollbar = false,
      this.preferTonal = true,
      this.showHints = true,
      this.preferCanonical = true,
      this.showFPSMonitor = false,
      this.showExperimental = false});

  factory UserPrefModel.fromJson(Map<String, dynamic> json) =>
      _$UserPrefModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserPrefModelToJson(this);
}
