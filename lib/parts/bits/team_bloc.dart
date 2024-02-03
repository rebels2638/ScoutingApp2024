import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:scouting_app_2024/utils.dart';

abstract class ScoutingSessionState extends Equatable {
  @override
  List<dynamic> get props => <dynamic>[];
}

typedef res<B> = pair<bool,
    B>; // first value is whether data inputted is correct or not (this should be used for when input data type is very strict)

/// represents the intermediate representation of the data between
class ScoutedSession extends ScoutingSessionState {
  /// in ms since epoch
  int? timeStamp;
  String? scouters;
  res<int>? teamNumber;

}
