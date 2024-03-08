import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:scouting_app_2024/debug.dart';
import 'package:scouting_app_2024/shared.dart';

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
            if (Award.allAwards
                .where((Award e) => e.identifier == unlocked)
                .isEmpty) {
              Debug().warn(
                  "Award $unlocked is not registered, removing from unlocked list");
              currentModel.unlockedAwards.remove(unlocked);
            }
          }
          for (String locked in currentModel.lockedAwards) {
            if (Award.allAwards
                .where((Award e) => e.identifier == locked)
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

  Future<void> save() async {
    Debug().info(
        "Saving User Awards...Entries: ${_currentModel.toJson()}");
    await awardsTelemetryBox.put(
        awardsDBName, jsonEncode(_currentModel.toJson()));
  }
}

abstract class Award {
  static final Set<Award> allAwards = <Award>{};

  final String _identifier;
  final String _description;
  final String _formalName;
  final int? _timeUnlocked;

  Award(
      {String? identifier,
      required String description,
      required String formalName,
      required int timeUnlocked})
      : _identifier = identifier ??
            formalName.toLowerCase().trim().replaceAll(" ", "_"),
        _description = description,
        _formalName = formalName,
        _timeUnlocked = timeUnlocked {
    Award.allAwards.add(this);
    Debug().info(
        "Registered Award: $_formalName as $_identifier (IS UNLOCKED? $isUnlocked)");
  }

  String get identifier => _identifier;
  String get description => _description;
  String get formalName => _formalName;
  Widget get icon;
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
