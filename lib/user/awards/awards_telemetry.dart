import 'dart:async';
import 'dart:convert';

import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:scouting_app_2024/debug.dart';
import 'package:scouting_app_2024/shared.dart';

import 'package:fluentui_emoji_icon/fluentui_emoji_icon.dart';

part "awards_telemetry.g.dart";

const String _USER_TELEMETRY_BOX_NAME = "user_awards";

final class AwardsTelemetry {
  late Box<String> awardsTelemetryBox;

  static const String awardsDBName = "Rebels2638AppAwards";
  static final AwardsTelemetry _singleton = AwardsTelemetry._();
  factory AwardsTelemetry() => _singleton;
  AwardsTelemetry._();

  void resetHard() => awardsTelemetryBox.put(awardsDBName, "");

  static late AwardsModel _currentModel;

  bool isEmpty() =>
      awardsTelemetryBox.get(awardsDBName) ==
      null; // i feel like this is really bad

  // ignore: unnecessary_getters_setters
  AwardsModel get currentModel => _currentModel;

  set currentModel(AwardsModel model) => _currentModel = model;

  Future<void> init() async =>
      await Hive.openBox<String>(_USER_TELEMETRY_BOX_NAME)
          .then((Box<String> e) {
        awardsTelemetryBox = e;
        Debug().info(
            "Loading Awards Telemetry. Box content is: ${awardsTelemetryBox.values.toString()}");
        if (!awardsTelemetryBox.containsKey(awardsDBName)) {
          Debug()
              .warn("COULD NOT FIND USER_AWARDS, CREATING NEW MODEL");
          reset();
          save();
        } else {
          Debug().info("FOUND USER_AWARDS, LOADING MODEL");
          _currentModel = AwardsModel.fromJson(
              jsonDecode(awardsTelemetryBox.get(awardsDBName)!));
        }
        Debug().info(
            "USER_AWARDS:\nUnlocked Awards: ${_currentModel.unlockedAwards.length}\nLocked Awards: ${_currentModel.lockedAwards.length}");
        Debug().info(
            "Validating loaded awards against ${Award.allAwards.length} registered awards");
        if (Award.allAwards.isNotEmpty ||
            (currentModel.unlockedAwards.isNotEmpty &&
                currentModel.lockedAwards.isNotEmpty)) {
          for (String unlocked in currentModel.unlockedAwards) {
            if (Award.allAwards.entries
                .toList()
                .where(
                    (MapEntry<String, Award> e) => e.key == unlocked)
                .isEmpty) {
              Debug().warn(
                  "Award $unlocked is not registered, removing from unlocked list");
              currentModel.unlockedAwards.remove(unlocked);
            }
          }
          for (String locked in currentModel.lockedAwards) {
            if (Award.allAwards.entries
                .toList()
                .where((MapEntry<String, Award> e) => e.key == locked)
                .isEmpty) {
              Debug().warn(
                  "Award $locked is not registered, removing from locked list");
              currentModel.lockedAwards.remove(locked);
            }
          }
        } else {
          Debug().warn(
              "Validation for awards is not possible. Skipping.");
        }
        Timer.periodic(
            const Duration(seconds: Shared.USER_TELEMETRY_SAVE_CYCLE),
            (Timer _) async => await save());
      });

  /// resets the model, but does not perform a save
  void reset() {
    Debug().warn("Reset User Awards");
    _currentModel = AwardsModel.defaultModel;
  }

  bool isUnlocked(String award) =>
      _currentModel.unlockedAwards.contains(award);

  bool isLocked(String award) =>
      _currentModel.lockedAwards.contains(award);

  void unlock(String award) {
    if (isUnlocked(award)) {
      Debug().warn("Award $award is already unlocked, skipping");
      return;
    }
    if (isLocked(award)) {
      Debug().info("Unlocking Award $award");
      _currentModel.lockedAwards.remove(award);
    }
    Debug().info("Unlocking Award $award");
    _currentModel.unlockedAwards.add(award);
  }

  void lock(String award) {
    if (isLocked(award)) {
      Debug().warn("Award $award is already locked, skipping");
      return;
    }
    if (isUnlocked(award)) {
      Debug().info("Locking Award $award");
      _currentModel.unlockedAwards.remove(award);
    }
    Debug().info("Locking Award $award");
    _currentModel.lockedAwards.add(award);
  }

  Future<void> save() async {
    Debug().info(
        "Saving User Awards...Entries: ${_currentModel.toJson()}");
    await awardsTelemetryBox.put(
        awardsDBName, jsonEncode(_currentModel.toJson()));
  }
}

class Award {
  static final Map<String, Award> allAwards = <String, Award>{
    "first_launch": Award(
        description: "Launch the app for the first time",
        formalName: "First",
        icon: Fluents.flStar),
    "first_scouted_match": Award(
        description: "Scout a match for the first time",
        formalName: "Rookie",
        icon: Fluents.flPottedPlant),
    "dedicated_scouter_1": Award(
        description: "Scout 10 matches",
        formalName: "Dedicated Scouter",
        icon: Fluents.fl3rdPlaceMedal),
    "dedicated_scouter_2": Award(
        description: "Scout 25 matches",
        formalName: "Dedicated Scouter",
        icon: Fluents.fl2ndPlaceMedal),
    "dedicated_scouter_3": Award(
        description: "Scout 50 matches",
        formalName: "Dedicated Scouter",
        icon: Fluents.fl1stPlaceMedal),
    "progressive_scouter": Award(
        description: "Earn 5 awards",
        formalName: "Progressive Scouter",
        icon: Fluents.flTrophy),
  };

  final String _description;
  final String _formalName;
  final int? _timeUnlocked;
  final FluentData _icon;

  Award(
      {required String description,
      required String formalName,
      required FluentData icon,
      int? timeUnlocked})
      : _description = description,
        _formalName = formalName,
        _icon = icon,
        _timeUnlocked = timeUnlocked ?? -1 {
    final String id =
        formalName.toLowerCase().trim().replaceAll(" ", "_");
    Debug().info(
        "Registered Award: $_formalName as $id (IS UNLOCKED? $isUnlocked)");
  }

  String get description => _description;
  String get formalName => _formalName;
  FluentData get icon => _icon;
  int get timeUnlocked => _timeUnlocked ?? -1;
  bool get isUnlocked => timeUnlocked != -1;
}

@JsonSerializable(ignoreUnannotated: true, checked: true)
class AwardsModel {
  static final AwardsModel defaultModel = AwardsModel();

  @JsonKey(required: false, defaultValue: <String>[])
  List<String> unlockedAwards;

  @JsonKey(required: false, defaultValue: <String>[])
  List<String> lockedAwards;

  AwardsModel(
      {this.unlockedAwards = const <String>[],
      this.lockedAwards = const <String>[]});

  factory AwardsModel.fromJson(Map<String, dynamic> json) =>
      _$AwardsModelFromJson(json);

  Map<String, dynamic> toJson() => _$AwardsModelToJson(this);
}
