import 'dart:convert';
import 'dart:io';

import 'package:scouting_app_2024/debug.dart';
import 'package:scouting_app_2024/user/models/shared.dart';
import 'package:scouting_app_2024/user/models/team_model.dart';

/*
  __
<(o )___
 ( ._> /
  `---'
  __
<(o )___
 ( ._> /
  `---'
  __
<(o )___
 ( ._> /
  `---'
  __
<(o )___
 ( ._> /
  `---'
  __
<(o )___
 ( ._> /
  `---'
  __
<(o )___
 ( ._> /
  `---'
  __
<(o )___
 ( ._> /
  `---'

  quack quack quack
 */
const String _keyword = "dUc#";

extension DynamicUserCapture<T> on HollisticMatchScoutingData {
  String toDucFormat() {
    return "${EPHEMERAL_MODELS_VERSION.toString()}${base64.encode(gzip.encode(utf8.encode("$_keyword${toCompatibleFormat()}")))}";
  }

  static String? fromDucFormat(String duc) {
    return fromDucFormatExtern(duc);
  }

  bool isSimilar(HollisticMatchScoutingData other) {
    return id == other.id ||
        other.preliminary.timeStamp == preliminary.timeStamp ||
        (other.preliminary.alliance == preliminary.alliance &&
            other.preliminary.matchType == preliminary.matchType &&
            other.preliminary.matchNumber ==
                preliminary.matchNumber &&
            other.preliminary.teamNumber == preliminary.teamNumber);
  }
}

String? fromDucFormatExtern(String duc) {
  try {
    int version = int.parse(duc.substring(0, 1));
    if (version != EPHEMERAL_MODELS_VERSION) {
      Debug().info(
          "Encountered a version mismatch in DUC ($version != $EPHEMERAL_MODELS_VERSION) . Failing parse.");
      return null;
    }
    duc = duc.substring(1);
    String data = utf8.decode(gzip.decode(base64.decode(duc)));
    if (data.substring(0, _keyword.length) != _keyword) {
      return null; // L bozo issue
    } else {
      return data.substring(_keyword.length);
    }
  } on Exception catch (_) {
    return null;
  }
}
