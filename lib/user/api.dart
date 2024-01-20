import 'package:scouting_app_2024/user/team_model.dart';

class UserScoutingApi {
  static UserScoutingApi? _singleton;

  static void init(String userName) {
    _singleton = UserScoutingApi(
        scouterName: userName, models: <TeamModelBlock>[]);
  }

  static bool isInitialized() => _singleton != null;

  String scouterName;
  List<TeamModelBlock> models;

  UserScoutingApi({required this.scouterName, required this.models});
}

class UserEphemeralState {
  
}