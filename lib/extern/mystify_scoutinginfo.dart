import 'package:scouting_app_2024/user/models/team_bloc.dart';

extension BrokenDownScoutingSessionData on ScoutingInfo {
  Map<String, dynamic> breakDownComplex(
      [bool encodeAsIndex = false]) {
    Map<String, dynamic> map = <String, dynamic>{};
    for (MapEntry<String, dynamic> r in exportMap().entries) {
      if (r.value is Enum) {
        map[r.key] = encodeAsIndex
            ? (r.value as Enum).index
            : (r.value as Enum).name;
      } else {
        map[r.key] = r.value;
      }
    }
    return map;
  }
}
