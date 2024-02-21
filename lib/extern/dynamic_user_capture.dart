import 'dart:convert';
import 'dart:io';

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
    return base64.encode(
        gzip.encode(utf8.encode("$_keyword${toCompatibleFormat()}")));
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
