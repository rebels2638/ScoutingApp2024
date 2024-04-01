import 'package:scouting_app_2024/user/models/team_model.dart';

// there is a lot of repetitive shit here, forget about it
class MatchUtils {
  static Map<int, List<HollisticMatchScoutingData>> filterByTeam(
      List<HollisticMatchScoutingData> allMatches) {
    Map<int, List<HollisticMatchScoutingData>> temp =
        <int, List<HollisticMatchScoutingData>>{};
    for (HollisticMatchScoutingData r in allMatches) {
      if (temp.containsKey(r.preliminary.teamNumber)) {
        temp[r.preliminary.teamNumber]!.add(r);
      } else {
        temp[r.preliminary.teamNumber] = <HollisticMatchScoutingData>[
          r
        ];
      }
    }
    return temp;
  }
}
